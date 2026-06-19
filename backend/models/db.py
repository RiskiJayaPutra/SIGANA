import psycopg2
from config import Config

def get_connection():
    """
    Establish a connection to the PostgreSQL/PostGIS database.
    Returns a connection object.
    """
    try:
        conn = psycopg2.connect(
            host=Config.DB_HOST,
            port=Config.DB_PORT,
            dbname=Config.DB_NAME,
            user=Config.DB_USER,
            password=Config.DB_PASSWORD
        )
        return conn
    except psycopg2.Error as e:
        print(f"Error connecting to PostgreSQL DB: {e}")
        raise
