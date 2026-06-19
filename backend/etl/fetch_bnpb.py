import requests
import json
import time
from models.db import get_connection

# Correct BNPB InaRISK server base URL (NOT /arcgis/)
BNPB_BASE = "https://gis.bnpb.go.id/server/rest/services/inarisk"

# Primary: DIBI Hidromet Feature Layer (Kabupaten-level flood data, vector polygon, SRID 4326)
DIBI_KABUPATEN_URL = f"{BNPB_BASE}/DIBI_Hidromet_2015_2024/MapServer/1/query"

# Secondary: Batas Administrasi Kecamatan Feature Layer (vector polygon)
ADMIN_KECAMATAN_URL = f"{BNPB_BASE}/batas_administrasi/MapServer/3/query"

# DKI Jakarta bounding box for spatial filter
JAKARTA_BBOX = "106.65,-6.38,107.00,-6.05"

# Request timeout (BNPB server is slow)
REQUEST_TIMEOUT = 120


def run_bnpb_etl():
    """
    Fetch ALL flood hazard data for DKI Jakarta from BNPB InaRISK ArcGIS REST API.

    Strategy:
    1. Try DIBI_Hidromet_2015_2024 Kabupaten Feature Layer (vector polygon with flood event counts)
       Filter: PROVINSI='DKI JAKARTA' or spatial bbox for Jakarta
    2. If DIBI fails, try batas_administrasi Kecamatan layer with spatial filter for Jakarta,
       and generate synthetic flood risk zones based on elevation/location
    3. If both fail, generate comprehensive local dummy data as fallback
    """
    print("=" * 60)
    print("SIGANA ETL: Starting BNPB flood data fetch for DKI Jakarta")
    print("=" * 60)

    # === Attempt 1: DIBI Hidromet Kabupaten layer ===
    features = fetch_dibi_flood_data()
    if features:
        inserted = insert_flood_features(features, 'BNPB-DIBI')
        print(f"\n[SUCCESS] DIBI ETL complete. {len(features)} fetched, {inserted} inserted.")
        return inserted

    # === Attempt 2: Admin Kecamatan boundaries + synthetic risk ===
    print("\n[INFO] DIBI failed. Trying batas_administrasi kecamatan layer...")
    features = fetch_admin_as_flood_zones()
    if features:
        inserted = insert_flood_features(features, 'BNPB-ADMIN')
        print(f"\n[SUCCESS] Admin ETL complete. {len(features)} fetched, {inserted} inserted.")
        return inserted

    # === Attempt 3: Local fallback with comprehensive dummy data ===
    print("\n[INFO] All BNPB endpoints failed. Using local fallback data.")
    inserted = insert_local_fallback_data()
    print(f"\n[SUCCESS] Local fallback complete. {inserted} records inserted.")
    return inserted


def fetch_with_retry(url, params, max_retries=3, delay=2):
    """
    Fetch URL with retry logic. Returns response object or None.
    """
    for attempt in range(max_retries):
        try:
            print(f"  Request attempt {attempt + 1}/{max_retries}...")
            resp = requests.get(url, params=params, timeout=REQUEST_TIMEOUT)
            resp.raise_for_status()
            return resp
        except requests.exceptions.Timeout:
            print(f"  Timeout on attempt {attempt + 1}. Retrying in {delay}s...")
            time.sleep(delay)
        except requests.exceptions.HTTPError as e:
            print(f"  HTTP error on attempt {attempt + 1}: {e}")
            time.sleep(delay)
        except requests.exceptions.ConnectionError as e:
            print(f"  Connection error on attempt {attempt + 1}: {e}")
            time.sleep(delay)
        except Exception as e:
            print(f"  Unexpected error on attempt {attempt + 1}: {e}")
            time.sleep(delay)
    return None


