-- Script SQL para Sistema Hotelero
-- Base de datos: sistema_hotel

CREATE DATABASE IF NOT EXISTS sistema_hotel CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sistema_hotel;

-- Tabla de usuarios para login
CREATE TABLE IF NOT EXISTS proyecto_usuarios (
    id INT(11) AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    rol ENUM('Administrador', 'Recepcionista', 'Cajero') DEFAULT 'Recepcionista',
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de clientes
CREATE TABLE IF NOT EXISTS proyecto_clientes (
    id INT(11) AUTO_INCREMENT PRIMARY KEY,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    documento INT(11) NOT NULL UNIQUE,
    correo VARCHAR(100),
    telefono VARCHAR(20),
    direccion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_documento (documento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de categorías de productos
CREATE TABLE IF NOT EXISTS proyecto_categoria (
    cod_categoria INT(11) AUTO_INCREMENT PRIMARY KEY,
    detalle VARCHAR(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de habitaciones
CREATE TABLE IF NOT EXISTS proyecto_habitaciones (
    id INT(11) AUTO_INCREMENT PRIMARY KEY,
    id_habitacion VARCHAR(50) NOT NULL UNIQUE,
    estado VARCHAR(100) DEFAULT 'Disponible',
    id_cliente INT(11) NULL,
    tipo_habitacion VARCHAR(50) NOT NULL,
    precio_noche DECIMAL(10,2) NOT NULL,
    capacidad INT(11) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES proyecto_clientes(id) ON DELETE SET NULL,
    INDEX idx_estado (estado),
    INDEX idx_id_habitacion (id_habitacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de reservas
CREATE TABLE IF NOT EXISTS proyecto_reservas (
    id INT(11) AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT(11) NOT NULL,
    habitacion INT(11) NOT NULL,
    fecha_entrada DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_reserva ENUM('Airbnb', 'Otro') DEFAULT 'Otro',
    estado ENUM('Pendiente', 'Confirmada', 'Cancelada', 'Finalizada') DEFAULT 'Pendiente',
    FOREIGN KEY (id_cliente) REFERENCES proyecto_clientes(id) ON DELETE CASCADE,
    FOREIGN KEY (habitacion) REFERENCES proyecto_habitaciones(id) ON DELETE CASCADE,
    INDEX idx_estado (estado),
    INDEX idx_fechas (fecha_entrada, fecha_salida)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de check-in
CREATE TABLE IF NOT EXISTS proyecto_checkin (
    id_checkin INT(11) AUTO_INCREMENT PRIMARY KEY,
    fecha_ingreso_chekin DATETIME NOT NULL,
    fecha_salida_cheking DATETIME NULL,
    noches INT(11) NOT NULL,
    habitacion INT(11) NOT NULL,
    id_cliente INT(11) NOT NULL,
    transporte VARCHAR(100),
    motivo_viaje VARCHAR(100),
    procedencia VARCHAR(100),
    acompanantes INT(11) DEFAULT 0,
    estado ENUM('Activo', 'Finalizado') DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (habitacion) REFERENCES proyecto_habitaciones(id) ON DELETE CASCADE,
    FOREIGN KEY (id_cliente) REFERENCES proyecto_clientes(id) ON DELETE CASCADE,
    INDEX idx_estado (estado),
    INDEX idx_habitacion (habitacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de productos
CREATE TABLE IF NOT EXISTS proyecto_productos (
    id BIGINT(20) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(255) NOT NULL UNIQUE,
    descripcion VARCHAR(255) NOT NULL,
    precioVenta DECIMAL(10,2) NOT NULL,
    precioCompra DECIMAL(10,2) NOT NULL,
    iva INT(11) DEFAULT 0,
    existencia INT(11) DEFAULT 0,
    id_usuario BIGINT(20) UNSIGNED,
    cod_categoria INT(11) NOT NULL,
    vencimiento DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cod_categoria) REFERENCES proyecto_categoria(cod_categoria) ON DELETE RESTRICT,
    INDEX idx_codigo (codigo),
    INDEX idx_categoria (cod_categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de ventas
CREATE TABLE IF NOT EXISTS proyecto_ventas (
    id BIGINT(20) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    iva5 DECIMAL(10,2) DEFAULT 0,
    iva19 DECIMAL(10,2) DEFAULT 0,
    exento DECIMAL(10,2) DEFAULT 0,
    tipo_pago VARCHAR(100) NOT NULL,
    id_cliente INT(11) NULL,
    id_habitacion INT(11) NULL,
    tipo_venta ENUM('Restaurante', 'Habitacion', 'General') DEFAULT 'General',
    FOREIGN KEY (id_cliente) REFERENCES proyecto_clientes(id) ON DELETE SET NULL,
    FOREIGN KEY (id_habitacion) REFERENCES proyecto_habitaciones(id) ON DELETE SET NULL,
    INDEX idx_fecha (fecha),
    INDEX idx_cliente (id_cliente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de productos vendidos
CREATE TABLE IF NOT EXISTS proyecto_productos_vendidos (
    id BIGINT(20) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_producto BIGINT(20) UNSIGNED NOT NULL,
    cantidad BIGINT(20) UNSIGNED NOT NULL,
    id_venta BIGINT(20) UNSIGNED NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES proyecto_productos(id) ON DELETE RESTRICT,
    FOREIGN KEY (id_venta) REFERENCES proyecto_ventas(id) ON DELETE CASCADE,
    INDEX idx_venta (id_venta)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insertar usuario administrador por defecto (password: admin123)
-- Nota: Si usas BCrypt, descomenta la línea con hash BCrypt y comenta la línea con hash simple
-- INSERT INTO proyecto_usuarios (usuario, password, nombre, rol) VALUES 
-- ('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Administrador', 'Administrador');

-- Versión simple para desarrollo (password: admin123)
INSERT INTO proyecto_usuarios (usuario, password, nombre, rol) VALUES 
('admin', 'admin123', 'Administrador', 'Administrador');

-- Insertar categorías de ejemplo
INSERT INTO proyecto_categoria (detalle) VALUES 
('Bebidas'),
('Comidas'),
('Snacks'),
('Postres'),
('Otros');

-- Insertar habitaciones de ejemplo
INSERT INTO proyecto_habitaciones (id_habitacion, estado, tipo_habitacion, precio_noche, capacidad) VALUES
('101', 'Disponible', 'Individual', 50000.00, 1),
('102', 'Disponible', 'Doble', 80000.00, 2),
('103', 'Disponible', 'Suite', 150000.00, 4),
('201', 'Disponible', 'Doble', 80000.00, 2),
('202', 'Disponible', 'Individual', 50000.00, 1);

