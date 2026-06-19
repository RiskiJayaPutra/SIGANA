from psycopg2.extras import RealDictCursor
from models.db import get_connection

class KejadianModel:
    @staticmethod
    def get_all():
        """
        Get historical flood events as GeoJSON.
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
                                'tanggal', TO_CHAR(tanggal, 'YYYY-MM-DD'),
                                'keterangan', keterangan,
                                'korban', korban,
                                'kota_admin', kota_admin
                            )
                        ) AS feature
                    FROM kejadian_banjir
                """
                cur.execute(query)
                rows = cur.fetchall()
                
                features = [row['feature'] for row in rows]
                
                return {
                    "type": "FeatureCollection",
                    "features": features
                }
        finally:
            conn.close()
