from psycopg2.extras import RealDictCursor
from models.db import get_connection

class TsunamiModel:
    @staticmethod
    def get_all(zona=None):
        """
        Get tsunami hazard zones as GeoJSON.
        Optional filters: zona_tsunami.
        """
        conn = get_connection()
        try:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                query = """
                    SELECT 
                        jsonb_build_object(
                            'type',       'Feature',
                            'id',         t.id,
                            'geometry',   ST_AsGeoJSON(t.geom)::jsonb,
                            'properties', jsonb_build_object(
                                'wilayah_id', t.wilayah_id,
                                'nama_kelurahan', w.nama_kelurahan,
                                'kota_admin', w.kota_admin,
                                'zona_tsunami', t.zona_tsunami,
                                'elevasi_max_m', t.elevasi_max_m,
                                'jarak_pantai_km', t.jarak_pantai_km
                            )
                        ) AS feature
                    FROM rawan_tsunami t
                    JOIN wilayah w ON t.wilayah_id = w.id
                    WHERE 1=1
                """
                params = []
                
                if zona:
                    query += " AND t.zona_tsunami = %s"
                    params.append(zona)
                
                cur.execute(query, tuple(params))
                rows = cur.fetchall()
                
                features = [row['feature'] for row in rows]
                
                return {
                    "type": "FeatureCollection",
                    "features": features
                }
        finally:
            conn.close()
