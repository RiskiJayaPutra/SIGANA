from psycopg2.extras import RealDictCursor
from models.db import get_connection

class BanjirModel:
    @staticmethod
    def get_all(kota=None, risiko=None):
        """
        Get flood hazard zones as GeoJSON.
        Optional filters: kota_admin, tingkat_risiko.
        """
        conn = get_connection()
        try:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                # Query building with ST_AsGeoJSON for geometry
                query = """
                    SELECT 
                        jsonb_build_object(
                            'type',       'Feature',
                            'id',         r.id,
                            'geometry',   ST_AsGeoJSON(r.geom)::jsonb,
                            'properties', jsonb_build_object(
                                'wilayah_id', r.wilayah_id,
                                'nama_kelurahan', w.nama_kelurahan,
                                'nama_kecamatan', w.nama_kecamatan,
                                'kota_admin', w.kota_admin,
                                'tingkat_risiko', r.tingkat_risiko,
                                'luas_ha', r.luas_ha,
                                'sumber', r.sumber,
                                'tahun', r.tahun
                            )
                        ) AS feature
                    FROM rawan_banjir r
                    JOIN wilayah w ON r.wilayah_id = w.id
                    WHERE 1=1
                """
                params = []
                
                if kota:
                    query += " AND w.kota_admin = %s"
                    params.append(kota)
                if risiko:
                    query += " AND r.tingkat_risiko = %s"
                    params.append(risiko)
                
                cur.execute(query, tuple(params))
                rows = cur.fetchall()
                
                # Format as FeatureCollection
                features = [row['feature'] for row in rows]
                
                return {
                    "type": "FeatureCollection",
                    "features": features
                }
        finally:
            conn.close()
