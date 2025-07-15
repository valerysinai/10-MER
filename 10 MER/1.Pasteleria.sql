IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'pasteleria_db')
BEGIN
    CREATE DATABASE pasteleria;
END;
GO

USE pasteleria;
GO

CREATE TABLE CategoriaProducto (
    id_categoria INT PRIMARY KEY IDENTITY(1,1),
    nombre_categoria VARCHAR(100) NOT NULL UNIQUE,
    descripcion_categoria TEXT
);

CREATE TABLE Ingrediente (
    id_ingrediente INT PRIMARY KEY IDENTITY(1,1),
    nombre_ingrediente VARCHAR(100) NOT NULL UNIQUE,
    unidad_medida VARCHAR(50),
    stock_actual DECIMAL(10, 2) DEFAULT 0.00
);

CREATE TABLE Producto (
    id_producto INT PRIMARY KEY IDENTITY(1,1),
    nombre_producto VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio_venta DECIMAL(10, 2) NOT NULL,
    tiempo_preparacion_minutos INT,
    stock_disponible INT DEFAULT 0,
    id_categoria INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES CategoriaProducto(id_categoria)
);

CREATE TABLE Receta (
    id_receta INT PRIMARY KEY IDENTITY(1,1),
    id_producto INT NOT NULL,
    id_ingrediente INT NOT NULL,
    cantidad_necesaria DECIMAL(10, 2) NOT NULL,
    CONSTRAINT UQ_Receta UNIQUE (id_producto, id_ingrediente),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
    FOREIGN KEY (id_ingrediente) REFERENCES Ingrediente(id_ingrediente)
);

CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY IDENTITY(1,1),
    nombre_cliente VARCHAR(100) NOT NULL,
    apellido_cliente VARCHAR(100) NOT NULL,
    telefono_cliente VARCHAR(20),
    email_cliente VARCHAR(150) UNIQUE,
    direccion_cliente VARCHAR(255)
);

CREATE TABLE Empleado (
    id_empleado INT PRIMARY KEY IDENTITY(1,1),
    nombre_empleado VARCHAR(100) NOT NULL,
    apellido_empleado VARCHAR(100) NOT NULL,
    cargo VARCHAR(50),
    fecha_contratacion DATE,
    salario DECIMAL(10, 2)
);

CREATE TABLE Pedido (
    id_pedido INT PRIMARY KEY IDENTITY(1,1),
    fecha_pedido DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    fecha_entrega_estimada DATETIME2,
    total_pedido DECIMAL(10, 2) DEFAULT 0.00,
    estado_pedido VARCHAR(50) NOT NULL DEFAULT 'Pendiente',
    tipo_pago VARCHAR(50),
    id_cliente INT NULL,
    id_empleado_recibe INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_empleado_recibe) REFERENCES Empleado(id_empleado)
);

