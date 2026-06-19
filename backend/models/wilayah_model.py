from psycopg2.extras import RealDictCursor
from models.db import get_connection

class WilayahModel:
    @staticmethod
    def get_all(kota=None):
        """
        Get administrative boundaries as GeoJSON.
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
                                'nama_kelurahan', nama_kelurahan,
                                'nama_kecamatan', nama_kecamatan,
                                'kota_admin', kota_admin,
                                'populasi', populasi
                            )
                        ) AS feature
                    FROM wilayah
                    WHERE 1=1
                """
                params = []
                
                if kota:
                    query += " AND kota_admin = %s"
                    params.append(kota)
                
                cur.execute(query, tuple(params))
                rows = cur.fetchall()
                
                features = [row['feature'] for row in rows]
                
                return {
                    "type": "FeatureCollection",
                    "features": features
                }
        finally:
            conn.close()
