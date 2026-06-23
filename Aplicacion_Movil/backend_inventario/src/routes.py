import os
import smtplib
import random
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from flask import request, jsonify

from config.db_config import MAIL_SETTINGS
from src.database import (
    obtener_usuario,
    validar_usuario,
    registrar_usuario,
    registrar_cliente,
    registrar_proveedor,
    obtener_productos,
    obtener_notificaciones_db,
    obtener_clientes_ordenados,
    obtener_proveedores_ordenados,
    registrar_producto_db,
    editar_producto_db,
    eliminar_producto_db,
    editar_cliente_db,
    eliminar_cliente_db,
    editar_proveedor_db,
    eliminar_proveedor_db,
    guardar_codigo_recuperacion,
    actualizar_imagen_usuario,
    actualizar_email_db,
    actualizar_nombre_usuario,
    verificar_codigo_db,
    actualizar_password_db,
    eliminar_imagen_usuario,
    obtener_reportes_db,
    verificar_stock_bajo
)

def init_routes(app):

    @app.route('/login', methods=['POST'])
    def login():
        data = request.json
        if not data: 
            return jsonify({"status": "error", "message": "No hay datos"}), 400
            
        # Intentamos obtener el usuario buscando por 'username' o por 'correo' / 'email' por si la app móvil lo manda diferente
        identificador = data.get('username') or data.get('correo') or data.get('email')
        password = data.get('password')

        # 1. Validamos que el usuario y contraseña sean correctos
        user = validar_usuario(identificador, password)
        
        if user:
            # 2. Extraemos el rol del usuario (en minúsculas para evitar fallos de mayúsculas)
            rol_usuario = user.get('rol', '').lower()
            
            # PERMITIR TANTO A 'superadmin' COMO A 'admin' ENTRAR A LA APP
            if rol_usuario == 'superadmin' or rol_usuario == 'admin':
                return jsonify({
                    "status": "success", 
                    "message": f"Bienvenido {rol_usuario.capitalize()}", 
                    "user": user
                }), 200
            else:
                # Si los datos son reales pero es un rol de cliente, le bloqueamos el paso
                return jsonify({
                    "status": "error", 
                    "message": "Acceso denegado: Solo se permiten usuarios Administradores."
                }), 403 # Código 403: Prohibido/No autorizado
                
        return jsonify({"status": "error", "message": "Credenciales inválidas"}), 401

    @app.route('/registro', methods=['POST'])
    def registro():
        data = request.json
        res = registrar_usuario(data.get('usuario'), data.get('email'), data.get('password'))
        return jsonify(res), (201 if res["status"] == "success" else 400)

    @app.route('/registro_cliente', methods=['POST'])
    def registro_cliente():
        datos = request.get_json()
        if not datos: 
            return jsonify({"status": "error", "message": "No hay datos recibidos"}), 400
        
        nombre = datos.get('nombre')
        direccion = datos.get('direccion_residencia')
        correo = datos.get('gmail_corporativo')
        celular = datos.get('celular')
        imagen = datos.get('imagen', '')
        
        if not nombre or not correo:
            return jsonify({"status": "error", "message": "Nombre y Correo son obligatorios"}), 400
            
        resultado = registrar_cliente(nombre, direccion, correo, celular, imagen)
        # Retorna 201 si fue exitoso, de lo contrario 400
        return jsonify(resultado), (201 if resultado["status"] == "success" else 400)

    @app.route('/registro_proveedor', methods=['GET', 'POST'])
    def registro_proveedor():
        data = request.get_json(force=True)
        print("DATA RECIBIDA:", data)
        res = registrar_proveedor(data.get('nombre'), data.get('direccion'),
                                 data.get('gmail'), data.get('telefono'))
        return jsonify(res), (201 if res["status"] == "success" else 400)

    @app.route('/productos', methods=['GET'])
    def listar_productos():
        productos = obtener_productos()
        if productos is not None: return jsonify(productos), 200
        return jsonify({"status": "error", "message": "Error al obtener productos"}), 500
    

    @app.route('/producto', methods=['POST'])
    def guardar_producto():
        if res["status"] == "success":
            verificar_stock_bajo()
            data = request.json
            res = registrar_producto_db(
            data.get('nombre'),
            data.get('descripcion'),
            data.get('precio_compra'),
            data.get('precio_venta'),
            data.get('stock'),
            data.get('stock_minimo'),
            data.get('imagen_url', '')
        )

        if res["status"] == "success":
            verificar_stock_bajo()
        return jsonify(res), (201 if res["status"] == "success" else 400)

    @app.route('/producto/<int:id>', methods=['DELETE', 'OPTIONS'])
    def eliminar_producto(id):
        if request.method == 'OPTIONS':
            return jsonify({}), 200
        if eliminar_producto_db(id):
            return jsonify({"status": "success", "message": "Producto eliminado"}), 200
        return jsonify({"status": "error", "message": "No se pudo eliminar"}), 400

    @app.route('/producto/<int:id>', methods=['PUT', 'OPTIONS'])
    def editar_producto(id):
        if request.method == 'OPTIONS':
            return jsonify({}), 200
        data = request.json
        if editar_producto_db(id,
                               data['nombre'],
                               data['descripcion'],
                               data['precio_compra'],
                               data['precio_venta'],
                               data['stock'],
                               data['stock_minimo']
                            ):
                                verificar_stock_bajo()
                                return jsonify({"status": "success", "message": "Producto actualizado"}), 200
                                return jsonify({"status": "error", "message": "Error al actualizar"}), 400

    @app.route('/notificaciones', methods=['GET'])
    def listar_notificaciones():
        alertas = obtener_notificaciones_db()
        print(alertas)
        return jsonify(alertas)

    @app.route('/clientes', methods=['GET'])
    def listar_clientes():
        clientes = obtener_clientes_ordenados()
        if clientes is not None:
            return jsonify(clientes), 200
        return jsonify({"status": "error", "message": "Error al obtener clientes"}), 500

    @app.route('/cliente/<int:id>', methods=['DELETE'])
    def eliminar_cliente(id):
        if eliminar_cliente_db(id):
            return jsonify({"status": "success", "message": "Cliente eliminado"}), 200
        return jsonify({"status": "error", "message": "No se pudo eliminar"}), 400

    @app.route('/cliente/<int:id>', methods=['PUT'])
    def editar_cliente(id):
        data = request.json
        if editar_cliente_db(id, data['nombre'], data['direccion_residencia'],
                             data['gmail_corporativo'], data['celular']):
            return jsonify({"status": "success", "message": "Cliente actualizado"}), 200
        return jsonify({"status": "error", "message": "Error al actualizar"}), 400

    @app.route('/proveedores', methods=['GET'])
    def listar_proveedores():
        proveedores = obtener_proveedores_ordenados()
        if proveedores is not None:
            return jsonify(proveedores), 200
        return jsonify({"status": "error", "message": "Error al obtener proveedores"}), 500

    @app.route('/proveedor/<int:id>', methods=['DELETE', 'OPTIONS'])
    def eliminar_proveedor(id):
        if request.method == 'OPTIONS': return jsonify({}), 200
        if eliminar_proveedor_db(id):
            return jsonify({"status": "success", "message": "Proveedor eliminado"}), 200
        return jsonify({"status": "error", "message": "No se pudo eliminar el proveedor"}), 400

    @app.route('/proveedor/<int:id>', methods=['PUT', 'OPTIONS'])
    def editar_proveedor(id):
        if request.method == 'OPTIONS': return jsonify({}), 200
        data = request.json
        if editar_proveedor_db(id, data['nombre'], data.get('direccion', ''),
                               data['gmail'], data.get('telefono', '')):
            return jsonify({"status": "success", "message": "Proveedor actualizado"}), 200
        return jsonify({"status": "error", "message": "Error al actualizar proveedor"}), 400

    @app.route('/enviar_codigo', methods=['POST', 'OPTIONS'])
    def ruta_enviar_codigo():
        if request.method == 'OPTIONS':
            return jsonify({"status": "ok"}), 200
        try:
            data = request.json
            email = data.get('email')
            if not email:
                return jsonify({"status": "error", "message": "El correo es requerido"}), 400
            codigo = str(random.randint(100000, 999999))
            exito_db = guardar_codigo_recuperacion(email, codigo)
            if exito_db:
                exito_email = enviar_email_codigo(email, codigo)
                if exito_email:
                    print(f"✅ Código {codigo} enviado con éxito a {email}")
                    return jsonify({
                        "status": "success",
                        "message": "Código enviado correctamente a tu correo"
                    }), 200
                else:
                    return jsonify({
                        "status": "error",
                        "message": "Error al enviar el correo. Revisa tu configuración SMTP."
                    }), 500
            else:
                return jsonify({
                    "status": "error",
                    "message": "El correo no está registrado en el sistema"
                }), 404
        except Exception as e:
            print(f"❌ Error crítico en ruta_enviar_codigo: {e}")
            return jsonify({"status": "error", "message": "Error interno del servidor"}), 500

    @app.route('/perfil', methods=['GET'])
    def perfil():
        user_id = request.args.get('id')
        if not user_id:
            return jsonify({"status": "error", "message": "ID requerido"}), 400
        user = obtener_usuario(user_id)
        if user:
            return jsonify({
                "nombre": user['nombre'],
                "correo": user['correo'],
                "imagen": user['foto_perfil_url']
            }), 200
        return jsonify({"status": "error", "message": "Usuario no encontrado"}), 404

    @app.route('/subir_imagen', methods=['POST'])
    def subir_imagen():
        data = request.json
        user_id = data.get('id')
        base64_imagen = data.get('imagen')
        if not user_id or not base64_imagen:
            return jsonify({"status": "error", "message": "Datos incompletos"}), 400
        if actualizar_imagen_usuario(user_id, base64_imagen):
            return jsonify({"status": "success", "message": "Imagen actualizada"}), 200
        return jsonify({"status": "error", "message": "No se pudo guardar la imagen"}), 500

    @app.route('/verificar_y_cambiar_password', methods=['POST', 'OPTIONS'])
    def verificar_y_cambiar_password():
        if request.method == 'OPTIONS':
            return jsonify({"status": "ok"}), 200
        data = request.json
        email = data.get('email')
        codigo = data.get('codigo')
        nueva_password = data.get('nuevo_password')
        if not email or not codigo or not nueva_password:
            return jsonify({"status": "error", "message": "Datos incompletos"}), 400
        if verificar_codigo_db(email, codigo):
            if actualizar_password_db(email, nueva_password):
                return jsonify({"status": "success", "message": "Contraseña actualizada correctamente"}), 200
            else:
                return jsonify({"status": "error", "message": "Error al actualizar en base de datos"}), 500
        else:
            return jsonify({"status": "error", "message": "Código de verificación incorrecto"}), 401

    @app.route('/verificar_y_cambiar_email', methods=['POST', 'OPTIONS'])
    def verificar_y_cambiar_email():
        if request.method == 'OPTIONS':
            return jsonify({"status": "ok"}), 200
        data = request.json
        user_id = data.get('id')
        nuevo_email = data.get('nuevo_email')
        codigo = data.get('codigo')
        if not user_id or not nuevo_email or not codigo:
            return jsonify({"status": "error", "message": "Datos incompletos"}), 400
        if verificar_codigo_db(nuevo_email, codigo):
            if actualizar_email_db(user_id, nuevo_email):
                return jsonify({"status": "success", "message": "Email actualizado correctamente"}), 200
            else:
                return jsonify({"status": "error", "message": "Error al actualizar email"}), 500
        else:
            return jsonify({"status": "error", "message": "Código incorrecto"}), 401

    @app.route('/actualizar_usuario', methods=['POST'])
    def actualizar_usuario():
        data = request.json
        user_id = data.get('id')
        nombre = data.get('nombre')
        if not user_id or nombre is None:
            return jsonify({"status": "error", "message": "Datos incompletos"}), 400
        if actualizar_nombre_usuario(user_id, nombre):
            return jsonify({"status": "success", "message": "Usuario actualizado"}), 200
        else:
            return jsonify({"status": "error", "message": "No se pudo actualizar usuario"}), 500

    @app.route('/eliminar_imagen', methods=['POST'])
    def eliminar_imagen():
        data = request.json
        user_id = data.get('id')
        if not user_id:
            return jsonify({"status": "error", "message": "ID requerido"}), 400
        if eliminar_imagen_usuario(user_id):
            return jsonify({"status": "success", "message": "Imagen eliminada con éxito"})
        else:
            return jsonify({"status": "error", "message": "No se pudo eliminar la imagen"}), 500

    @app.route('/reportes', methods=['GET'])
    def listar_reportes():
        return jsonify(obtener_reportes_db()), 200

    @app.route('/reporte', methods=['POST'])
    def crear_reporte():
        data = request.json
        if registrar_reporte_db(data['titulo'], data['descripcion'], data['monto']):
            return jsonify({"status": "success"}), 201
        return jsonify({"status": "error"}), 400
    
    @app.route('/verificar_stock', methods=['GET'])
    def verificar_stock():
        if verificar_stock_bajo():
            return jsonify({
                "status": "success",
                "message": "Verificación realizada"
            }), 200

        return jsonify({
            "status": "error",
            "message": "No se pudo verificar"
        }), 500
    

    @app.route('/reporte/<int:id>', methods=['PUT'])
    def editar_reporte(id):
        data = request.json
        if editar_reporte_db(id, data['titulo'], data['descripcion'], data['monto']):
            return jsonify({"status": "success"}), 200
        return jsonify({"status": "error"}), 400

    @app.route('/reporte/<int:id>', methods=['DELETE'])
    def eliminar_reporte(id):
        if eliminar_reporte_db(id):
            return jsonify({"status": "success"}), 200
        return jsonify({"status": "error"}), 400


