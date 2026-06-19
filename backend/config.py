import os

class Config:
    # Database Configuration
    DB_HOST = os.environ.get('DB_HOST', 'localhost')
    DB_PORT = os.environ.get('DB_PORT', '5432')
    DB_NAME = os.environ.get('DB_NAME', 'sigana_db')
    DB_USER = os.environ.get('DB_USER', 'postgres')
    DB_PASSWORD = os.environ.get('DB_PASSWORD', '251205')
    
    # ETL Configuration
    BNPB_API_URL = "https://gis.bnpb.go.id/arcgis/rest/services/"
    BMKG_API_URL = "https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json"