CREATE TABLE DetallePedido (
    id_detalle_pedido INT PRIMARY KEY IDENTITY(1,1),
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario_venta DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    notas_personalizacion TEXT,
    CONSTRAINT UQ_DetallePedido UNIQUE (id_pedido, id_producto),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

INSERT INTO CategoriaProducto (nombre_categoria, descripcion_categoria) VALUES
('Pasteles', 'Pasteles de cumpleaños, aniversario y especiales.'),
('Galletas', 'Variedad de galletas horneadas diariamente.'),
('Panes', 'Panes artesanales y de molde.'),
('Postres Individuales', 'Porciones individuales de postres.');

INSERT INTO Ingrediente (nombre_ingrediente, unidad_medida, stock_actual) VALUES
('Harina de Trigo', 'gramos', 50000),
('Azúcar', 'gramos', 30000),
('Huevos', 'unidades', 500),
('Mantequilla', 'gramos', 10000),
('Chocolate', 'gramos', 15000),
('Leche', 'mililitros', 20000),
('Levadura', 'gramos', 1000),
('Frutas Frescas', 'gramos', 5000);

INSERT INTO Producto (nombre_producto, descripcion, precio_venta, tiempo_preparacion_minutos, stock_disponible, id_categoria) VALUES
('Tarta de Chocolate Fudge', 'Deliciosa tarta con capas de chocolate oscuro y fudge.', 45.00, 120, 10, 1),
('Galletas de Chispas de Chocolate', 'Galletas suaves con muchas chispas de chocolate.', 2.50, 20, 100, 2),
('Pan Integral Artesanal', 'Pan de masa madre, 100% integral.', 7.00, 180, 15, 3),
('Cheesecake Individual', 'Porción individual de cremoso cheesecake de frutos rojos.', 6.00, 90, 25, 4);

INSERT INTO Receta (id_producto, id_ingrediente, cantidad_necesaria) VALUES
(1, 1, 300),
(1, 2, 400),
(1, 3, 4),
(1, 4, 200),
(1, 5, 500),
(2, 1, 150),
(2, 2, 100),
(2, 3, 1),
(2, 4, 50),
(2, 5, 150);

INSERT INTO Cliente (nombre_cliente, apellido_cliente, telefono_cliente, email_cliente, direccion_cliente) VALUES
('Ana', 'García', '3101112233', 'ana.garcia@email.com', 'Calle 10 # 5-10, Centro'),
('Luis', 'Pérez', '3114445566', 'luis.perez@email.com', 'Avenida Siempre Viva 123');

INSERT INTO Empleado (nombre_empleado, apellido_empleado, cargo, fecha_contratacion, salario) VALUES
('Sofía', 'Rodríguez', 'Cajero', '2023-01-15', 1200000.00),
('Pedro', 'Martínez', 'Panadero', '2022-05-01', 1500000.00);

INSERT INTO Pedido (id_cliente, id_empleado_recibe, fecha_entrega_estimada, estado_pedido, tipo_pago) VALUES
(1, 1, '2025-07-15 14:00:00', 'Pendiente', 'Tarjeta'),
(2, 1, '2025-07-16 10:00:00', 'En preparación', 'Efectivo'),
(NULL, 1, '2025-07-14 18:00:00', 'Listo', 'Efectivo');

INSERT INTO DetallePedido (id_pedido, id_producto, cantidad, precio_unitario_venta, subtotal) VALUES
(1, 1, 1, 45.00, 45.00),
(1, 2, 10, 2.50, 25.00),
(2, 3, 2, 7.00, 14.00),
(2, 2, 5, 2.50, 12.50),
(3, 4, 3, 6.00, 18.00);

UPDATE Pedido
SET total_pedido = (
    SELECT SUM(subtotal) FROM DetallePedido WHERE DetallePedido.id_pedido = Pedido.id_pedido
)
WHERE id_pedido IN (1, 2, 3);

UPDATE Producto
SET stock_disponible = stock_disponible - (
    SELECT ISNULL(SUM(DP.cantidad), 0) FROM DetallePedido DP WHERE DP.id_producto = Producto.id_producto
);

SELECT
    P.nombre_producto,
    P.precio_venta,
    CP.nombre_categoria
FROM
    Producto P
JOIN
    CategoriaProducto CP ON P.id_categoria = CP.id_categoria;

SELECT
    P.id_pedido,
    P.fecha_pedido,
    C.nombre_cliente,
    C.apellido_cliente,
    E.nombre_empleado AS empleado_atiende,
    Prod.nombre_producto,
    DP.cantidad,
    DP.precio_unitario_venta,
    DP.subtotal,
    P.total_pedido AS total_pedido_final
FROM
    Pedido P
LEFT JOIN
    Cliente C ON P.id_cliente = C.id_cliente
JOIN
    Empleado E ON P.id_empleado_recibe = E.id_empleado
JOIN
    DetallePedido DP ON P.id_pedido = DP.id_pedido
JOIN
    Producto Prod ON DP.id_producto = Prod.id_producto
WHERE
    P.id_pedido = 1;

SELECT
    I.nombre_ingrediente,
    R.cantidad_necesaria,
    P.nombre_producto
FROM
    Ingrediente I
JOIN
    Receta R ON I.id_ingrediente = R.id_ingrediente
JOIN
    Producto P ON R.id_producto = P.id_producto
ORDER BY
    I.nombre_ingrediente, P.nombre_producto;

SELECT
    CP.nombre_categoria,
    COUNT(P.id_producto) AS numero_productos
FROM
    CategoriaProducto CP
LEFT JOIN
    Producto P ON CP.id_categoria = P.id_categoria
GROUP BY
    CP.nombre_categoria
ORDER BY
    numero_productos DESC;

SELECT DISTINCT
    C.nombre_cliente,
    C.apellido_cliente,
    C.email_cliente
FROM
    Cliente C
JOIN
    Pedido P ON C.id_cliente = P.id_cliente;
