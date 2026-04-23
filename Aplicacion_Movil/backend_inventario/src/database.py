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
        
def validar_usuario(identificador, password):
    print(f"\n--- INTENTO DE ACCESO ---")
    print(f"Identificador (User/Email): '{identificador}'")
    
    db = obtener_conexion()
    if db:
        try:
            cursor = db.cursor(dictionary=True)
            sql = """
                SELECT id_usuario, usuario, email 
                FROM usuario 
                WHERE (usuario = %s OR email = %s) 
                AND contrasena = %s
            """
            cursor.execute(sql, (identificador, identificador, password))
            resultado = cursor.fetchone()
            
            cursor.close()
            db.close()
            return resultado
            
        except Exception as e:
            print(f"❌ Error en la consulta: {e}")
            return None
    return None