from flask import Blueprint, request, jsonify
from etl.fetch_bnpb import run_bnpb_etl
from etl.fetch_bmkg import run_bmkg_etl

etl_bp = Blueprint('etl_bp', __name__)

@etl_bp.route('/api/etl/run', methods=['POST'])
def run_etl():
    data = request.get_json()
    if not data or 'source' not in data:
        return jsonify({"error": "Missing source parameter in JSON body"}), 400
        
    source = data['source']
    try:
        if source == 'bnpb':
            records_inserted = run_bnpb_etl()
            return jsonify({
                "status": "success",
                "source": source,
                "records_inserted": records_inserted
            })
        elif source == 'bmkg':
            records_inserted = run_bmkg_etl()
            return jsonify({
                "status": "success",
                "source": source,
                "records_inserted": records_inserted
            })
        else:
            return jsonify({"error": f"Unknown source: {source}"}), 400
    except Exception as e:
        return jsonify({
            "status": "failed",
            "error": str(e)
        }), 500
