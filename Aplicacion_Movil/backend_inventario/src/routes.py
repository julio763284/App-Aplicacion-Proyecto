import os

from flask import request, jsonify
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
    eliminar_proveedor_db
)


def init_routes(app):
    
    @app.route('/login', methods=['POST'])
    def login():
        data = request.json
        if not data: return jsonify({"status": "error", "message": "No hay datos"}), 400
        user = validar_usuario(data.get('username'), data.get('password'))
        if user:
            return jsonify({"status": "success", "message": "Bienvenido", "user": user}), 200
        return jsonify({"status": "error", "message": "Credenciales inválidas"}), 401

    @app.route('/registro', methods=['POST'])
    def registro():
        data = request.json
        res = registrar_usuario(data.get('usuario'), data.get('email'), data.get('password'))
        return jsonify(res), (201 if res["status"] == "success" else 400)

    @app.route('/registro_cliente', methods=['POST'])
    def registro_cliente():
        data = request.json
        res = registrar_cliente(data.get('nombre'), data.get('direccion_residencia'), 
                                data.get('gmail_corporativo'), data.get('celular'), data.get('imagen', ''))
        return jsonify(res), (201 if res["status"] == "success" else 400)
    
    @app.route('/registro_proveedor', methods=['GET','POST'])
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

    @app.route('/notificaciones', methods=['GET'])
    def listar_notificaciones():
        try:
            alertas = obtener_notificaciones_db()
            return jsonify(alertas), 200
        except Exception as e:
            print(f"Error en ruta notificaciones: {e}")
            return jsonify({"status": "error", "message": str(e)}), 500
        
    @app.route('/clientes', methods=['GET'])
    def listar_clientes():
        clientes = obtener_clientes_ordenados()
        if clientes is not None:
            return jsonify(clientes), 200
        return jsonify({"status": "error", "message": "Error al obtener clientes"}), 500    


    @app.route('/producto', methods=['POST'])
    def guardar_producto():
        data = request.json
        res = registrar_producto_db(
            data.get('nombre'),
            data.get('descripcion'),
            data.get('precio'),
            data.get('cantidad'),
            data.get('imagen', '')
        )

        return jsonify(res), (201 if res["status"] == "success" else 400)   
    
    @app.route('/proveedores', methods=['GET'])
    def listar_proveedores():
        proveedores = obtener_proveedores_ordenados()
        if proveedores is not None:
            return jsonify(proveedores), 200
        return jsonify({"status": "error", "message": "Error al obtener proveedores"}), 500
    
    @app.route('/producto/<int:id>', methods=['DELETE', 'OPTIONS'])
    def eliminar_producto(id):
        if request.method == 'OPTIONS': 
            return jsonify({}), 200
        # Llamamos a la función con el ID de la URL
        if eliminar_producto_db(id):
            return jsonify({"status": "success", "message": "Producto eliminado"}), 200
        return jsonify({"status": "error", "message": "No se pudo eliminar"}), 400

    @app.route('/producto/<int:id>', methods=['PUT', 'OPTIONS'])
    def editar_producto(id):
        if request.method == 'OPTIONS': 
            return jsonify({}), 200
        data = request.json
        if editar_producto_db(id, data['nombre'], data['descripcion'], data['precio'], data['cantidad']):
            return jsonify({"status": "success", "message": "Producto actualizado"}), 200
        return jsonify({"status": "error", "message": "Error al actualizar"}), 400
    
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
        # Ajustamos los campos para que coincidan con el JSON enviado por Flutter
        if editar_proveedor_db(id, data['nombre'], data.get('direccion', ''), 
                               data['gmail'], data.get('telefono', '')):
            return jsonify({"status": "success", "message": "Proveedor actualizado"}), 200
        return jsonify({"status": "error", "message": "Error al actualizar proveedor"}), 400
        return jsonify(res), (201 if res["status"] == "success" else 400)   
    