def enviar_email_codigo(destinatario, codigo):
    msg = MIMEMultipart()
    msg['From'] = MAIL_SETTINGS['mail_user']
    msg['To'] = destinatario
    msg['Subject'] = "Código de Recuperación - Nexus Gestor"

    cuerpo_html = f"""
    <html>
        <body style="font-family: sans-serif; background-color: #0D1B1E; color: #FFFFFF; padding: 20px;">
            <div style="max-width: 400px; margin: auto; background: #162A2D; padding: 20px; border-radius: 15px; border: 1px solid #017A74;">
                <h2 style="color: #00FFFF; text-align: center;">Nexus Gestor</h2>
                <p style="text-align: center;">Has solicitado recuperar tu contraseña.</p>
                <div style="background: #0D1B1E; padding: 15px; border-radius: 10px; text-align: center; margin: 20px 0;">
                    <span style="font-size: 32px; font-weight: bold; color: #00FFFF; letter-spacing: 5px;">{codigo}</span>
                </div>
                <p style="font-size: 12px; color: #888; text-align: center;">Este código expirará pronto. Si no lo solicitaste, ignora este mensaje.</p>
            </div>
        </body>
    </html>
    """
    msg.attach(MIMEText(cuerpo_html, 'html'))

    try:
        server = smtplib.SMTP(MAIL_SETTINGS['mail_server'], MAIL_SETTINGS['mail_port'])
        server.starttls()
        server.login(MAIL_SETTINGS['mail_user'], MAIL_SETTINGS['mail_password'])
        server.send_message(msg)
        server.quit()
        return True
    except Exception as e:
        print(f"⚠️ Error SMTP: {e}")
        return False