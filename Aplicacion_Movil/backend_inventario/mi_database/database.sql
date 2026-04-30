CREATE DATABASE IF NOT EXISTS db_inventario;
USE db_inventario;

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL
);

CREATE TABLE producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    cantidad INT NOT NULL DEFAULT 0, 
    estado ENUM('Disponible', 'Stock Bajo', 'Agotado') DEFAULT 'Agotado',
    imagen VARCHAR(255) 
);

CREATE TABLE pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('en espera', 'recibido') NOT NULL
);

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    direccion_residencia VARCHAR(255) NOT NULL,
    gmail_corporativo VARCHAR(255) NOT NULL UNIQUE,
    celular VARCHAR(20) NOT NULL,
    imagen VARCHAR(255),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE proveedor (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    gmail VARCHAR(255) NOT NULL,
    telefono VARCHAR(255) NOT NULL
);
//agregue 30 de abril de 2026//
ALTER TABLE proveedor ADD UNIQUE (gmail);


CREATE TABLE notificaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mensaje TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    leido BOOLEAN DEFAULT FALSE
);

DELIMITER //

CREATE TRIGGER tr_actualizar_stock_y_notificar
AFTER UPDATE ON producto
FOR EACH ROW
BEGIN
    IF NEW.cantidad <= 5 AND NEW.cantidad > 0 AND OLD.cantidad > 5 THEN
        INSERT INTO notificaciones (mensaje, leido) 
        VALUES (CONCAT('Stock bajo: El producto "', NEW.nombre, '" tiene solo ', NEW.cantidad, ' unidades.'), 0);
    END IF;

    IF NEW.cantidad = 0 AND OLD.cantidad > 0 THEN
        INSERT INTO notificaciones (mensaje, leido) 
        VALUES (CONCAT('¡AGOTADO!: El producto "', NEW.nombre, '" se ha quedado sin existencias.'), 0);
    END IF;
END //

DELIMITER ;