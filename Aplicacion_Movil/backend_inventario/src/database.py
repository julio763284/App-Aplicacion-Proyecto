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
        if 'cursor' in locals(): cursor.close()
        if db: db.close()

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