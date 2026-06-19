from flask import Blueprint, request, jsonify
from models.banjir_model import BanjirModel
from models.tsunami_model import TsunamiModel
from models.pengungsian_model import PengungsianModel
from models.wilayah_model import WilayahModel

map_bp = Blueprint('map_bp', __name__)

@map_bp.route('/api/banjir', methods=['GET'])
def get_banjir():
    kota = request.args.get('kota')
    risiko = request.args.get('risiko')
    try:
        data = BanjirModel.get_all(kota=kota, risiko=risiko)
        return jsonify(data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@map_bp.route('/api/tsunami', methods=['GET'])
def get_tsunami():
    zona = request.args.get('zona')
    try:
        data = TsunamiModel.get_all(zona=zona)
        return jsonify(data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@map_bp.route('/api/pengungsian', methods=['GET'])
def get_pengungsian():
    kecamatan = request.args.get('kecamatan')
    try:
        data = PengungsianModel.get_all(kecamatan=kecamatan)
        return jsonify(data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@map_bp.route('/api/pengungsian/nearest', methods=['GET'])
def get_nearest_pengungsian():
    lat = request.args.get('lat', type=float)
    lng = request.args.get('lng', type=float)
    
    if lat is None or lng is None:
        return jsonify({"error": "Parameters lat and lng are required"}), 400
        
    try:
        data = PengungsianModel.get_nearest(lat, lng)
        return jsonify(data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@map_bp.route('/api/wilayah', methods=['GET'])
def get_wilayah():
    kota = request.args.get('kota')
    try:
        data = WilayahModel.get_all(kota=kota)
        return jsonify(data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
