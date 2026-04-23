from flask import Flask
from config.db_config import SERVER_SETTINGS
from src.database import obtener_conexion

app = Flask(__name__)

@app.route('/test-db')
def test():
    db = obtener_conexion()
    if db:
        db.close()
        return "Conexión exitosa al conector", 200
    return "Error de conexión", 500

if __name__ == '__main__':
    app.run(
        host=SERVER_SETTINGS['host'], 
        port=SERVER_SETTINGS['port'], 
        debug=True
    )