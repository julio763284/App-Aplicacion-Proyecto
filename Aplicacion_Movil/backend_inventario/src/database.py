import bcrypt
import mysql.connector 
import datetime
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


# ======================================================
# USUARIOS (tabla real: usuarios)
# ======================================================

def validar_usuario(identificador, password_plana):
    db = obtener_conexion()
    if not db: return None
    try:
        cursor = db.cursor(dictionary=True, buffered=True)
        sql = "SELECT id, nombre, correo, password_hash, rol, activo FROM usuarios WHERE nombre = %s OR correo = %s"
        cursor.execute(sql, (identificador, identificador))
        resultado = cursor.fetchone()

        if resultado:
            hash_almacenado = resultado['password_hash']

            # Detectar tipo de hash y verificar correctamente
            if hash_almacenado.startswith('scrypt:') or hash_almacenado.startswith('pbkdf2:'):
                # Hash de Werkzeug (página web)
                from werkzeug.security import check_password_hash
                es_valido = check_password_hash(hash_almacenado, password_plana)
            elif hash_almacenado.startswith('$2b$') or hash_almacenado.startswith('$2y$'):
                # Hash de bcrypt (app Flutter)
                es_valido = bcrypt.checkpw(
                    password_plana.encode('utf-8'),
                    hash_almacenado.encode('utf-8')
                )
            else:
                es_valido = False

            if es_valido:
                resultado.pop('password_hash')
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
        sql = "INSERT INTO usuarios (nombre, correo, password_hash) VALUES (%s, %s, %s)"
        cursor.execute(sql, (usuario, email, hash_pw))
        db.commit()
        return {"status": "success", "message": "¡Usuario creado!"}
    except Exception as e:
        return {"status": "error", "message": str(e)}
    finally:
        db.close()


def obtener_usuario(id_usuario):
    db = obtener_conexion()
    if not db: return None
    try:
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT id, nombre, correo, foto_perfil_url FROM usuarios WHERE id = %s", (id_usuario,))
        return cursor.fetchone()
    except Exception as e:
        print(f"Error en obtener_usuario: {e}")
        return None
    finally:
        cursor.close()
        db.close()


def actualizar_imagen_usuario(id_usuario, base64_imagen):
    db = obtener_conexion()
    if not db: return False
    try:
        cursor = db.cursor()
        sql = "UPDATE usuarios SET foto_perfil_url = %s WHERE id = %s"
        cursor.execute(sql, (base64_imagen, id_usuario))
        db.commit()
        return True
    except Exception as e:
        print(f"❌ Error al actualizar imagen en DB: {e}")
        return False
    finally:
        cursor.close()
        db.close()


def actualizar_email_db(id_usuario, nuevo_email):
    db = obtener_conexion()
    if not db: return False
    try:
        cursor = db.cursor()
        sql = "UPDATE usuarios SET correo = %s WHERE id = %s"
        cursor.execute(sql, (nuevo_email, id_usuario))
        db.commit()
        return True
    except Exception as e:
        print(f"Error al actualizar email: {e}")
        return False
    finally:
        cursor.close()
        db.close()


def actualizar_nombre_usuario(id_usuario, nuevo_nombre):
    db = obtener_conexion()
    if not db: return False
    try:
        cursor = db.cursor()
        sql = "UPDATE usuarios SET nombre = %s WHERE id = %s"
        cursor.execute(sql, (nuevo_nombre, id_usuario))
        db.commit()
        return True
    except Exception as e:
        print(f"Error al actualizar nombre: {e}")
        return False
    finally:
        cursor.close()
        db.close()


def eliminar_imagen_usuario(id_usuario):
    db = obtener_conexion()
    if not db: return False
    try:
        cursor = db.cursor()
        sql = "UPDATE usuarios SET foto_perfil_url = NULL WHERE id = %s"
        cursor.execute(sql, (id_usuario,))
        db.commit()
        return True
    except Exception as e:
        print(f"❌ Error al eliminar imagen en DB: {e}")
        return False
    finally:
        cursor.close()
        db.close()


# ======================================================
# RECUPERACIÓN DE CONTRASEÑA (usa columnas integradas en usuarios)
# ======================================================

