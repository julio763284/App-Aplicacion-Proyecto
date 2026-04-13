const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json({ limit: '10mb' }));

// configuración de la conexión
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'Sena123*',
    database: 'sena_proyecto'
});

db.connect((err) => {
    if (err) {
        console.log('❌ error de conexión:', err);
    } else {
        console.log('🔥 conectado a mysql');
    }
});

// login de usuario
app.post('/login', (req, res) => {
    const { correo, password } = req.body;
    const sql = "SELECT * FROM usuario WHERE correo = ? AND password = ?";
    
    db.query(sql, [correo, password], (err, result) => {
        if (err) return res.status(500).json({ mensaje: "error" });
        if (result.length > 0) {
            res.json({ mensaje: "login exitoso", usuario: result[0] });
        } else {
            res.status(401).json({ mensaje: "credenciales incorrectas" });
        }
    });
});

// registro de usuario
app.post('/registro', (req, res) => {
    const { nombre, correo, password } = req.body;
    const sql = "INSERT INTO usuario (nombre, correo, password) VALUES (?, ?, ?)";
    db.query(sql, [nombre, correo, password], (err, result) => {
        if (err) {
            console.log("❌ error al registrar:", err);
            return res.status(500).json({ mensaje: "error al registrar", detalle: err });
        }
        res.json({ mensaje: "usuario registrado correctamente" });
    });
});

// guardar clientes
app.post('/clientes', (req, res) => {
    const { nombre, direccion, correo, telefono } = req.body;
    const sql = "INSERT INTO cliente (nombre, direccion, correo, telefono) VALUES (?, ?, ?, ?)";
    db.query(sql, [nombre, direccion, correo, telefono], (err, result) => {
        if (err) return res.status(500).json({ mensaje: "error al guardar cliente" });
        res.json({ mensaje: "cliente guardado" });
    });
});

// guardar proveedores
app.post('/proveedores', (req, res) => {
    const { nombre, telefono, email, direccion } = req.body;
    const sql = "INSERT INTO proveedor (nombre, telefono, email, direccion) VALUES (?, ?, ?, ?)";
    db.query(sql, [nombre, telefono, email, direccion], (err, result) => {
        if (err) return res.status(500).json({ mensaje: "error al guardar proveedor" });
        res.json({ mensaje: "proveedor guardado correctamente" });
    });
});

// obtener movimientos
app.get('/movimientos', (req, res) => {

    const sql = `
        SELECT MONTH(fecha) as mes, SUM(cantidad) as total 
        FROM movimiento_inventario 
        WHERE tipo = 'salida' 
        GROUP BY mes 
        ORDER BY mes
    `;
    
    db.query(sql, (err, results) => {
        if (err) {
            console.log("❌ error en query movimientos:", err);
            return res.status(500).json({ mensaje: "error al obtener movimientos", detalle: err });
        }
        res.json(results);
    });
});

// servidor
app.listen(3000, '0.0.0.0', () => {
    console.log('🚀 servidor corriendo en el puerto 3000');
});