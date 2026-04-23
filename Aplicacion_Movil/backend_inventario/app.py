from flask import Flask
from flask_cors import CORS
from config.db_config import SERVER_SETTINGS
from src.database import obtener_conexion
from src.routes import init_routes

app = Flask(__name__)
CORS(app) # Permite peticiones externas (Flutter)

# Inicializar las rutas del proyecto
init_routes(app)

@app.route('/')
def test():
    db = obtener_conexion()
    if db:
        db.close()
        return {"status": "ok", "message": "Conector y Base de Datos funcionando"}, 200
    return {"status": "error", "message": "No hay conexión a la DB"}, 500

if __name__ == '__main__':
    # Mantenemos tu print informativo
    print(f"Servidor corriendo en http://{SERVER_SETTINGS['host']}:{SERVER_SETTINGS['port']}")
    
    app.run(
        # CRÍTICO: '0.0.0.0' abre el servidor a la red local
        host='0.0.0.0', 
        port=SERVER_SETTINGS['port'], 
        debug=True
    )
    