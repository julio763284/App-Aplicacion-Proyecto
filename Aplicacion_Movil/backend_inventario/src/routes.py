# backend_inventario/src/routes.py
from flask import request, jsonify
from src.database import validar_usuario

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
       # En backend_inventario/src/routes.py
        else:
            return jsonify({
                "status": "error", 
                "message": "Este usuario no está registrado. ¿Deseas crear una cuenta nueva?"
            }), 401