def fetch_dibi_flood_data():
    """
    Fetch flood data from DIBI_Hidromet_2015_2024 Kabupaten Feature Layer.
    This layer has: PROVINSI, KABKOTA, NAMA_KAB, Total_basa (wet season floods),
    Total_keri (dry season floods), plus polygon geometry in SRID 4326.

    Note: This layer does NOT support pagination (supportsPagination=false),
    but maxRecordCount=2000 which is more than enough for Jakarta (~6 records).
    """
    print("\n[Step 1] Fetching DIBI Hidromet Kabupaten flood data...")

    # Try attribute filter first
    params = {
        "where": "PROVINSI='DKI JAKARTA'",
        "outFields": "*",
        "outSR": "4326",
        "f": "geojson"
    }

    resp = fetch_with_retry(DIBI_KABUPATEN_URL, params)

    # If attribute filter fails, try spatial filter (bbox)
    if resp is None:
        print("  Attribute filter failed. Trying spatial bbox filter...")
        params = {
            "where": "1=1",
            "geometry": JAKARTA_BBOX,
            "geometryType": "esriGeometryEnvelope",
            "spatialRel": "esriSpatialRelIntersects",
            "inSR": "4326",
            "outSR": "4326",
            "outFields": "*",
            "f": "geojson"
        }
        resp = fetch_with_retry(DIBI_KABUPATEN_URL, params)

    if resp is None:
        print("  [FAILED] Could not reach DIBI endpoint.")
        return None

    try:
        data = resp.json()
        features = data.get('features', [])

        if not features:
            print("  [WARN] DIBI returned 0 features for Jakarta.")
            return None

        # Transform DIBI features into our rawan_banjir format
        transformed = []
        for feat in features:
            props = feat.get('properties', {})
            geom = feat.get('geometry')
            if not geom:
                continue

            # Determine risk level based on wet-season flood count
            total_basa = props.get('Total_basa', 0) or 0
            if total_basa >= 50:
                risiko = 'Tinggi'
            elif total_basa >= 20:
                risiko = 'Sedang'
            else:
                risiko = 'Rendah'

            kabkota = props.get('KABKOTA', '') or props.get('NAMA_KAB', '') or 'Unknown'

            transformed.append({
                'geometry': geom,
                'properties': {
                    'tingkat_risiko': risiko,
                    'luas_ha': props.get('Shape_Area', 0) or 0,
                    'kota_admin': kabkota,
                    'total_basa': total_basa,
                    'total_keri': props.get('Total_keri', 0) or 0,
                }
            })

        print(f"  [OK] Got {len(transformed)} flood features from DIBI.")
        return transformed

    except Exception as e:
        print(f"  [ERROR] Failed to parse DIBI response: {e}")
        return None


def fetch_admin_as_flood_zones():
    """
    Fetch DKI Jakarta kecamatan boundaries from batas_administrasi layer,
    and use them as flood zone polygons with synthetic risk levels.

    This layer supports pagination (maxRecordCount=1000).
    Fields: WADMKC (kecamatan), WADMKK (kab/kota), WADMPR (provinsi)
    """
    print("\n[Step 2] Fetching admin kecamatan boundaries for Jakarta...")

    all_features = []
    offset = 0
    limit = 100

    # First get count
    count_params = {
        "where": "WADMPR='DKI JAKARTA'",
        "returnCountOnly": "true",
        "f": "json"
    }
    resp = fetch_with_retry(ADMIN_KECAMATAN_URL, count_params)

    total_count = 0
    if resp:
        try:
            total_count = resp.json().get('count', 0)
            print(f"  Total kecamatan features for DKI Jakarta: {total_count}")
        except:
            pass

    if total_count == 0:
        # Try spatial filter instead
        print("  Attribute filter returned 0. Trying spatial filter...")
        count_params = {
            "where": "1=1",
            "geometry": JAKARTA_BBOX,
            "geometryType": "esriGeometryEnvelope",
            "spatialRel": "esriSpatialRelIntersects",
            "inSR": "4326",
            "returnCountOnly": "true",
            "f": "json"
        }
        resp = fetch_with_retry(ADMIN_KECAMATAN_URL, count_params)
        if resp:
            try:
                total_count = resp.json().get('count', 0)
                print(f"  Total features via spatial filter: {total_count}")
            except:
                pass

    if total_count == 0:
        print("  [FAILED] No kecamatan features found.")
        return None

    # Pagination loop
    use_spatial = total_count > 0
    while offset < total_count:
        page_params = {
            "where": "WADMPR='DKI JAKARTA'" if not use_spatial else "1=1",
            "outFields": "*",
            "outSR": "4326",
            "resultOffset": offset,
            "resultRecordCount": limit,
            "f": "geojson"
        }
        if use_spatial:
            page_params.update({
                "geometry": JAKARTA_BBOX,
                "geometryType": "esriGeometryEnvelope",
                "spatialRel": "esriSpatialRelIntersects",
                "inSR": "4326",
            })

        print(f"  Fetching offset {offset} to {offset + limit}...")
        resp = fetch_with_retry(ADMIN_KECAMATAN_URL, page_params)

        if resp:
            try:
                data = resp.json()
                features = data.get('features', [])
                all_features.extend(features)
            except:
                pass

        offset += limit

    if not all_features:
        return None

    # Transform: assign synthetic risk levels based on location
    # Northern Jakarta (closer to coast) = higher risk
    transformed = []
    for feat in all_features:
        props = feat.get('properties', {})
        geom = feat.get('geometry')
        if not geom:
            continue

        kecamatan = props.get('WADMKC', 'Unknown')
        kabkota = props.get('WADMKK', 'Unknown')

        # Determine risk based on latitude (northern = higher flood risk)
        coords = geom.get('coordinates', [])
        avg_lat = calculate_avg_lat(coords)

        if avg_lat > -6.15:
            risiko = 'Tinggi'
        elif avg_lat > -6.25:
            risiko = 'Sedang'
        else:
            risiko = 'Rendah'

        transformed.append({
            'geometry': geom,
            'properties': {
                'tingkat_risiko': risiko,
                'luas_ha': (props.get('Shape_Area', 0) or 0) * 1e4,
                'kota_admin': kabkota,
                'kecamatan': kecamatan,
            }
        })

    print(f"  [OK] Got {len(transformed)} kecamatan features as flood zones.")
    return transformed


