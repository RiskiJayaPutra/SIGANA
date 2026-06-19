from flask import Blueprint, request, jsonify
from psycopg2.extras import RealDictCursor
from models.db import get_connection

stats_bp = Blueprint('stats_bp', __name__)

@stats_bp.route('/api/stats', methods=['GET'])
def get_stats():
    stat_type = request.args.get('type', 'banjir')
    conn = get_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            if stat_type == 'banjir':
                cur.execute("SELECT SUM(luas_ha) as luas_total FROM rawan_banjir")
                luas_total = cur.fetchone()['luas_total']
                
                cur.execute("SELECT tingkat_risiko, COUNT(*) as jumlah FROM rawan_banjir GROUP BY tingkat_risiko")
                per_risiko = cur.fetchall()
                
                cur.execute("""
                    SELECT w.kota_admin, COUNT(r.id) as jumlah 
                    FROM rawan_banjir r 
                    JOIN wilayah w ON r.wilayah_id = w.id 
                    GROUP BY w.kota_admin
                """)
                per_kota = cur.fetchall()
                
                # Fetch Titik Pengungsian Stats
                cur.execute("SELECT COUNT(*) as total, SUM(kapasitas) as kapasitas FROM titik_pengungsian WHERE aktif = TRUE")
                pengungsian_stats = cur.fetchone()
                
                # Fetch Kejadian Banjir Stats
                cur.execute("SELECT COUNT(*) as total FROM kejadian_banjir")
                kejadian_stats = cur.fetchone()
                
                cur.execute("""
                    SELECT EXTRACT(YEAR FROM tanggal) as tahun, COUNT(*) as jumlah 
                    FROM kejadian_banjir 
                    GROUP BY tahun 
                    ORDER BY tahun ASC
                """)
                kejadian_per_tahun = cur.fetchall()
                
                # Fetch Top 5 Kecamatan
                cur.execute("""
                    SELECT w.nama_kecamatan, w.kota_admin, r.tingkat_risiko, r.luas_ha
                    FROM rawan_banjir r
                    JOIN wilayah w ON r.wilayah_id = w.id
                    ORDER BY r.luas_ha DESC
                    LIMIT 5
                """)
                top_kecamatan = cur.fetchall()
                for k in top_kecamatan:
                    if k['luas_ha'] is not None:
                        k['luas_ha'] = float(k['luas_ha'])
                
                return jsonify({
                    "luas_total": float(luas_total) if luas_total else 0,
                    "per_risiko": per_risiko,
                    "per_kota": per_kota,
                    "pengungsian_total": pengungsian_stats['total'] if pengungsian_stats else 0,
                    "pengungsian_kapasitas": pengungsian_stats['kapasitas'] if pengungsian_stats and pengungsian_stats['kapasitas'] else 0,
                    "kejadian_total": kejadian_stats['total'] if kejadian_stats else 0,
                    "kejadian_per_tahun": kejadian_per_tahun,
                    "top_kecamatan": top_kecamatan
                })
            else:
                return jsonify({"error": "Unsupported stat type"}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        conn.close()
