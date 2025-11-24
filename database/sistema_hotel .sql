-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 24-11-2025 a las 05:00:50
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
-- Base de datos: `sistema_hotel`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos_restaurante`
--

CREATE TABLE `productos_restaurante` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `categoria` varchar(50) DEFAULT NULL,
  `disponible` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyecto_categoria`
--

CREATE TABLE `proyecto_categoria` (
  `cod_categoria` int(11) NOT NULL,
  `detalle` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `proyecto_categoria`
--

INSERT INTO `proyecto_categoria` (`cod_categoria`, `detalle`) VALUES
(1, 'Bebidas'),
(2, 'Comidas'),
(3, 'Snacks'),
(4, 'Postres'),
(5, 'Otros');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyecto_checkin`
--

CREATE TABLE `proyecto_checkin` (
  `id_checkin` int(11) NOT NULL,
  `fecha_ingreso_chekin` datetime NOT NULL,
  `fecha_salida_cheking` datetime DEFAULT NULL,
  `noches` int(11) NOT NULL,
  `habitacion` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `transporte` varchar(100) DEFAULT NULL,
  `motivo_viaje` varchar(100) DEFAULT NULL,
  `procedencia` varchar(100) DEFAULT NULL,
  `acompanantes` int(11) DEFAULT 0,
  `estado` enum('Activo','Finalizado') DEFAULT 'Activo',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyecto_clientes`
--

CREATE TABLE `proyecto_clientes` (
  `id` int(11) NOT NULL,
  `nombre` text NOT NULL,
  `apellido` text NOT NULL,
  `documento` int(11) NOT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyecto_habitaciones`
--

CREATE TABLE `proyecto_habitaciones` (
  `id` int(11) NOT NULL,
  `id_habitacion` varchar(50) NOT NULL,
  `estado` varchar(100) DEFAULT 'Disponible',
  `id_cliente` int(11) DEFAULT NULL,
  `tipo_habitacion` varchar(50) NOT NULL,
  `precio_noche` decimal(10,2) NOT NULL,
  `capacidad` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyecto_productos`
--

CREATE TABLE `proyecto_productos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `codigo` varchar(255) NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `precioVenta` decimal(10,2) NOT NULL,
  `precioCompra` decimal(10,2) NOT NULL,
  `iva` int(11) DEFAULT 0,
  `existencia` int(11) DEFAULT 0,
  `id_usuario` bigint(20) UNSIGNED DEFAULT NULL,
  `cod_categoria` int(11) NOT NULL,
  `vencimiento` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyecto_productos_vendidos`
--

CREATE TABLE `proyecto_productos_vendidos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_producto` bigint(20) UNSIGNED NOT NULL,
  `cantidad` bigint(20) UNSIGNED NOT NULL,
  `id_venta` bigint(20) UNSIGNED NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyecto_reservas`
--

CREATE TABLE `proyecto_reservas` (
  `id` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `habitacion` int(11) NOT NULL,
  `fecha_entrada` date NOT NULL,
  `fecha_salida` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `tipo_reserva` enum('Airbnb','Otro') DEFAULT 'Otro',
  `estado` enum('Pendiente','Confirmada','Cancelada','Finalizada') DEFAULT 'Pendiente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyecto_usuarios`
--

CREATE TABLE `proyecto_usuarios` (
  `id` int(11) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `rol` enum('Administrador','Recepcionista','Cajero') DEFAULT 'Recepcionista',
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `proyecto_usuarios`
--

INSERT INTO `proyecto_usuarios` (`id`, `usuario`, `password`, `nombre`, `rol`, `activo`, `created_at`) VALUES
(1, 'admin', 'admin123', 'admin', 'Administrador', 1, '2025-11-17 23:10:10');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyecto_ventas`
--

CREATE TABLE `proyecto_ventas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `total` decimal(10,2) NOT NULL,
  `iva5` decimal(10,2) DEFAULT 0.00,
  `iva19` decimal(10,2) DEFAULT 0.00,
  `exento` decimal(10,2) DEFAULT 0.00,
  `tipo_pago` varchar(100) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_habitacion` int(11) DEFAULT NULL,
  `tipo_venta` enum('Restaurante','Habitacion','General') DEFAULT 'General'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicio_habitacion`
--

CREATE TABLE `servicio_habitacion` (
  `id` int(11) NOT NULL,
  `reserva_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 1,
  `fecha_pedido` timestamp NOT NULL DEFAULT current_timestamp(),
  `total` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `productos_restaurante`
--
ALTER TABLE `productos_restaurante`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `proyecto_categoria`
--
ALTER TABLE `proyecto_categoria`
  ADD PRIMARY KEY (`cod_categoria`);

--
-- Indices de la tabla `proyecto_checkin`
--
ALTER TABLE `proyecto_checkin`
  ADD PRIMARY KEY (`id_checkin`),
  ADD KEY `id_cliente` (`id_cliente`),
  ADD KEY `idx_estado` (`estado`),
  ADD KEY `idx_habitacion` (`habitacion`);

--
-- Indices de la tabla `proyecto_clientes`
--
ALTER TABLE `proyecto_clientes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `documento` (`documento`),
  ADD KEY `idx_documento` (`documento`);

--
-- Indices de la tabla `proyecto_habitaciones`
--
ALTER TABLE `proyecto_habitaciones`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_habitacion` (`id_habitacion`),
  ADD KEY `id_cliente` (`id_cliente`),
  ADD KEY `idx_estado` (`estado`),
  ADD KEY `idx_id_habitacion` (`id_habitacion`);

--
-- Indices de la tabla `proyecto_productos`
--
ALTER TABLE `proyecto_productos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `idx_codigo` (`codigo`),
  ADD KEY `idx_categoria` (`cod_categoria`);

--
-- Indices de la tabla `proyecto_productos_vendidos`
--
ALTER TABLE `proyecto_productos_vendidos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_producto` (`id_producto`),
  ADD KEY `idx_venta` (`id_venta`);

--
-- Indices de la tabla `proyecto_reservas`
--
ALTER TABLE `proyecto_reservas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_cliente` (`id_cliente`),
  ADD KEY `habitacion` (`habitacion`),
  ADD KEY `idx_estado` (`estado`),
  ADD KEY `idx_fechas` (`fecha_entrada`,`fecha_salida`);

--
-- Indices de la tabla `proyecto_usuarios`
--
ALTER TABLE `proyecto_usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `usuario` (`usuario`);

--
-- Indices de la tabla `proyecto_ventas`
--
ALTER TABLE `proyecto_ventas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_habitacion` (`id_habitacion`),
  ADD KEY `idx_fecha` (`fecha`),
  ADD KEY `idx_cliente` (`id_cliente`);

--
-- Indices de la tabla `servicio_habitacion`
--
ALTER TABLE `servicio_habitacion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reserva_id` (`reserva_id`),
  ADD KEY `producto_id` (`producto_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `productos_restaurante`
--
ALTER TABLE `productos_restaurante`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `proyecto_categoria`
--
ALTER TABLE `proyecto_categoria`
  MODIFY `cod_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `proyecto_checkin`
--
ALTER TABLE `proyecto_checkin`
  MODIFY `id_checkin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `proyecto_clientes`
--
ALTER TABLE `proyecto_clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `proyecto_habitaciones`
--
ALTER TABLE `proyecto_habitaciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `proyecto_productos`
--
ALTER TABLE `proyecto_productos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `proyecto_productos_vendidos`
--
ALTER TABLE `proyecto_productos_vendidos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `proyecto_reservas`
--
ALTER TABLE `proyecto_reservas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `proyecto_usuarios`
--
ALTER TABLE `proyecto_usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `proyecto_ventas`
--
ALTER TABLE `proyecto_ventas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `servicio_habitacion`
--
ALTER TABLE `servicio_habitacion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `proyecto_checkin`
--
ALTER TABLE `proyecto_checkin`
  ADD CONSTRAINT `proyecto_checkin_ibfk_1` FOREIGN KEY (`habitacion`) REFERENCES `proyecto_habitaciones` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `proyecto_checkin_ibfk_2` FOREIGN KEY (`id_cliente`) REFERENCES `proyecto_clientes` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `proyecto_habitaciones`
--
ALTER TABLE `proyecto_habitaciones`
  ADD CONSTRAINT `proyecto_habitaciones_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `proyecto_clientes` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `proyecto_productos`
--
ALTER TABLE `proyecto_productos`
  ADD CONSTRAINT `proyecto_productos_ibfk_1` FOREIGN KEY (`cod_categoria`) REFERENCES `proyecto_categoria` (`cod_categoria`);

--
-- Filtros para la tabla `proyecto_productos_vendidos`
--
ALTER TABLE `proyecto_productos_vendidos`
  ADD CONSTRAINT `proyecto_productos_vendidos_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `proyecto_productos` (`id`),
  ADD CONSTRAINT `proyecto_productos_vendidos_ibfk_2` FOREIGN KEY (`id_venta`) REFERENCES `proyecto_ventas` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `proyecto_reservas`
--
ALTER TABLE `proyecto_reservas`
  ADD CONSTRAINT `proyecto_reservas_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `proyecto_clientes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `proyecto_reservas_ibfk_2` FOREIGN KEY (`habitacion`) REFERENCES `proyecto_habitaciones` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `proyecto_ventas`
--
ALTER TABLE `proyecto_ventas`
  ADD CONSTRAINT `proyecto_ventas_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `proyecto_clientes` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `proyecto_ventas_ibfk_2` FOREIGN KEY (`id_habitacion`) REFERENCES `proyecto_habitaciones` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `servicio_habitacion`
--
ALTER TABLE `servicio_habitacion`
  ADD CONSTRAINT `servicio_habitacion_ibfk_1` FOREIGN KEY (`reserva_id`) REFERENCES `reservas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `servicio_habitacion_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos_restaurante` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
