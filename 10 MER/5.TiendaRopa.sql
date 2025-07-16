--DDL

CREATE DATABASE TiendaRopa;
GO

USE TiendaRopa;
GO

CREATE TABLE Categoria (
    id_categoria INT PRIMARY KEY IDENTITY,
    nombre_categoria VARCHAR(100) NOT NULL UNIQUE,
    descripcion_categoria TEXT
);

CREATE TABLE Producto (
    id_producto INT PRIMARY KEY IDENTITY,
    nombre_producto VARCHAR(255) NOT NULL,
    descripcion_producto TEXT,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    stock_disponible INT NOT NULL DEFAULT 0,
    url_imagen VARCHAR(255),
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY IDENTITY,
    nombre_cliente VARCHAR(100) NOT NULL,
    apellido_cliente VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    direccion_envio VARCHAR(255) NOT NULL,
    fecha_registro DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Pedido (
    id_pedido INT PRIMARY KEY IDENTITY,
    id_cliente INT NOT NULL,
    fecha_pedido DATETIME NOT NULL DEFAULT GETDATE(),
    estado_pedido VARCHAR(50) NOT NULL DEFAULT 'Pendiente',
    total_pedido DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE VarianteProducto (
    id_variante INT PRIMARY KEY IDENTITY,
    id_producto INT NOT NULL,
    talla VARCHAR(20) NOT NULL,
    color VARCHAR(50) NOT NULL,
    stock_variante INT NOT NULL DEFAULT 0,
    sku_variante VARCHAR(100) UNIQUE,
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
    UNIQUE (id_producto, talla, color)
);

CREATE TABLE DetallePedido (
    id_detalle_pedido INT PRIMARY KEY IDENTITY,
    id_pedido INT NOT NULL,
    id_variante INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario_al_momento DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_variante) REFERENCES VarianteProducto(id_variante),
    UNIQUE (id_pedido, id_variante)
);

CREATE TABLE HistorialStock (
    id_historial INT PRIMARY KEY IDENTITY,
    id_variante INT NOT NULL,
    fecha_cambio DATETIME NOT NULL DEFAULT GETDATE(),
    tipo_cambio VARCHAR(50) NOT NULL,
    cantidad_cambiada INT NOT NULL,
    stock_resultante INT NOT NULL,
    FOREIGN KEY (id_variante) REFERENCES VarianteProducto(id_variante)
);

--DML:

INSERT INTO Categoria (nombre_categoria, descripcion_categoria) VALUES
('Camisetas', 'Prendas superiores para hombre y mujer.'),
('Pantalones', 'Prendas inferiores para hombre y mujer.'),
('Accesorios', 'Complementos como gorras, bufandas, etc.');

INSERT INTO Producto (nombre_producto, descripcion_producto, precio_unitario, stock_disponible, id_categoria) VALUES
('Camiseta Algodón Orgánico', 'Camiseta básica de algodón 100% orgánico.', 25.00, 100, 1),
('Jean Slim Fit', 'Jean moderno con corte ajustado.', 50.00, 70, 2),
('Gorra Clásica', 'Gorra ajustable con logo bordado.', 15.00, 50, 3);

INSERT INTO Cliente (nombre_cliente, apellido_cliente, email, telefono, direccion_envio) VALUES
('Ana', 'Ruiz', 'ana.ruiz@example.com', '3101234567', 'Calle 1 # 10-20, Iquira'),
('Pedro', 'Gómez', 'pedro.gomez@example.com', '3209876543', 'Carrera 5 # 3-15, Iquira');

INSERT INTO VarianteProducto (id_producto, talla, color, stock_variante, sku_variante) VALUES
(1, 'M', 'Blanco', 30, 'CAM-ALG-M-BLA'),
(1, 'L', 'Negro', 20, 'CAM-ALG-L-NEG'),
(2, '32', 'Azul', 25, 'JEAN-SLIM-32-AZU'),
(2, '34', 'Negro', 15, 'JEAN-SLIM-34-NEG'),
(3, 'Única', 'Rojo', 10, 'GOR-CLA-UNI-ROJ');

UPDATE Producto
SET stock_disponible = (
    SELECT SUM(stock_variante) FROM VarianteProducto WHERE VarianteProducto.id_producto = Producto.id_producto
);

INSERT INTO Pedido (id_cliente, fecha_pedido, estado_pedido, total_pedido) VALUES
(1, GETDATE(), 'Pendiente', 0.00),
(2, GETDATE(), 'Pendiente', 0.00);

INSERT INTO DetallePedido (id_pedido, id_variante, cantidad, precio_unitario_al_momento, subtotal) VALUES
(1, 1, 1, 25.00, 25.00),
(1, 3, 1, 50.00, 50.00);

INSERT INTO DetallePedido (id_pedido, id_variante, cantidad, precio_unitario_al_momento, subtotal) VALUES
(2, 5, 2, 15.00, 30.00);

UPDATE Pedido
SET total_pedido = (
    SELECT SUM(subtotal) FROM DetallePedido WHERE DetallePedido.id_pedido = Pedido.id_pedido
);

INSERT INTO HistorialStock (id_variante, tipo_cambio, cantidad_cambiada, stock_resultante) VALUES
(1, 'Salida', 1, 29),
(3, 'Salida', 1, 24),
(5, 'Salida', 2, 8);
