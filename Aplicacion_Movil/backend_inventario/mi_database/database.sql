SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "-05:00";

CREATE DATABASE IF NOT EXISTS mitiendaweb_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE mitiendaweb_db;

-- 1. TABLA USUARIOS
CREATE TABLE usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  correo VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  rol ENUM('admin','cliente') NOT NULL DEFAULT 'cliente',
  activo TINYINT(1) NOT NULL DEFAULT 1,
  creado_el TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  codigo_recuperacion VARCHAR(6) DEFAULT NULL,
  codigo_expira DATETIME DEFAULT NULL,
  telefono VARCHAR(20) DEFAULT NULL,
  direccion VARCHAR(255) DEFAULT NULL,
  ciudad VARCHAR(100) DEFAULT NULL,
  foto_perfil VARCHAR(255) DEFAULT 'default.png',
  foto_perfil_url LONGTEXT DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. TABLA PROVEEDOR (Ajustada con singular, id_proveedor y gmail)
CREATE TABLE proveedor (
  id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  direccion VARCHAR(255) NOT NULL,
  gmail VARCHAR(255) NOT NULL UNIQUE,
  telefono VARCHAR(50) NOT NULL,
  creado_el TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. TABLA DIRECCIONES_USUARIO
CREATE TABLE direcciones_usuario (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  departamento VARCHAR(100) NOT NULL,
  ciudad VARCHAR(100) NOT NULL,
  direccion_detallada VARCHAR(255) NOT NULL,
  barrio VARCHAR(100) DEFAULT NULL,
  telefono_contacto VARCHAR(20) DEFAULT NULL,
  es_principal TINYINT(1) DEFAULT 1,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. TABLA PRODUCTOS (Ajustada para apuntar correctamente a proveedor e id_proveedor)
CREATE TABLE productos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  proveedor_id INT DEFAULT NULL,
  nombre VARCHAR(120) NOT NULL,
  descripcion TEXT DEFAULT NULL,
  precio_compra DECIMAL(10,2) NOT NULL,
  precio_venta DECIMAL(10,2) NOT NULL,
  stock INT NOT NULL DEFAULT 0,
  stock_minimo INT NOT NULL DEFAULT 5,
  imagen_url LONGTEXT DEFAULT NULL,
  estado TINYINT(1) NOT NULL DEFAULT 1,
  creado_el TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  actualizado_el TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (proveedor_id) REFERENCES proveedor(id_proveedor) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. TABLA CARRITOS
CREATE TABLE carritos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL UNIQUE,
  actualizado_el TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. TABLA CARRITO_DETALLES
CREATE TABLE carrito_detalles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  carrito_id INT NOT NULL,
  producto_id INT NOT NULL,
  cantidad INT NOT NULL DEFAULT 1,
  agregado_el TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unq_carrito_producto (carrito_id, producto_id),
  FOREIGN KEY (carrito_id) REFERENCES carritos(id) ON DELETE CASCADE,
  FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. TABLA FAVORITOS
CREATE TABLE favoritos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  producto_id INT NOT NULL,
  agregado_el TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unq_usuario_producto (usuario_id, producto_id),
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
  FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8. TABLA PEDIDOS
CREATE TABLE pedidos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  referencia VARCHAR(100) NOT NULL UNIQUE,
  total DECIMAL(10,2) NOT NULL,
  estado ENUM('PENDIENTE','PAGADO','EMPACANDO','EN_TRANSITO','ENTREGADO') DEFAULT 'PENDIENTE',
  direccion_envio VARCHAR(255) NOT NULL,
  ciudad_envio VARCHAR(100) NOT NULL,
  telefono_contacto VARCHAR(20) NOT NULL,
  fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9. TABLA PEDIDO_DETALLES
CREATE TABLE pedido_detalles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  pedido_id INT NOT NULL,
  producto_id INT NOT NULL,
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
  FOREIGN KEY (producto_id) REFERENCES productos(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 10. TABLA RESEÑAS
CREATE TABLE reseñas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  producto_id INT NOT NULL,
  usuario_id INT NOT NULL,
  calificacion INT NOT NULL CHECK (calificacion >= 1 AND calificacion <= 5),
  commentario TEXT DEFAULT NULL,
  fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 11. TABLA NOTIFICACIONES
CREATE TABLE notificaciones (
  id INT AUTO_INCREMENT PRIMARY KEY,
  mensaje TEXT NOT NULL,
  leido TINYINT(1) DEFAULT 0,
  fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 12. TABLA REPORTES_VENTA
CREATE TABLE reportes_venta (
  id INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(255) NOT NULL,
  descripcion TEXT,
  monto DECIMAL(10, 2) NOT NULL,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- TRIGGERS DE CONTROL DE STOCK
DELIMITER $$
CREATE TRIGGER tr_alerta_nuevo_sin_stock 
AFTER INSERT ON productos 
FOR EACH ROW 
BEGIN
    IF NEW.stock = 0 THEN
        INSERT INTO notificaciones (mensaje, leido)
        VALUES (CONCAT('¡Alerta! El nuevo producto "', NEW.nombre, '" se ha registrado sin existencias (0 unidades).'), 0);
    END IF;
END
$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tr_alerta_stock_actualizado 
AFTER UPDATE ON productos 
FOR EACH ROW 
BEGIN
    IF NEW.stock = 0 AND OLD.stock > 0 THEN
        INSERT INTO notificaciones (mensaje, leido)
        VALUES (CONCAT('¡AGOTADO!: El producto "', NEW.nombre, '" se ha quedado sin existencias.'), 0);
    ELSEIF NEW.stock <= NEW.stock_minimo AND OLD.stock > NEW.stock_minimo AND NEW.stock > 0 THEN
        INSERT INTO notificaciones (mensaje, leido)
        VALUES (CONCAT('Stock bajo: El producto "', NEW.nombre, '" tiene solo ', NEW.stock, ' unidades.'), 0);
    END IF;
END
$$
DELIMITER ;

-- INSERCIÓN DE DATOS DE PRUEBA PRESERVADOS
INSERT INTO usuarios (id, nombre, correo, password_hash, rol, activo, creado_el, telefono, direccion, ciudad, foto_perfil, foto_perfil_url) VALUES
(2, 'jholian manuel', 'jholianmanuel10@gmail.com', 'google_auth', 'cliente', 1, '2026-06-18 05:39:11', NULL, NULL, NULL, 'default.png', NULL),
(3, 'Administrador Dunaka', 'admin@dunaka.com', '$2b$12$eOa9f5B.hF/5iW0uJ2/bSuP4U6nJqD5vXwG9e6/5kQW7.R7k9m7g2', 'admin', 1, '2026-06-18 05:53:45', NULL, NULL, NULL, 'default.png', NULL),
(4, 'juan', 'juan@gmail.com', 'scrypt:32768:8:1$yjDsK5BgJYoNuURw$6d00ab9cf0b43700c31adc9f2f886d663067fe1c20a8b1ed574ff2ed5ed5ccd9f9c6e3332a41ec835ae04afc9a59dc48711294267bb366c0384c61ac342eb40e', 'cliente', 1, '2026-06-20 04:53:56', NULL, NULL, NULL, 'default.png', NULL),
(5, 'junsa', 'juansa@gmail.com', 'scrypt:32768:8:1$UO0DhuiR5ZY7QiYn$27378a26ba9bb8068112c1644dfc7bab1ce4d63d3cf870759dca4f7a9356418638ac67f6575e3884f0f7820fee787dd88243f233ba4acf12810a28a55984ccb0', 'cliente', 1, '2026-06-20 04:54:45', NULL, NULL, NULL, 'default.png', NULL),
(6, 'Juan David Rhenals Cantillo', 'Juandavidrhenalsmontero@gmail.com', 'scrypt:32768:8:1$AvKwTHD8W2d5tA4M$706a54c3c16a4362c37765e70108f4135909a042f4ca971867347206f71fffa466addd2e62ab97c75ad34ff76c54f49c9457c7a0aecbc7305db90ac4470c173c', 'cliente', 1, '2026-06-20 18:39:16', NULL, NULL, NULL, 'default.png', NULL),
(7, 'Juan Rhenals', 'juanrhenals@gmail.com', '$2b$12$MpUMgHl7b9xIxUkLe9VXy.iJzKzWeLDDa7sTMIV8uS1EBuSisIf8q', 'cliente', 1, '2026-06-21 17:39:30', NULL, NULL, NULL, 'default.png', NULL),
(8, 'Jose Candela', 'JoseCandela@gmail.com', '', 'cliente', 1, '2026-06-21 19:27:02', '3106371087', 'Calle 23', NULL, 'default.png', ''),
(9, 'Juan David', 'Juandavid2004@gmail.com', '$2b$12$MpUMgHl7b9xIxUkLe9VXy.iJzKzWeLDDa7sTMIV8uS1EBuSisIf8q', 'admin', 1, '2026-06-22 05:41:16', '3243890134', 'calle 23', 'barranquilla', 'default.png', NULL);

INSERT INTO productos (id, nombre, descripcion, precio_compra, precio_venta, stock, stock_minimo, imagen_url, estado, creado_el, actualizado_el) VALUES
(1, 'Mochila Wayúu Multicolor', 'Mochila artesanal tejida a mano con patrones tradicionales y cordón ajustable.', 45000.00, 95000.00, 10, 5, 'https://images.pexels.com/photos/2018991/pexels-photo-2018991.jpeg?auto=compress&cs=tinysrgb&w=800', 1, '2026-06-18 05:51:19', '2026-06-18 05:51:19'),
(2, 'Bolso Tipo Saco Artesanal', 'Bolso de hombro tejido artesanalmente en fibras naturales de alta calidad.', 42000.00, 90000.00, 12, 5, 'https://images.pexels.com/photos/1204462/pexels-photo-1204462.jpeg?auto=compress&cs=tinysrgb&w=800', 1, '2026-06-18 05:51:19', '2026-06-18 05:51:19'),
(3, 'Cartera Crochet Elegante', 'Cartera de mano tejida a crochet, ideal para salas y eventos especiales.', 55000.00, 120000.00, 8, 5, 'https://images.pexels.com/photos/3731256/pexels-photo-3731256.jpeg?auto=compress&cs=tinysrgb&w=800', 1, '2026-06-18 05:51:19', '2026-06-18 05:51:19'),
(4, 'Bolso Artesanal con Flecos', 'Diseño bohemio hecho a mano con texturas tejidas y borlas decorativas.', 48000.00, 105000.00, 7, 5, 'https://images.pexels.com/photos/4066243/pexels-photo-4066243.jpeg?auto=compress&cs=tinysrgb&w=800', 1, '2026-06-18 05:51:19', '2026-06-18 05:51:19'),
(5, 'Morral Zenú Tradicional', 'Morral artesanal de diseño étnico, amplio, cómodo y muy resistente.', 38000.00, 85000.00, 15, 5, 'https://images.pexels.com/photos/2850287/pexels-photo-2850287.jpeg?auto=compress&cs=tinysrgb&w=800', 1, '2026-06-18 05:51:19', '2026-06-18 05:51:19'),
(6, 'Bolso Circular en Palma', 'Bolso tejido en espiral con fibras de palma natural, estilo veraniego.', 30000.00, 65000.00, 14, 5, 'https://images.pexels.com/photos/7161073/pexels-photo-7161073.jpeg?auto=compress&cs=tinysrgb&w=800', 1, '2026-06-18 05:51:19', '2026-06-18 05:51:19'),
(7, 'Cartera Tejida Pequeña', 'Cartera pequeña de mano con acabados artesanales detallados.', 60000.00, 130000.00, 5, 5, 'https://images.pexels.com/photos/6011382/pexels-photo-6011382.jpeg?auto=compress&cs=tinysrgb&w=800', 1, '2026-06-18 05:51:19', '2026-06-18 05:51:19'),
(8, 'Bolso Tote Playero', 'Bolso grande tejido de estructura firme, perfecto para días de descanso.', 50000.00, 110000.00, 10, 5, 'https://images.pexels.com/photos/5412217/pexels-photo-5412217.jpeg?auto=compress&cs=tinysrgb&w=800', 1, '2026-06-18 05:51:19', '2026-06-18 05:51:19'),
(9, 'Cartera de Hombro Vintage', 'Estilo clásico con tejido artesanal que combina con cualquier outfit.', 35000.00, 75000.00, 11, 5, 'https://images.pexels.com/photos/8454344/pexels-photo-8454344.jpeg?auto=compress&cs=tinysrgb&w=800', 1, '2026-06-18 05:51:19', '2026-06-18 05:51:19'),
(10, 'Bolso Artesanal Grande', 'Bolso espacioso tipo cesta, tejido a mano, ideal para el uso diario.', 52000.00, 115000.00, 9, 5, 'https://images.pexels.com/photos/3682240/pexels-photo-3682240.jpeg?auto=compress&cs=tinysrgb&w=800', 1, '2026-06-18 05:51:19', '2026-06-18 05:51:19');

INSERT INTO carritos (id, usuario_id, actualizado_el) VALUES
(1, 2, '2026-06-18 05:39:12');

SET FOREIGN_KEY_CHECKS = 1;