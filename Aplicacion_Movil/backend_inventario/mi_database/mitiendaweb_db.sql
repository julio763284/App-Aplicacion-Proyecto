-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 21-06-2026 a las 19:49:34
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `mitiendaweb_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carrito`
--

CREATE TABLE `carrito` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carritos`
--

CREATE TABLE `carritos` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `actualizado_el` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carrito_detalles`
--

CREATE TABLE `carrito_detalles` (
  `id` int(11) NOT NULL,
  `carrito_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 1,
  `agregado_el` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `direcciones`
--

CREATE TABLE `direcciones` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `departamento` varchar(100) NOT NULL,
  `barrio` varchar(100) DEFAULT NULL,
  `numero_casa` varchar(50) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `direcciones_usuario`
--

CREATE TABLE `direcciones_usuario` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `departamento` varchar(100) NOT NULL,
  `ciudad` varchar(100) NOT NULL,
  `direccion_detallada` varchar(255) NOT NULL,
  `telefono_contacto` varchar(20) DEFAULT NULL,
  `es_principal` tinyint(1) NOT NULL DEFAULT 0,
  `barrio` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `favoritos`
--

CREATE TABLE `favoritos` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `agregado_el` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

CREATE TABLE `notificaciones` (
  `id` int(11) NOT NULL,
  `mensaje` text NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `referencia` varchar(100) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `estado` enum('PENDIENTE','PAGADO','EMPACANDO','EN_TRANSITO','ENTREGADO') NOT NULL DEFAULT 'PENDIENTE',
  `direccion_envio` varchar(255) NOT NULL,
  `ciudad_envio` varchar(100) NOT NULL,
  `telefono_contacto` varchar(20) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido_detalles`
--

CREATE TABLE `pedido_detalles` (
  `id` int(11) NOT NULL,
  `pedido_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 1,
  `precio_unitario` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio_compra` decimal(10,2) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `stock_minimo` int(11) NOT NULL DEFAULT 0,
  `imagen_url` longtext DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1,
  `creado_el` timestamp NOT NULL DEFAULT current_timestamp(),
  `actualizado_el` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `nombre`, `descripcion`, `precio_compra`, `precio_venta`, `stock`, `stock_minimo`, `imagen_url`, `estado`, `creado_el`, `actualizado_el`) VALUES
(1, 'Bolso', 'Bolso hecho a man', 20000.00, 120000.00, 0, 0, '', 1, '2026-06-20 23:32:00', '2026-06-20 23:32:00'),
(2, 'Bolso tejido', 'Bolso a mano', 20000.00, 120000.00, 0, 0, '/9j/4AAQSkZJRgABAQAAAQABAAD/4gHYSUNDX1BST0ZJTEUAAQEAAAHIAAAAAAQwAABtbnRyUkdCIFhZWiAH4AABAAEAAAAAAABhY3NwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAA9tYAAQAAAADTLQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlkZXNjAAAA8AAAACRyWFlaAAABFAA', 1, '2026-06-20 23:39:27', '2026-06-20 23:39:27'),
(3, 'Cap', 'Capita', 20000.00, 300000.00, 0, 0, 'iVBORw0KGgoAAAANSUhEUgAAAyAAAADNCAYAAABAQhSpAAAQAElEQVR4AeydBYAVVReAvzuvthPYZYEFFpbuRpAwAbEVFNvf7u7u7hYTFQsVUBFQMAgB6e6GZbv35cx/5y0gSKogC5xh7ps7N84995sz750z9+3DmLsmaM1fF7QWShIGYgOHlw2sD1pLs0JWVmHICgZNyzQlmeahz0BfaMvnN611eSFryUb93q/tQN7/NQd5/zu83v/kesv1Fhs', 1, '2026-06-20 23:45:16', '2026-06-20 23:45:16'),
(4, 'x', 'xd', 120000.00, 230000.00, 0, 0, '/9j/4AAQSkZJRgABAQAAAQABAAD/4gHYSUNDX1BST0ZJTEUAAQEAAAHIAAAAAAQwAABtbnRyUkdCIFhZWiAH4AABAAEAAAAAAABhY3NwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAA9tYAAQAAAADTLQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlkZXNjAAAA8AAAACRyWFlaAAABFAA', 1, '2026-06-20 23:54:38', '2026-06-20 23:54:38'),
(5, 'jorge', 'jd', 20000.00, 30000.00, 0, 0, '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', 1, '2026-06-21 17:39:17', '2026-06-21 17:39:17');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reseñas`
--

CREATE TABLE `reseñas` (
  `id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `calificacion` int(11) NOT NULL,
  `comentario` text DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `soporte`
--

CREATE TABLE `soporte` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `asunto` varchar(150) DEFAULT NULL,
  `mensaje` text NOT NULL,
  `estado` enum('PENDIENTE','EN_PROCESO','RESUELTO') NOT NULL DEFAULT 'PENDIENTE',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `correo` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `rol` enum('admin','cliente') NOT NULL DEFAULT 'cliente',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_el` timestamp NOT NULL DEFAULT current_timestamp(),
  `codigo_recuperacion` varchar(6) DEFAULT NULL,
  `codigo_expira` datetime DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `foto_perfil` varchar(255) DEFAULT 'default.png',
  `foto_perfil_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `correo`, `password_hash`, `rol`, `activo`, `creado_el`, `codigo_recuperacion`, `codigo_expira`, `telefono`, `direccion`, `ciudad`, `foto_perfil`, `foto_perfil_url`) VALUES