def guardar_codigo_recuperacion(email, codigo):
    db = obtener_conexion()
    if not db: return False
    try:
        cursor = db.cursor()
        expira = datetime.datetime.now() + datetime.timedelta(minutes=15)
        sql = "UPDATE usuarios SET codigo_recuperacion = %s, codigo_expira = %s WHERE correo = %s"
        cursor.execute(sql, (codigo, expira, email))
        db.commit()
        return cursor.rowcount > 0
    except Exception as e:
        print(f"Error guardando código: {e}")
        return False
    finally:
        cursor.close()
        db.close()


def verificar_codigo_db(email, codigo):
    db = obtener_conexion()
    if not db: return False
    try:
        cursor = db.cursor(dictionary=True)
        sql = """SELECT * FROM usuarios
                 WHERE correo = %s AND codigo_recuperacion = %s AND codigo_expira > NOW()"""
        cursor.execute(sql, (email, codigo))
        resultado = cursor.fetchone()
        return resultado is not None
    except Exception as e:
        print(f"Error verificando código: {e}")
        return False
    finally:
        cursor.close()
        db.close()


def actualizar_password_db(email, nueva_password_plana):
    db = obtener_conexion()
    if not db: return False
    try:
        cursor = db.cursor()
        hash_pw = bcrypt.hashpw(nueva_password_plana.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
        sql = """UPDATE usuarios SET password_hash = %s, codigo_recuperacion = NULL, codigo_expira = NULL
                 WHERE correo = %s"""
        cursor.execute(sql, (hash_pw, email))
        db.commit()
        return True
    except Exception as e:
        print(f"Error actualizando password: {e}")
        return False
    finally:
        cursor.close()
        db.close()


# ======================================================
# CLIENTES (tabla 'cliente' -- PENDIENTE: aún no existe en mitiendaweb_db)
# ======================================================

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

def obtener_clientes_ordenados():
    try:
        conn = obtener_conexion()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM cliente ORDER BY fecha_registro DESC")
        clientes = cursor.fetchall()
        cursor.close()
        conn.close()
        return clientes
    except Exception as e:
        print(f"Error: {e}")
        return None
    
def obtener_clientes_ordenados():
    try:
        conn = obtener_conexion()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM cliente ORDER BY fecha_registro DESC")
        clientes = cursor.fetchall()
        cursor.close()
        conn.close()
        return clientes
    except Exception as e:
        print(f"Error: {e}")
        return None

def obtener_usuarios_clientes():
    db = obtener_conexion()
    if not db: return []
    try:
        cursor = db.cursor(dictionary=True)
        cursor.execute("""
            SELECT 
                id              AS id_cliente,
                nombre          AS nombre_completo,
                correo          AS correo_electronico,
                telefono        AS telefono,
                NULL            AS direccion_residencia
            FROM usuarios
            WHERE rol = 'cliente'
            ORDER BY creado_el DESC
        """)
        return cursor.fetchall()
    except Exception as e:
        print(f"Error en obtener_usuarios_clientes: {e}")
        return []
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


# ======================================================
# PROVEEDORES (tabla 'proveedor' -- PENDIENTE: aún no existe en mitiendaweb_db)
# ======================================================

def registrar_proveedor(nombre, direccion, gmail, telefono):
    db = obtener_conexion()
    if not db:
        return {"status": "error", "message": "Error de conexion"}
    try:
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT id_proveedor FROM proveedor WHERE gmail = %s", (gmail,))
        existe = cursor.fetchone()

        if existe:
            return {"status": "error", "message": "El correo ya está registrado"}

        sql = "INSERT INTO proveedor (nombre, direccion, gmail, telefono) VALUES (%s, %s, %s, %s)"
        cursor.execute(sql, (nombre, direccion, gmail, telefono))
        db.commit()
        return {"status": "success", "message": "Proveedor registrado"}
    except Exception as e:
        print("ERROR:", e)
        return {"status": "error", "message": "Error interno"}
    finally:
        cursor.close()
        db.close()


def obtener_proveedores_ordenados():
    db = obtener_conexion()
    if not db:
        return []
    try:
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT * FROM proveedor ORDER BY id_proveedor DESC")
        return cursor.fetchall()
    except Exception as e:
        print("Error al listar:", e)
        return []
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


# ======================================================
# PRODUCTOS (tabla real: productos)
# ======================================================

def obtener_productos():
    db = obtener_conexion()
    if not db: return None
    try:
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT * FROM productos")
        return cursor.fetchall()
    finally:
        cursor.close()
        db.close()


def registrar_producto_db(nombre, descripcion, precio_compra, precio_venta, stock, stock_minimo, imagen_url):
    db = obtener_conexion()
    if not db:
        return {"status": "error", "message": "Error de conexión con la base de datos"}
    try:
        cursor = db.cursor()
        sql = """INSERT INTO productos (nombre, descripcion, precio_compra, precio_venta, stock, stock_minimo, imagen_url, estado)
                 VALUES (%s, %s, %s, %s, %s, %s, %s, 1)"""
        valores = (nombre, descripcion, precio_compra, precio_venta, stock, stock_minimo, imagen_url)
        cursor.execute(sql, valores)
        db.commit()
        return {"status": "success", "message": "Producto registrado con éxito"}
    except Exception as e:
        print(f"❌ ERROR EN INSERTAR PRODUCTO: {str(e)}")
        return {"status": "error", "message": f"Error en base de datos: {str(e)}"}
    finally:
        if 'cursor' in locals():
            cursor.close()
        if db:
            db.close()


def editar_producto_db(id_producto, nombre, descripcion, precio_compra, precio_venta, stock, stock_minimo):
    db = obtener_conexion()
    if not db: return False
    try:
        cursor = db.cursor()
        sql = """UPDATE productos
                 SET nombre=%s, descripcion=%s, precio_compra=%s, precio_venta=%s, stock=%s, stock_minimo=%s
                 WHERE id=%s"""
        cursor.execute(sql, (nombre, descripcion, precio_compra, precio_venta, stock, stock_minimo, id_producto))
        db.commit()
        return True
    except Exception as e:
        print(f"Error al editar: {e}")
        return False
    finally:
        cursor.close()
        db.close()


def eliminar_producto_db(id_producto):
    db = obtener_conexion()
    if not db: return False
    try:
        cursor = db.cursor()
        cursor.execute("DELETE FROM productos WHERE id = %s", (id_producto,))
        db.commit()
        return True
    except Exception as e:
        print(f"Error al eliminar: {e}")
        return False
    finally:
        cursor.close()
        db.close()


def validar_y_notificar_stock(id_producto):
    db = obtener_conexion()
    if not db: return
    try:
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT nombre, stock, stock_minimo FROM productos WHERE id = %s", (id_producto,))
        p = cursor.fetchone()
        if p and p['stock'] <= p['stock_minimo']:
            msg = f"Stock bajo: {p['nombre']} ({p['stock']} u.)"
            cursor.execute("INSERT INTO notificaciones (mensaje) VALUES (%s)", (msg,))
            db.commit()
    finally:
        cursor.close()
        db.close()


def verificar_stock_bajo():
    db = obtener_conexion()
    if not db:
        return False
    try:
        cursor = db.cursor(dictionary=True)
        sql = """
            SELECT id, nombre, stock, stock_minimo
            FROM productos
            WHERE stock <= stock_minimo
        """
        cursor.execute(sql)
        productos = cursor.fetchall()

        for producto in productos:
            if producto['stock'] == 0:
                mensaje = (
                    f"🚨 AGOTADO: {producto['nombre']} "
                    f"| Stock actual: 0"
                )
            else:
                mensaje = (
                    f"⚠️ {producto['nombre']} "
                    f"| Stock actual: {producto['stock']} "
                    f"| Stock mínimo: {producto['stock_minimo']}"
                )

            # Evitar duplicar notificaciones
            cursor.execute("""
                SELECT id FROM notificaciones
                WHERE mensaje = %s
                ORDER BY id DESC LIMIT 1
            """, (mensaje,))
            existe = cursor.fetchone()

            if not existe:
                cursor.execute(
                    "INSERT INTO notificaciones (mensaje) VALUES (%s)",
                    (mensaje,)
                )

        db.commit()
        return True
    except Exception as e:
        print(f"Error verificando stock: {e}")
        return False
    finally:
        cursor.close()
        db.close()


# ======================================================
# NOTIFICACIONES
# ======================================================

def obtener_notificaciones_db():
    db = obtener_conexion()
    if not db: return []
    try:
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT mensaje, DATE_FORMAT(fecha_creacion, '%d/%m/%Y %H:%i') as fecha FROM notificaciones ORDER BY id DESC")
        return cursor.fetchall()
    finally:
        cursor.close()
        db.close()


# ======================================================
# REPORTES (basados en pedidos reales de la tienda)
# ======================================================

def obtener_reportes_db():
    db = obtener_conexion()
    if not db: return []
    try:
        cursor = db.cursor(dictionary=True)
        sql = """
            SELECT 
                p.id AS id_reporte,
                CONCAT('Pedido #', p.referencia) AS titulo,
                CONCAT(
                    'Cliente: ', u.nombre, ' | Estado: ', p.estado, 
                    ' | ', p.ciudad_envio
                ) AS descripcion,
                p.total AS monto,
                p.fecha_creacion AS fecha
            FROM pedidos p
            JOIN usuarios u ON p.usuario_id = u.id
            ORDER BY p.fecha_creacion DESC
        """
        cursor.execute(sql)
        reportes = cursor.fetchall()

        for r in reportes:
            if r.get('fecha') and hasattr(r['fecha'], 'strftime'):
                r['fecha'] = r['fecha'].strftime('%Y-%m-%d %H:%M:%S')
        return reportes
    except Exception as e:
        print(f"Error al listar reportes: {e}")
        return []
    finally:
        if 'cursor' in locals(): cursor.close()
        db.close()


# ======================================================
# SOPORTE / CHATS
# ======================================================

def obtener_chats_abiertos_db():
    db = obtener_conexion()
    if not db:
        return []
    try:
        cursor = db.cursor(dictionary=True)
        sql = """
            SELECT
                usuario_id,
                nombre,
                correo,
                COUNT(*) AS total_mensajes,
                MAX(fecha_creacion) AS ultima_fecha,
                SUBSTRING_INDEX(
                    GROUP_CONCAT(mensaje ORDER BY fecha_creacion DESC),
                    ',', 1
                ) AS ultimo_mensaje
            FROM soporte
            WHERE estado IN ('PENDIENTE', 'EN_PROCESO')
            GROUP BY usuario_id, nombre, correo
            ORDER BY ultima_fecha DESC
        """
        cursor.execute(sql)
        return cursor.fetchall()
    except Exception as e:
        print(f"Error chats: {e}")
        return []
    finally:
        cursor.close()
        db.close()
# ======================================================
# REPORTES DE VENTA
# ======================================================

def registrar_reporte_db(titulo, descripcion, monto):
    db = obtener_conexion()
    if not db:
        return False
    try:
        cursor = db.cursor()
        sql = "INSERT INTO reporte_venta (titulo, descripcion, monto, fecha) VALUES (%s, %s, %s, CURRENT_TIMESTAMP)"
        cursor.execute(sql, (titulo, descripcion, monto))
        db.commit()
        return True
    except Exception as e:
        print(f"Error al registrar: {e}")
        return False
    finally:
        cursor.close()
        db.close()


def editar_reporte_db(id_reporte, titulo, descripcion, monto):
    db = obtener_conexion()
    if not db:
        return False
    try:
        cursor = db.cursor()
        cursor.execute(
            "UPDATE reporte_venta SET titulo=%s, descripcion=%s, monto=%s WHERE id_reporte=%s",
            (titulo, descripcion, monto, id_reporte)
        )
        db.commit()
        return True
    except Exception as e:
        print(f"Error al editar reporte: {e}")
        return False
    finally:
        cursor.close()
        db.close()


def eliminar_reporte_db(id_reporte):
    db = obtener_conexion()
    if not db:
        return False
    try:
        cursor = db.cursor()
        cursor.execute("DELETE FROM reporte_venta WHERE id_reporte = %s", (id_reporte,))
        db.commit()
        return True
    except Exception as e:
        print(f"Error al eliminar reporte: {e}")
        return False
    finally:
        cursor.close()
        db.close()