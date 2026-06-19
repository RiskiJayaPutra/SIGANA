import requests
import json
from models.db import get_connection
from datetime import datetime

def run_bmkg_etl():
    """
    Fetch earthquake data from BMKG and log it.
    """
    url = "https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json"
    
    try:
        response = requests.get(url, timeout=30)
        if response.status_code != 200:
            log_etl('BMKG', 0, 'FAILED')
            raise Exception(f"Failed to fetch BMKG data: {response.status_code}")
            
        data = response.json()
        gempa = data.get('Infogempa', {}).get('gempa', {})
        
        if not gempa:
            log_etl('BMKG', 0, 'FAILED')
            return 0
            
        coordinates = gempa.get('Coordinates', '').split(',')
        if len(coordinates) == 2:
            lat, lng = coordinates[0], coordinates[1]
            records_inserted = 1 # simulated
            log_etl('BMKG', records_inserted, 'SUCCESS')
            return records_inserted
        else:
            log_etl('BMKG', 0, 'FAILED')
            return 0
            
    except Exception as e:
        print(f"ETL Error: {e}")
        return 0

def log_etl(sumber, jumlah, status):
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(
                "INSERT INTO log_etl (sumber_api, jumlah_record, status) VALUES (%s, %s, %s)",
                (sumber, jumlah, status)
            )
            conn.commit()
    finally:
        conn.close()
