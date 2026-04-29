import bcrypt
import mysql.connector 
from config.db_config import DB_SETTINGS

# el archivo database.py se conecta con la base de datos #

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
        cursor = db.cursor(dictionary=True, buffered=True) 
        
        sql = "SELECT id_usuario, usuario, email, contrasena FROM usuario WHERE usuario = %s OR email = %s"
        cursor.execute(sql, (identificador, identificador))
        
        resultado = cursor.fetchone()
        
        if resultado:
            hash_almacenado = resultado['contrasena'].encode('utf-8')
            if bcrypt.checkpw(password_plana.encode('utf-8'), hash_almacenado):
                resultado.pop('contrasena') 
                return resultado
        
        return None 
    except Exception as e:
        print(f"Error en validar_usuario: {e}")
        return None
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'db' in locals() and db:
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

def registrar_proveedor(nombre, direccion, gmail, telefono):
    print(nombre, direccion, gmail, telefono)
    db = obtener_conexion()
    if not db: return {"status": "error", "message": "Error de conexion"}
    try:
        cursor = db.cursor()
        sql = "INSERT INTO proveedor (nombre, direccion, gmail, telefono) VALUES (%s, %s, %s, %s)"
        cursor.execute(sql, (nombre, direccion, gmail, telefono))
        db.commit()
        return {"status": "success", "message": "Proveedor registrado"}
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
        cursor.execute("SELECT nombre, stock, umbral_minimo FROM producto WHERE id = %s", (id_producto,))
        p = cursor.fetchone()
        if p and p['stock'] <= p['umbral_minimo']:
            msg = f"Stock bajo: {p['nombre']} ({p['stock']} u.)"
            cursor.execute("INSERT INTO notificaciones (mensaje) VALUES (%s)", (msg,))
            db.commit()
    finally:
        cursor.close()
        db.close()
        
def obtener_clientes_ordenados():
    try:
        conn = obtener_conexion() # Tu función de conexión
        cursor = conn.cursor(dictionary=True)
        # Ordenamos por fecha_registro descendente (los más nuevos primero)
        cursor.execute("SELECT * FROM cliente ORDER BY fecha_registro DESC")
        clientes = cursor.fetchall()
        cursor.close()
        conn.close()
        return clientes
    except Exception as e:
        print(f"Error: {e}")
        return None

def registrar_producto_db(nombre, descripcion, precio, cantidad, imagen):
    db = obtener_conexion()
    if not db: return {"status": "error", "message": "Error de conexión"}
    try:
        cursor = db.cursor()
        # El estado se manejará por defecto como 'Agotado' según tu SQL si no se envía
        sql = """INSERT INTO producto (nombre, descripcion, precio, cantidad, imagen, estado) 
                 VALUES (%s, %s, %s, %s, %s, 'Disponible')"""
        cursor.execute(sql, (nombre, descripcion, precio, cantidad, imagen))
        db.commit()
        return {"status": "success", "message": "Producto registrado en DB"}
    except Exception as e:
        return {"status": "error", "message": str(e)}
    finally:
        cursor.close()
        db.close()        