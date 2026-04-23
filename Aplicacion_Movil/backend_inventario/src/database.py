import mysql.connector 
from config.db_config import DB_SETTINGS

def obtener_conexion():
    try:
        conexion = mysql.connector.connect(
            host=DB_SETTINGS['host'],
            user=DB_SETTINGS['user'],
            password=DB_SETTINGS['password'],
            database=DB_SETTINGS['database']
        )
        if conexion.is_connected():
            return conexion
    except Exception as e:
        print(f"Error de conexión: {e}")
        return None