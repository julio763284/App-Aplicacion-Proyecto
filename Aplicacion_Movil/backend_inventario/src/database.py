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
    db = obtener_conexion()
    if not db:
        return {"status": "error", "message": "Error de conexion"}

    try:
        cursor = db.cursor(dictionary=True)
        #en caso de error esto lo agregue
        # 🔍 VALIDACIÓN AQUÍ
        cursor.execute("SELECT id_proveedor FROM proveedor WHERE gmail = %s", (gmail,))
        existe = cursor.fetchone()
        #en caso de error esto lo agregue#

        if existe:
            return {
                "status": "error",
                "message": "El correo ya está registrado"
            }

        # 🟢 INSERT
        sql = """
        INSERT INTO proveedor (nombre, direccion, gmail, telefono)
        VALUES (%s, %s, %s, %s)
        """
        cursor.execute(sql, (nombre, direccion, gmail, telefono))
        db.commit()

        return {"status": "success", "message": "Proveedor registrado"}

    except Exception as e:
        print("ERROR:", e)
        return {"status": "error", "message": "Error interno"}

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
    if not db: 
        return {"status": "error", "message": "Error de conexión con la base de datos"}
    try:
        cursor = db.cursor()
        # Usamos una consulta preparada para manejar el string largo de la imagen
        sql = """INSERT INTO producto (nombre, descripcion, precio, cantidad, imagen, estado) 
                 VALUES (%s, %s, %s, %s, %s, 'Disponible')"""
        
        valores = (nombre, descripcion, precio, cantidad, imagen)
        
        cursor.execute(sql, valores)
        db.commit()
        return {"status": "success", "message": "Producto registrado con éxito"}
    except Exception as e:
        # ESTO ES VITAL: Revisa tu terminal de Python para ver este mensaje
        print(f"❌ ERROR EN INSERTAR PRODUCTO: {str(e)}")
        return {"status": "error", "message": f"Error en base de datos: {str(e)}"}
    finally:
        if 'cursor' in locals():
            cursor.close()
        if db:
            db.close()
            
def obtener_proveedores_ordenados():
    db = obtener_conexion()
    if not db:
        return []
    
    try:
        cursor = db.cursor(dictionary=True)
        # 🟢 El secreto está en el "ORDER BY id DESC"
        # DESC significa "Descendente" (del más grande al más pequeño)
        cursor.execute("SELECT * FROM proveedor ORDER BY id_proveedor DESC")
        return cursor.fetchall()
    except Exception as e:
        print("Error al listar:", e)
        return []
    finally:
        cursor.close()
        db.close()#

def eliminar_producto_db(id_producto):
    db = obtener_conexion()
    if not db: return False
    try:
        cursor = db.cursor()
        cursor.execute("DELETE FROM producto WHERE id_producto = %s", (id_producto,))
        db.commit()
        return True
    except Exception as e:
        print(f"Error al eliminar: {e}")
        return False
    finally:
        cursor.close()
        db.close()

def editar_producto_db(id_producto, nombre, descripcion, precio, cantidad):
    db = obtener_conexion()
    if not db: return False
    try:
        cursor = db.cursor()
        sql = """UPDATE producto 
                 SET nombre=%s, descripcion=%s, precio=%s, cantidad=%s 
                 WHERE id_producto=%s"""
        cursor.execute(sql, (nombre, descripcion, precio, cantidad, id_producto))
        db.commit()
        return True
    except Exception as e:
        print(f"Error al editar: {e}")
        return False
    finally:
        cursor.close()
        db.close()

def eliminar_cliente_db(id_cliente):
    db = obtener_conexion()
    if not db: return False
    try:
        cursor = db.cursor()
        cursor.execute("DELETE FROM cliente WHERE id_cliente = %s", (id_cliente,))
        db.commit()
        return True
    except Exception as e:
        print(f"Error al eliminar cliente: {e}")
        return False
    finally:
        cursor.close()
        db.close()

def editar_cliente_db(id_cliente, nombre, direccion, gmail, celular):
    db = obtener_conexion()
    if not db: return False
    try:
        cursor = db.cursor()
        sql = """UPDATE cliente 
                 SET nombre=%s, direccion_residencia=%s, gmail_corporativo=%s, celular=%s 
                 WHERE id_cliente=%s"""
        cursor.execute(sql, (nombre, direccion, gmail, celular, id_cliente))
        db.commit()
        return True
    except Exception as e:
        print(f"Error al editar cliente: {e}")
        return False
    finally:
        cursor.close()
        db.close()

def eliminar_proveedor_db(id_proveedor):
    db = obtener_conexion()
    if not db: return False
    try:
        cursor = db.cursor()
        cursor.execute("DELETE FROM proveedor WHERE id_proveedor = %s", (id_proveedor,))
        db.commit()
        return True
    except Exception as e:
        print(f"Error al eliminar proveedor: {e}")
        return False
    finally:
        cursor.close()
        db.close()

def editar_proveedor_db(id_proveedor, nombre, direccion, gmail, telefono):
    db = obtener_conexion()
    if not db: return False
    try:
        cursor = db.cursor()
        sql = """UPDATE proveedor 
                 SET nombre=%s, direccion=%s, gmail=%s, telefono=%s 
                 WHERE id_proveedor=%s"""
        cursor.execute(sql, (nombre, direccion, gmail, telefono, id_proveedor))
        db.commit()
        return True
    except Exception as e:
        print(f"Error al editar proveedor: {e}")
        return False
    finally:
        cursor.close()
        db.close()
        db.close()        

def obtener_usuario(id_usuario):
    db = obtener_conexion()
    if not db: return None
    try:
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT id_usuario, usuario, email FROM usuario WHERE id_usuario = %s", (id_usuario,))
        return cursor.fetchone()
    except Exception as e:
        print(f"Error en obtener_usuario: {e}")
        return None
    finally:
        cursor.close()
        db.close()

def guardar_codigo_recuperacion(email, codigo):
    db = obtener_conexion()
    if not db: return False
    try:
        cursor = db.cursor()
        cursor.execute("DELETE FROM recuperacion_password WHERE email = %s", (email,))
        
        sql = "INSERT INTO recuperacion_password (email, codigo) VALUES (%s, %s)"
        cursor.execute(sql, (email, codigo))
        db.commit()
        return True
    except Exception as e:
        print(f"Error guardando código: {e}")
        return False
    finally:
        cursor.close()
        db.close()