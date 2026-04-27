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
    imagen VARCHAR(255)
);