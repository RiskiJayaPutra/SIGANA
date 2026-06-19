from psycopg2.extras import RealDictCursor
from models.db import get_connection

class PengungsianModel:
    @staticmethod
    def get_all(kecamatan=None):
        """
        Get all evacuation points as GeoJSON.
        """
        conn = get_connection()
        try:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                query = """
                    SELECT 
                        jsonb_build_object(
                            'type',       'Feature',
                            'id',         id,
                            'geometry',   ST_AsGeoJSON(geom)::jsonb,
                            'properties', jsonb_build_object(
                                'nama', nama,
                                'kecamatan', kecamatan,
                                'kapasitas', kapasitas,
                                'fasilitas', fasilitas,
                                'aktif', aktif
                            )
                        ) AS feature
                    FROM titik_pengungsian
                    WHERE 1=1
                """
                params = []
                
                if kecamatan:
                    query += " AND kecamatan = %s"
                    params.append(kecamatan)
                
                cur.execute(query, tuple(params))
                rows = cur.fetchall()
                
                features = [row['feature'] for row in rows]
                
                return {
                    "type": "FeatureCollection",
                    "features": features
                }
        finally:
            conn.close()

    @staticmethod
    def get_nearest(lat, lng, limit=5):
        """
        Get the nearest evacuation points based on distance (using ST_Distance).
        """
        conn = get_connection()
        try:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                # Using ST_DistanceSphere for approximate distance in meters
                query = """
                    SELECT 
                        nama,
                        kecamatan,
                        kapasitas,
                        fasilitas,
                        aktif,
                        ST_DistanceSphere(
                            geom, 
                            ST_SetSRID(ST_MakePoint(%s, %s), 4326)
                        ) AS jarak_meter
                    FROM titik_pengungsian
                    WHERE aktif = TRUE
                    ORDER BY jarak_meter ASC
                    LIMIT %s
                """
                # Note: ST_MakePoint takes (longitude, latitude)
                cur.execute(query, (lng, lat, limit))
                rows = cur.fetchall()
                
                return rows
        finally:
            conn.close()
