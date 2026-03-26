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

app.post('/clientes', (req, res) => {
  const { nombre, direccion, correo, telefono } = req.body;

  const sql = `
    INSERT INTO cliente (nombre, direccion, correo, telefono)
    VALUES (?, ?, ?, ?)
  `;

  db.query(sql, [nombre, direccion, correo, telefono], (err, result) => {
    if (err) {
      console.log("❌ ERROR REAL:", err); 
      res.status(500).send(err);
    } else {
      res.json({ mensaje: "Cliente guardado" });
    }
  });
});
app.post('/proveedores', (req, res) => {
  const { nombre, telefono, email, direccion } = req.body;

  const sql = `
    INSERT INTO proveedor (nombre, telefono, email, direccion)
    VALUES (?, ?, ?, ?)
  `;

  db.query(sql, [nombre, telefono, email, direccion], (err, result) => {
    if (err) {
      console.log("❌ ERROR REAL:", err); 
      res.status(500).send(err);
    } else {
      res.json({ mensaje: "Proveedor guardado correctamente" });
    }
  });
});

app.get('/movimientos', (req, res) => {
  db.query(
    `SELECT MONTH(fecha) as mes, SUM(cantidad) as total
     FROM movimientos_inventario
     WHERE tipo = 'salida'
     GROUP BY mes
     ORDER BY mes`,
    (err, results) => {
      if (err) {
        console.log(err);
        res.status(500).send(err);
      } else {
        res.json(results);
      }
    }
  );
});

app.listen(3000, '0.0.0.0', () => {
  console.log('🚀 Servidor corriendo');
}); 
app.use(express.json({ limit: '10mb' }));