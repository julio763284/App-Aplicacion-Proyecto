import bcrypt
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
        
def validar_usuario(identificador, password_plana):
    print(f"\n--- INTENTO DE ACCESO ---")
    db = obtener_conexion()
    if not db: 
        return None

    try:
        cursor = db.cursor(dictionary=True)
        sql = "SELECT id_usuario, usuario, email, contrasena FROM usuario WHERE usuario = %s OR email = %s"
        cursor.execute(sql, (identificador, identificador))
        resultado = cursor.fetchone()
        
        cursor.close()
        db.close()

        if resultado:
            hash_almacenado = resultado['contrasena'].encode('utf-8')
            
            if bcrypt.checkpw(password_plana.encode('utf-8'), hash_almacenado):
                resultado.pop('contrasena') 
                return resultado

        return None 
            
    except Exception as e:
        print(f"❌ Error en la validación: {e}")
        return None

def registrar_usuario(usuario, email, password_plana):
    db = obtener_conexion()
    if not db: return {"status": "error", "message": "Error de DB"}
    try:
        cursor = db.cursor()
        sal = bcrypt.gensalt()
        hash_pw = bcrypt.hashpw(password_plana.encode('utf-8'), sal).decode('utf-8')
        
        sql = "INSERT INTO usuario (usuario, email, contrasena) VALUES (%s, %s, %s)"
        cursor.execute(sql, (usuario, email, hash_pw))
        db.commit()
        return {"status": "success", "message": "¡Usuario creado!"}
    except Exception as e:
        return {"status": "error", "message": str(e)}
    finally:
        db.close()
        
        
def registrar_cliente(nombre, direccion_residencia, gmail_corporativo, celular, imagen):
    db = obtener_conexion()
    if not db:
        return {"status": "error", "message": "Error de conexión a la base de datos"}
        
    try:
        cursor = db.cursor()
        sql = """INSERT INTO cliente 
                 (nombre, direccion_residencia, gmail_corporativo, celular, imagen) 
                 VALUES (%s, %s, %s, %s, %s)"""
        valores = (nombre, direccion_residencia, gmail_corporativo, celular, imagen)
        
        cursor.execute(sql, valores)
        db.commit()
        return {"status": "success", "message": "Cliente registrado correctamente"}
    except Exception as e:
        db.rollback()
        if "Duplicate entry" in str(e):
            return {"status": "error", "message": "Este Gmail corporativo ya está registrado"}
        return {"status": "error", "message": f"Error al guardar: {str(e)}"}
    finally:
        cursor.close()
        db.close()

def obtener_productos():
    db = obtener_conexion()
    if not db: return None
    try:
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT * FROM producto")
        productos = cursor.fetchall()
        return productos
    except Exception as e:
        print(f"Error al obtener productos: {e}")
        return None
    finally:
        cursor.close()
        db.close()    
        
def registrar_notificacion(mensaje):
    db = obtener_conexion()
    if not db: return
    try:
        cursor = db.cursor()
        sql = "INSERT INTO notificaciones (mensaje) VALUES (%s)"
        cursor.execute(sql, (mensaje,))
        db.commit()
    finally:
        cursor.close()
        db.close()

def obtener_notificaciones_db():
    db = obtener_conexion()
    if not db: return []
    try:
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT mensaje FROM notificaciones ORDER BY fecha DESC")
        return cursor.fetchall()
    finally:
        cursor.close()
        db.close()