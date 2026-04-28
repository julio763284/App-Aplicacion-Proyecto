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
        return conexion if conexion.is_connected() else None
    except Exception as e:
        print(f"Error de conexión: {e}")
        return None

def validar_usuario(identificador, password_plana):
    db = obtener_conexion()
    if not db: return None
    try:
        cursor = db.cursor(dictionary=True)
        sql = "SELECT id_usuario, usuario, email, contrasena FROM usuario WHERE usuario = %s OR email = %s"
        cursor.execute(sql, (identificador, identificador))
        resultado = cursor.fetchone()
        if resultado and bcrypt.checkpw(password_plana.encode('utf-8'), resultado['contrasena'].encode('utf-8')):
            resultado.pop('contrasena') 
            return resultado
        return None 
    finally:
        cursor.close()
        db.close()

def registrar_usuario(usuario, email, password_plana):
    db = obtener_conexion()
    if not db: return {"status": "error", "message": "Error de DB"}
    try:
        cursor = db.cursor()
        hash_pw = bcrypt.hashpw(password_plana.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
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
    if not db: return {"status": "error", "message": "Error de conexión"}
    try:
        cursor = db.cursor()
        sql = "INSERT INTO cliente (nombre, direccion_residencia, gmail_corporativo, celular, imagen) VALUES (%s, %s, %s, %s, %s)"
        cursor.execute(sql, (nombre, direccion_residencia, gmail_corporativo, celular, imagen))
        db.commit()
        return {"status": "success", "message": "Cliente registrado"}
    except Exception as e:
        return {"status": "error", "message": str(e)}
    finally:
        cursor.close()
        db.close()

def obtener_productos():
    db = obtener_conexion()
    if not db: return None
    try:
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT * FROM producto")
        return cursor.fetchall()
    finally:
        cursor.close()
        db.close()

def obtener_notificaciones_db():
    db = obtener_conexion()
    if not db: return []
    try:
        cursor = db.cursor(dictionary=True)
        # Coincide exactamente con tu tabla: id, mensaje, fecha, leido
        cursor.execute("SELECT mensaje, DATE_FORMAT(fecha, '%H:%i') as fecha, leido FROM notificaciones ORDER BY id DESC")
        return cursor.fetchall()
    finally:
        cursor.close()
        db.close()

def validar_y_notificar_stock(id_producto):
    db = obtener_conexion()
    if not db: return
    try:
        cursor = db.cursor(dictionary=True)
        # Asegúrate que la tabla producto use 'id' o cambia esto a 'id_producto'
        cursor.execute("SELECT nombre, stock, umbral_minimo FROM producto WHERE id = %s", (id_producto,))
        p = cursor.fetchone()
        if p and p['stock'] <= p['umbral_minimo']:
            msg = f"Stock bajo: {p['nombre']} ({p['stock']} u.)"
            cursor.execute("INSERT INTO notificaciones (mensaje) VALUES (%s)", (msg,))
            db.commit()
    finally:
        cursor.close()
        db.close()