def calculate_avg_lat(coords):
    """
    Calculate average latitude from GeoJSON coordinates.
    Handles nested coordinate arrays (Polygon, MultiPolygon).
    """
    lats = []

    def extract_lats(c):
        if isinstance(c, list):
            if len(c) >= 2 and isinstance(c[0], (int, float)):
                lats.append(c[1])
            else:
                for item in c:
                    extract_lats(item)

    extract_lats(coords)
    return sum(lats) / len(lats) if lats else -6.2


def insert_flood_features(features, source_name):
    """
    Bulk insert flood features into PostgreSQL rawan_banjir table.
    Uses ST_GeomFromGeoJSON with ON CONFLICT DO NOTHING.
    """
    conn = get_connection()
    records_inserted = 0
    total = len(features)

    try:
        with conn.cursor() as cur:
            insert_query = """
                INSERT INTO rawan_banjir (wilayah_id, tingkat_risiko, luas_ha, sumber, tahun, geom)
                VALUES (%s, %s, %s, %s, %s, ST_GeomFromGeoJSON(%s))
                ON CONFLICT DO NOTHING
            """

            for i, feat in enumerate(features):
                props = feat.get('properties', {})
                geom = feat.get('geometry')
                if not geom:
                    continue

                geom_json = json.dumps(geom)
                risiko = props.get('tingkat_risiko', 'Sedang')
                luas = props.get('luas_ha', 0)

                try:
                    luas = float(luas)
                except (TypeError, ValueError):
                    luas = 0

                # Use wilayah_id = 1 as default (will be matched later)
                cur.execute(insert_query, (1, risiko, luas, source_name, 2024, geom_json))

                if cur.rowcount > 0:
                    records_inserted += 1

                if (i + 1) % 50 == 0:
                    print(f"  Inserted {i + 1}/{total} features...")

            conn.commit()
            print(f"\n  Total features fetched:   {total}")
            print(f"  Total features inserted:  {records_inserted}")
            log_etl(source_name, records_inserted, 'SUCCESS')
            return records_inserted

    except Exception as e:
        conn.rollback()
        print(f"  [ERROR] Database insert failed: {e}")
        log_etl(source_name, 0, 'FAILED')
        return 0
    finally:
        conn.close()


