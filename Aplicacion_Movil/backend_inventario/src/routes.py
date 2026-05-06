from flask import request, jsonify
from flask_cors import CORS
from src.database import (
    validar_usuario, registrar_usuario, registrar_cliente, 
    registrar_proveedor, obtener_productos, obtener_notificaciones_db,
    obtener_clientes_ordenados, obtener_proveedores_ordenados,
    registrar_producto_db, eliminar_producto_db, editar_producto_db
)

def init_routes(app):
    CORS(app)

    @app.route('/login', methods=['POST'])
    def login():
        data = request.json
        user = validar_usuario(data.get('username'), data.get('password'))
        if user:
            return jsonify({"status": "success", "user": user}), 200
        return jsonify({"status": "error"}), 401

    @app.route('/registro', methods=['POST'])
    def registro():
        data = request.json
        res = registrar_usuario(data.get('usuario'), data.get('email'), data.get('password'))
        return jsonify(res), 201

    @app.route('/productos', methods=['GET'])
    def listar_productos():
        return jsonify(obtener_productos() or []), 200

    @app.route('/producto', methods=['POST'])
    def guardar_producto():
        data = request.json
        res = registrar_producto_db(data.get('nombre'), data.get('descripcion'), 
                                   data.get('precio'), data.get('cantidad'), data.get('imagen', ''))
        return jsonify(res), 201

    @app.route('/producto/<int:id>', methods=['DELETE', 'OPTIONS'])
    def eliminar_producto(id):
        if request.method == 'OPTIONS': return jsonify({}), 200
        if eliminar_producto_db(id):
            return jsonify({"status": "success"}), 200
        return jsonify({"status": "error"}), 400

    @app.route('/producto/<int:id>', methods=['PUT', 'OPTIONS'])
    def editar_producto(id):
        if request.method == 'OPTIONS': return jsonify({}), 200
        data = request.json
        if editar_producto_db(id, data['nombre'], data['descripcion'], data['precio'], data['cantidad']):
            return jsonify({"status": "success"}), 200
        return jsonify({"status": "error"}), 400