const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'Sena123*',
    database: 'sena_proyecto'
});

db.connect((err) => {
    if (err) {
        console.log('❌ Error de conexión:', err);
    } else {
        console.log('🔥 Conectado a MySQL');
    }
});

app.get('/', (req, res) => {
    res.send('Servidor funcionando 🔥');
});

app.post('/registro', (req, res) => {

    const { nombre, correo, password } = req.body;

const sql = "INSERT INTO usuario (nombre, correo, password) VALUES (?, ?, ?)";

    db.query(sql, [nombre, correo, password], (err, result) => {

        if (err) {
            console.log("ERROR MYSQL:", err);
            res.status(500).send(err);
        } else {
            res.json({ mensaje: "Usuario registrado correctamente" });
        }

    });

});

app.listen(3000, () => {
    console.log('🚀 Servidor corriendo en http://localhost:3000');
});


