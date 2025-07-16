--DDL
CREATE DATABASE Automoviles;
GO

USE Automoviles;
GO

CREATE TABLE Sucursal (
    id_sucursal INT IDENTITY(1,1) PRIMARY KEY,
    nombre_sucursal VARCHAR(100) NOT NULL UNIQUE,
    direccion VARCHAR(255),
    ciudad VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(150) UNIQUE
);

CREATE TABLE Empleado (
    id_empleado INT IDENTITY(1,1) PRIMARY KEY,
    nombre_empleado VARCHAR(100) NOT NULL,
    apellido_empleado VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    salario DECIMAL(10, 2),
    email VARCHAR(150) UNIQUE,
    telefono VARCHAR(20),
    id_sucursal INT NOT NULL,
    FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
);

CREATE TABLE Marca (
    id_marca INT IDENTITY(1,1) PRIMARY KEY,
    nombre_marca VARCHAR(100) NOT NULL UNIQUE,
    pais_origen VARCHAR(100),
    fundacion_anio INT
);

CREATE TABLE Vehiculo (
    id_vehiculo INT IDENTITY(1,1) PRIMARY KEY,
    vin VARCHAR(17) NOT NULL UNIQUE,
    modelo VARCHAR(100) NOT NULL,
    anio_fabricacion INT,
    color VARCHAR(50),
    tipo_combustible VARCHAR(50),
    kilometraje INT,
    precio_venta DECIMAL(12, 2) NOT NULL,
    estado_vehiculo VARCHAR(50) NOT NULL DEFAULT 'Nuevo',
    id_marca INT NOT NULL,
    id_sucursal INT NOT NULL,
    FOREIGN KEY (id_marca) REFERENCES Marca(id_marca),
    FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
);

CREATE TABLE Cliente (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    nombre_cliente VARCHAR(100) NOT NULL,
    apellido_cliente VARCHAR(100) NOT NULL,
    dni VARCHAR(20) UNIQUE,
    telefono VARCHAR(20),
    email VARCHAR(150) UNIQUE,
    direccion VARCHAR(255)
);

CREATE TABLE Venta (
    id_venta INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_vehiculo INT NOT NULL UNIQUE,
    id_empleado_vendedor INT NOT NULL,
    fecha_venta DATETIME NOT NULL DEFAULT GETDATE(),
    precio_final_venta DECIMAL(12, 2) NOT NULL,
    metodo_pago VARCHAR(50),
    garantia_anios INT,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_vehiculo) REFERENCES Vehiculo(id_vehiculo),
    FOREIGN KEY (id_empleado_vendedor) REFERENCES Empleado(id_empleado)
);

CREATE TABLE Servicio (
    id_servicio INT IDENTITY(1,1) PRIMARY KEY,
    nombre_servicio VARCHAR(100) NOT NULL UNIQUE,
    costo_estimado DECIMAL(10, 2),
    descripcion_servicio TEXT
);

CREATE TABLE VehiculoServicio (
    id_vehiculo_servicio INT IDENTITY(1,1) PRIMARY KEY,
    id_vehiculo INT NOT NULL,
    id_servicio INT NOT NULL,
    fecha_servicio DATETIME NOT NULL DEFAULT GETDATE(),
    kilometraje_servicio INT,
    costo_real_servicio DECIMAL(10, 2),
    notas_servicio TEXT,
    id_empleado_mecanico INT,
    FOREIGN KEY (id_vehiculo) REFERENCES Vehiculo(id_vehiculo),
    FOREIGN KEY (id_servicio) REFERENCES Servicio(id_servicio),
    FOREIGN KEY (id_empleado_mecanico) REFERENCES Empleado(id_empleado),
    CONSTRAINT UQ_Vehiculo_Servicio_Fecha UNIQUE (id_vehiculo, id_servicio, fecha_servicio)
);

--DML

INSERT INTO Sucursal (nombre_sucursal, direccion, ciudad, telefono, email) VALUES
('Autos Huila Centro', 'Carrera 5 # 10-20', 'Neiva', '6088712345', 'info.centro@autoshuila.com'),
('Autos Huila Norte', 'Avenida Pastrana # 15-30', 'Neiva', '6088726789', 'info.norte@autoshuila.com');

INSERT INTO Empleado (nombre_empleado, apellido_empleado, cargo, fecha_contratacion, salario, email, telefono, id_sucursal) VALUES
('Carlos', 'Ramírez', 'Gerente de Ventas', '2020-01-01', 3500000.00, 'carlos.ramirez@autoshuila.com', '3101234567', 1),
('Laura', 'Gómez', 'Vendedor', '2021-03-10', 1800000.00, 'laura.gomez@autoshuila.com', '3119876543', 1),
('Andrés', 'Díaz', 'Mecánico', '2019-06-01', 2200000.00, 'andres.diaz@autoshuila.com', '3123456789', 1);

INSERT INTO Marca (nombre_marca, pais_origen, fundacion_anio) VALUES
('Toyota', 'Japón', 1937),
('Ford', 'Estados Unidos', 1903),
('Renault', 'Francia', 1899);

INSERT INTO Vehiculo (vin, modelo, anio_fabricacion, color, tipo_combustible, kilometraje, precio_venta, estado_vehiculo, id_marca, id_sucursal) VALUES
('VIN1234567890ABCD1', 'Corolla Cross', 2024, 'Blanco Perla', 'Híbrido', 100, 110000000.00, 'Nuevo', 1, 1),
('VIN234567890ABCDE2', 'Ranger', 2023, 'Negro', 'Diésel', 5000, 150000000.00, 'Usado', 2, 1),
('VIN34567890ABCDEF3', 'Sandero Stepway', 2024, 'Gris Plata', 'Gasolina', 50, 75000000.00, 'Nuevo', 3, 2);

INSERT INTO Cliente (nombre_cliente, apellido_cliente, dni, telefono, email, direccion) VALUES
('Sofía', 'López', '123456789', '3151112233', 'sofia.lopez@email.com', 'Calle 1 # 1-10, Neiva'),
('Juan', 'Martínez', '987654321', '3164445566', 'juan.martinez@email.com', 'Carrera 20 # 5-50, Neiva');

INSERT INTO Venta (id_cliente, id_vehiculo, id_empleado_vendedor, fecha_venta, precio_final_venta, metodo_pago, garantia_anios) VALUES
(1, 1, 2, '2025-07-14 10:00:00', 108000000.00, 'Financiación', 5);

INSERT INTO Servicio (nombre_servicio, costo_estimado, descripcion_servicio) VALUES
('Cambio de Aceite', 250000.00, 'Reemplazo de aceite y filtro.'),
('Revisión 5.000 KM', 500000.00, 'Chequeo general del vehículo y puntos de seguridad.');

INSERT INTO VehiculoServicio (id_vehiculo, id_servicio, fecha_servicio, kilometraje_servicio, costo_real_servicio, notas_servicio, id_empleado_mecanico) VALUES
(2, 1, '2025-06-20 09:30:00', 4800, 240000.00, 'Aceite sintético utilizado.', 3),
(1, 2, '2025-07-01 14:00:00', 80, 480000.00, 'Primera revisión, todo ok.', 3);