(1, 'Joiner', 'joiner@gmail.com', '$2b$12$PPHHoNOxNyZkRwgf0OqDs.i/feGcxbLyvFEVlv8Rl9UcHuRNb6zeW', 'cliente', 1, '2026-06-20 23:37:02', NULL, NULL, NULL, NULL, NULL, 'default.png', NULL);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `carrito`
--
ALTER TABLE `carrito`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_carrito_usuario` (`usuario_id`),
  ADD KEY `fk_carrito_producto` (`producto_id`);

--
-- Indices de la tabla `carritos`
--
ALTER TABLE `carritos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_carritos_usuario` (`usuario_id`);

--
-- Indices de la tabla `carrito_detalles`
--
ALTER TABLE `carrito_detalles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_detalles_carrito` (`carrito_id`),
  ADD KEY `fk_detalles_producto` (`producto_id`);

--
-- Indices de la tabla `direcciones`
--
ALTER TABLE `direcciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_direcciones_usuario` (`usuario_id`);

--
-- Indices de la tabla `direcciones_usuario`
--
ALTER TABLE `direcciones_usuario`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_dir_usuario_id` (`usuario_id`);

--
-- Indices de la tabla `favoritos`
--
ALTER TABLE `favoritos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_favoritos_usuario` (`usuario_id`),
  ADD KEY `fk_favoritos_producto` (`producto_id`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_pedidos_usuario` (`usuario_id`);

--
-- Indices de la tabla `pedido_detalles`
--
ALTER TABLE `pedido_detalles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_detalles_pedido` (`pedido_id`),
  ADD KEY `fk_detalles_ped_producto` (`producto_id`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `reseñas`
--
ALTER TABLE `reseñas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_reseñas_producto` (`producto_id`),
  ADD KEY `fk_reseñas_usuario` (`usuario_id`);

--
-- Indices de la tabla `soporte`
--
ALTER TABLE `soporte`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_soporte_usuario` (`usuario_id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `correo_unique` (`correo`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `carrito`
--
ALTER TABLE `carrito`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `carritos`
--
ALTER TABLE `carritos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `carrito_detalles`
--
ALTER TABLE `carrito_detalles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `direcciones`
--
ALTER TABLE `direcciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `direcciones_usuario`
--
ALTER TABLE `direcciones_usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `favoritos`
--
ALTER TABLE `favoritos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pedido_detalles`
--
ALTER TABLE `pedido_detalles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `reseñas`
--
ALTER TABLE `reseñas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `soporte`
--
ALTER TABLE `soporte`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `carrito`
--
ALTER TABLE `carrito`
  ADD CONSTRAINT `fk_carrito_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_carrito_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `carritos`
--
ALTER TABLE `carritos`
  ADD CONSTRAINT `fk_carritos_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `carrito_detalles`
--
ALTER TABLE `carrito_detalles`
  ADD CONSTRAINT `fk_detalles_carrito` FOREIGN KEY (`carrito_id`) REFERENCES `carritos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_detalles_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `direcciones`
--
ALTER TABLE `direcciones`
  ADD CONSTRAINT `fk_direcciones_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `direcciones_usuario`
--
ALTER TABLE `direcciones_usuario`
  ADD CONSTRAINT `fk_dir_usuario_id` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `favoritos`
--
ALTER TABLE `favoritos`
  ADD CONSTRAINT `fk_favoritos_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_favoritos_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `fk_pedidos_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `pedido_detalles`
--
ALTER TABLE `pedido_detalles`
  ADD CONSTRAINT `fk_detalles_ped_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_detalles_pedido` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `reseñas`
--
ALTER TABLE `reseñas`
  ADD CONSTRAINT `fk_reseñas_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_reseñas_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `soporte`
--
ALTER TABLE `soporte`
  ADD CONSTRAINT `fk_soporte_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
