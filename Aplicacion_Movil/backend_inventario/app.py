# backend_inventario/app.py
from flask import Flask
from flask_cors import CORS
from config.db_config import SERVER_SETTINGS
from src.database import obtener_conexion
from src.routes import init_routes

app = Flask(__name__)
CORS(app) 

init_routes(app)

@app.route('/')
def test():
    db = obtener_conexion()
    if db:
        db.close()
        return {"status": "ok", "message": "Conector funcionando"}, 200
    return {"status": "error", "message": "No hay conexión a la DB"}, 500


if __name__ == '__main__':
    # FORZAMOS el puerto 5000 y el host 0.0.0.0
    print("🚀 Servidor abriendo en puerto 5000...")
    app.run(
        host='0.0.0.0', 
        port=5000, 
        debug=True
    )
    