def insert_local_fallback_data():
    """
    Insert comprehensive local fallback flood data for DKI Jakarta.
    Covers all 5 kota administrasi with realistic flood zone polygons.
    """
    conn = get_connection()
    records_inserted = 0

    # Realistic flood zone polygons for each kota administrasi in DKI Jakarta
    fallback_zones = [
        # Jakarta Utara - HIGH risk (coastal, flood-prone)
        {
            'risiko': 'Tinggi',
            'luas_ha': 850.0,
            'geom': '{"type":"MultiPolygon","coordinates":[[[[106.70,-6.08],[106.80,-6.08],[106.80,-6.13],[106.70,-6.13],[106.70,-6.08]]]]}',
        },
        {
            'risiko': 'Tinggi',
            'luas_ha': 620.0,
            'geom': '{"type":"MultiPolygon","coordinates":[[[[106.80,-6.08],[106.90,-6.08],[106.90,-6.13],[106.80,-6.13],[106.80,-6.08]]]]}',
        },
        {
            'risiko': 'Sedang',
            'luas_ha': 450.0,
            'geom': '{"type":"MultiPolygon","coordinates":[[[[106.90,-6.08],[106.97,-6.08],[106.97,-6.13],[106.90,-6.13],[106.90,-6.08]]]]}',
        },
        # Jakarta Barat - MEDIUM/HIGH risk
        {
            'risiko': 'Sedang',
            'luas_ha': 520.0,
            'geom': '{"type":"MultiPolygon","coordinates":[[[[106.68,-6.13],[106.75,-6.13],[106.75,-6.20],[106.68,-6.20],[106.68,-6.13]]]]}',
        },
        {
            'risiko': 'Tinggi',
            'luas_ha': 380.0,
            'geom': '{"type":"MultiPolygon","coordinates":[[[[106.75,-6.13],[106.80,-6.13],[106.80,-6.18],[106.75,-6.18],[106.75,-6.13]]]]}',
        },
        # Jakarta Pusat - MEDIUM risk
        {
            'risiko': 'Sedang',
            'luas_ha': 310.0,
            'geom': '{"type":"MultiPolygon","coordinates":[[[[106.80,-6.14],[106.86,-6.14],[106.86,-6.20],[106.80,-6.20],[106.80,-6.14]]]]}',
        },
        {
            'risiko': 'Rendah',
            'luas_ha': 200.0,
            'geom': '{"type":"MultiPolygon","coordinates":[[[[106.82,-6.16],[106.86,-6.16],[106.86,-6.19],[106.82,-6.19],[106.82,-6.16]]]]}',
        },
        # Jakarta Timur - LOW/MEDIUM risk
        {
            'risiko': 'Sedang',
            'luas_ha': 600.0,
            'geom': '{"type":"MultiPolygon","coordinates":[[[[106.86,-6.16],[106.95,-6.16],[106.95,-6.24],[106.86,-6.24],[106.86,-6.16]]]]}',
        },
        {
            'risiko': 'Rendah',
            'luas_ha': 420.0,
            'geom': '{"type":"MultiPolygon","coordinates":[[[[106.90,-6.20],[106.97,-6.20],[106.97,-6.28],[106.90,-6.28],[106.90,-6.20]]]]}',
        },
        # Jakarta Selatan - LOW risk
        {
            'risiko': 'Rendah',
            'luas_ha': 350.0,
            'geom': '{"type":"MultiPolygon","coordinates":[[[[106.76,-6.22],[106.84,-6.22],[106.84,-6.30],[106.76,-6.30],[106.76,-6.22]]]]}',
        },
        {
            'risiko': 'Sedang',
            'luas_ha': 280.0,
            'geom': '{"type":"MultiPolygon","coordinates":[[[[106.80,-6.26],[106.86,-6.26],[106.86,-6.32],[106.80,-6.32],[106.80,-6.26]]]]}',
        },
        # Kepulauan Seribu - HIGH risk (island, tsunami + flood)
        {
            'risiko': 'Tinggi',
            'luas_ha': 150.0,
            'geom': '{"type":"MultiPolygon","coordinates":[[[[106.55,-5.60],[106.65,-5.60],[106.65,-5.70],[106.55,-5.70],[106.55,-5.60]]]]}',
        },
    ]

    try:
        with conn.cursor() as cur:
            insert_query = """
                INSERT INTO rawan_banjir (wilayah_id, tingkat_risiko, luas_ha, sumber, tahun, geom)
                VALUES (%s, %s, %s, %s, %s, ST_GeomFromGeoJSON(%s))
                ON CONFLICT DO NOTHING
            """

            for zone in fallback_zones:
                cur.execute(insert_query, (
                    1,
                    zone['risiko'],
                    zone['luas_ha'],
                    'LOCAL-FALLBACK',
                    2024,
                    zone['geom']
                ))
                if cur.rowcount > 0:
                    records_inserted += 1

            conn.commit()
            log_etl('LOCAL-FALLBACK', records_inserted, 'SUCCESS')
            return records_inserted

    except Exception as e:
        conn.rollback()
        print(f"  [ERROR] Fallback insert failed: {e}")
        log_etl('LOCAL-FALLBACK', 0, 'FAILED')
        return 0
    finally:
        conn.close()


def log_etl(sumber, jumlah, status):
    """
    Log ETL execution result to log_etl table.
    """
    try:
        conn = get_connection()
        with conn.cursor() as cur:
            cur.execute(
                "INSERT INTO log_etl (sumber_api, jumlah_record, status) VALUES (%s, %s, %s)",
                (sumber, jumlah, status)
            )
            conn.commit()
        conn.close()
    except Exception as e:
        print(f"  [WARN] Failed to log ETL result: {e}")


if __name__ == '__main__':
    run_bnpb_etl()
