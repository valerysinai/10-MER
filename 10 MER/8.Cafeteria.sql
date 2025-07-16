--DDL

CREATE DATABASE CafeteriaDB;
GO

USE CafeteriaDB;
GO


CREATE TABLE CategoriaProducto (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL UNIQUE,
    descripcion_categoria TEXT
);

CREATE TABLE Producto (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    nombre_producto VARCHAR(255) NOT NULL,
    descripcion_producto TEXT,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    stock_actual INT NOT NULL DEFAULT 0,
    url_imagen VARCHAR(255),
    id_categoria INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES CategoriaProducto(id_categoria)
);

CREATE TABLE Empleado (
    id_empleado INT IDENTITY(1,1) PRIMARY KEY,
    nombre_empleado VARCHAR(100) NOT NULL,
    apellido_empleado VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    salario DECIMAL(10, 2),
    email VARCHAR(150) UNIQUE,
    telefono VARCHAR(20)
);

CREATE TABLE Cliente (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    nombre_cliente VARCHAR(100) NOT NULL,
    apellido_cliente VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    telefono VARCHAR(20),
    puntos_fidelidad INT DEFAULT 0,
    fecha_registro DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Pedido (
    id_pedido INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT,
    id_empleado INT NOT NULL,
    fecha_hora_pedido DATETIME NOT NULL DEFAULT GETDATE(),
    total_pedido DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    estado_pedido VARCHAR(50) NOT NULL DEFAULT 'Pendiente',
    tipo_pago VARCHAR(50),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

CREATE TABLE DetallePedido (
    id_detalle_pedido INT IDENTITY(1,1) PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario_al_momento DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    notas_item TEXT,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
    CONSTRAINT UQ_Pedido_Producto UNIQUE (id_pedido, id_producto)
);

CREATE TABLE Proveedor (
    id_proveedor INT IDENTITY(1,1) PRIMARY KEY,
    nombre_proveedor VARCHAR(255) NOT NULL UNIQUE,
    tipo_suministro VARCHAR(100),
    telefono_contacto VARCHAR(20),
    email_contacto VARCHAR(150),
    direccion_proveedor VARCHAR(255)
);

CREATE TABLE Suministro (
    id_suministro INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    id_proveedor INT NOT NULL,
    fecha_ultimo_pedido DATE,
    costo_unidad_compra DECIMAL(10, 2),
    tiempo_entrega_dias INT,
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
    FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor),
    CONSTRAINT UQ_Producto_Proveedor UNIQUE (id_producto, id_proveedor)
);

-- DML
INSERT INTO CategoriaProducto (nombre_categoria, descripcion_categoria) VALUES
('Bebidas Calientes', 'Cafés, tés y otras bebidas que se sirven calientes.'),
('Bebidas Frías', 'Refrescos, jugos y cafés fríos.'),
('Panadería', 'Panes, croissants, muffins y bollería.'),
('Postres', 'Pasteles, tartas y dulces.');

INSERT INTO Producto (nombre_producto, descripcion_producto, precio_unitario, stock_actual, id_categoria) VALUES
('Espresso Doble', 'Café concentrado de 60ml.', 3.00, 100, 1),
('Latte Vainilla', 'Café con leche y sirope de vainilla.', 4.50, 80, 1),
('Croissant de Mantequilla', 'Croissant francés recién horneado.', 2.50, 50, 3),
('Cheesecake de Fresa', 'Porción de tarta de queso con fresas.', 5.00, 20, 4);

INSERT INTO Empleado (nombre_empleado, apellido_empleado, cargo, fecha_contratacion, salario, email, telefono) VALUES
('Sofía', 'García', 'Barista', '2024-01-15', 1200.00, 'sofia.garcia@cafeteria.com', '3101112233'),
('Pedro', 'López', 'Cajero', '2023-07-01', 1100.00, 'pedro.lopez@cafeteria.com', '3204445566');

INSERT INTO Cliente (nombre_cliente, apellido_cliente, email, telefono, puntos_fidelidad) VALUES
('Ana', 'Martínez', 'ana.martinez@email.com', '3111111111', 150),
('Juan', 'Rodríguez', 'juan.rodriguez@email.com', '3122222222', 200);

INSERT INTO Pedido (id_cliente, id_empleado, fecha_hora_pedido, total_pedido, estado_pedido, tipo_pago) VALUES
(1, 1, '2025-07-13 10:00:00', 0.00, 'Pendiente', 'Tarjeta'),
(2, 2, '2025-07-13 10:15:00', 0.00, 'Pendiente', 'Efectivo'),
(NULL, 1, '2025-07-13 10:20:00', 0.00, 'Pendiente', 'Efectivo');

INSERT INTO DetallePedido (id_pedido, id_producto, cantidad, precio_unitario_al_momento, subtotal) VALUES
(1, 1, 1, 3.00, 3.00),
(1, 3, 1, 2.50, 2.50),
(2, 2, 1, 4.50, 4.50),
(2, 4, 1, 5.00, 5.00),
(3, 1, 2, 3.00, 6.00);

UPDATE Pedido
SET total_pedido = (
    SELECT SUM(DP.subtotal)
    FROM DetallePedido DP
    WHERE DP.id_pedido = Pedido.id_pedido
);

UPDATE Producto
SET stock_actual = stock_actual - ISNULL((
    SELECT SUM(DP.cantidad)
    FROM DetallePedido DP
    WHERE DP.id_producto = Producto.id_producto
), 0);

INSERT INTO Proveedor (nombre_proveedor, tipo_suministro, telefono_contacto, email_contacto, direccion_proveedor) VALUES
('Café de Colombia S.A.', 'Café', '6011234567', 'ventas@cafecolombia.com', 'Calle 100 # 10-20, Bogotá'),
('Panes Frescos Ltda.', 'Panadería', '6017890123', 'info@panesfrescos.com', 'Carrera 50 # 5-10, Bogotá');

INSERT INTO Suministro (id_producto, id_proveedor, fecha_ultimo_pedido, costo_unidad_compra, tiempo_entrega_dias) VALUES
(1, 1, '2025-07-01', 1.50, 3),
(2, 1, '2025-07-01', 2.00, 3),
(3, 2, '2025-07-05', 1.00, 2);
