# backend_inventario/src/routes.py
from flask import request, jsonify
from src.database import validar_usuario, registrar_usuario

def init_routes(app):
    
    @app.route('/login', methods=['POST'])
    def login():
        data = request.json
        if not data:
            return jsonify({"status": "error", "message": "No se enviaron datos"}), 400
            
        user = data.get('username')
        pw = data.get('password')
        
        if not user or not pw:
            return jsonify({"status": "error", "message": "Usuario y contraseña requeridos"}), 400
        
        usuario_encontrado = validar_usuario(user, pw)
        
        if usuario_encontrado:
            return jsonify({
                "status": "success",
                "message": "Bienvenido al sistema",
                "user": usuario_encontrado
            }), 200
        else:
            return jsonify({
                "status": "error", 
                "message": "Este usuario no está registrado. ¿Deseas crear una cuenta nueva?"
            }), 401

    @app.route('/registro', methods=['POST'])
    def registro():
        data = request.json
        if not data:
            return jsonify({"status": "error", "message": "No se enviaron datos"}), 400

        usuario = data.get('usuario')
        email = data.get('email')
        password = data.get('password')
        
        if not usuario or not email or not password:
            return jsonify({"status": "error", "message": "Todos los campos son obligatorios"}), 400
            
        resultado = registrar_usuario(usuario, email, password)
        
        if resultado["status"] == "success":
            return jsonify(resultado), 201
        else:
            return jsonify(resultado), 400