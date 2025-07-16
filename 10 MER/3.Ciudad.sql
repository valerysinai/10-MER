
--DDL
DROP TABLE IF EXISTS Evento;
DROP TABLE IF EXISTS Infraestructura;
DROP TABLE IF EXISTS ContratoServicio;
DROP TABLE IF EXISTS ServicioPublico;
DROP TABLE IF EXISTS Propiedad;
DROP TABLE IF EXISTS Ciudadano;
DROP TABLE IF EXISTS Ciudad;


CREATE DATABASE Ciudad;
GO

USE Ciudad;
GO

CREATE TABLE Ciudad (
    id_ciudad INT PRIMARY KEY IDENTITY(1,1),
    nombre_ciudad NVARCHAR(100) NOT NULL UNIQUE,
    pais NVARCHAR(100) NOT NULL,
    departamento NVARCHAR(100),
    poblacion_estimada INT,
    alcalde_actual NVARCHAR(100),
    fecha_fundacion DATE
);

CREATE TABLE Ciudadano (
    id_ciudadano INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(50) NOT NULL,
    apellido NVARCHAR(50) NOT NULL,
    fecha_nacimiento DATE,
    genero CHAR(1),
    tipo_documento NVARCHAR(10),
    numero_documento NVARCHAR(20) NOT NULL UNIQUE,
    telefono NVARCHAR(20),
    email NVARCHAR(100) UNIQUE,
    id_ciudad_residencia INT,
    FOREIGN KEY (id_ciudad_residencia) REFERENCES Ciudad(id_ciudad)
);

CREATE TABLE Propiedad (
    id_propiedad INT PRIMARY KEY IDENTITY(1,1),
    direccion NVARCHAR(255) NOT NULL,
    area_m2 DECIMAL(10, 2),
    tipo_uso NVARCHAR(50),
    valor_catastral DECIMAL(15, 2),
    numero_predial NVARCHAR(50) UNIQUE NOT NULL,
    id_ciudad INT NOT NULL,
    FOREIGN KEY (id_ciudad) REFERENCES Ciudad(id_ciudad)
);

CREATE TABLE ServicioPublico (
    id_servicio INT PRIMARY KEY IDENTITY(1,1),
    nombre_servicio NVARCHAR(100) NOT NULL UNIQUE,
    descripcion NVARCHAR(MAX),
    empresa_proveedora NVARCHAR(100),
    costo_base_mensual DECIMAL(10, 2),
    id_ciudad INT NOT NULL,
    FOREIGN KEY (id_ciudad) REFERENCES Ciudad(id_ciudad)
);

CREATE TABLE ContratoServicio (
    id_contrato INT PRIMARY KEY IDENTITY(1,1),
    id_propiedad INT NOT NULL,
    id_servicio INT NOT NULL,
    fecha_inicio_contrato DATE NOT NULL,
    fecha_fin_contrato DATE,
    estado_contrato NVARCHAR(50) NOT NULL,
    FOREIGN KEY (id_propiedad) REFERENCES Propiedad(id_propiedad),
    FOREIGN KEY (id_servicio) REFERENCES ServicioPublico(id_servicio),
    CONSTRAINT UQ_Contrato UNIQUE (id_propiedad, id_servicio, fecha_inicio_contrato)
);

CREATE TABLE Infraestructura (
    id_infraestructura INT PRIMARY KEY IDENTITY(1,1),
    nombre_infraestructura NVARCHAR(150) NOT NULL,
    tipo_infraestructura NVARCHAR(50),
    direccion NVARCHAR(255),
    fecha_construccion DATE,
    capacidad_personas INT,
    id_ciudad INT NOT NULL,
    FOREIGN KEY (id_ciudad) REFERENCES Ciudad(id_ciudad)
);

CREATE TABLE Evento (
    id_evento INT PRIMARY KEY IDENTITY(1,1),
    nombre_evento NVARCHAR(150) NOT NULL,
    descripcion NVARCHAR(MAX),
    fecha_hora_inicio DATETIME NOT NULL,
    fecha_hora_fin DATETIME,
    lugar NVARCHAR(255),
    organizador NVARCHAR(100),
    id_ciudad INT NOT NULL,
    FOREIGN KEY (id_ciudad) REFERENCES Ciudad(id_ciudad)
);

--DML

INSERT INTO Ciudad (nombre_ciudad, pais, departamento, poblacion_estimada, alcalde_actual, fecha_fundacion) VALUES
('Iquira', 'Colombia', 'Huila', 15000, 'Alcalde Iquira', '1800-01-01');

INSERT INTO Ciudadano (nombre, apellido, fecha_nacimiento, genero, tipo_documento, numero_documento, telefono, email, id_ciudad_residencia) VALUES
('Juan', 'Gómez', '1985-05-20', 'M', 'CC', '1001001001', '3101234567', 'juan.gomez@email.com', 1),
('Maria', 'Rodríguez', '1992-11-10', 'F', 'CC', '1002002002', '3209876543', 'maria.r@email.com', 1),
('Carlos', 'Pérez', '1970-03-01', 'M', 'CC', '1003003003', '3001112233', 'carlos.p@email.com', 1);

INSERT INTO Propiedad (direccion, area_m2, tipo_uso, valor_catastral, numero_predial, id_ciudad) VALUES
('Carrera 5 # 10-20', 120.50, 'Residencial', 150000000.00, '001-001', 1),
('Calle 8 # 15-30', 80.00, 'Residencial', 90000000.00, '001-002', 1),
('Avenida Principal # 2-50 Local 1', 200.00, 'Comercial', 300000000.00, '001-003', 1);

INSERT INTO ServicioPublico (nombre_servicio, descripcion, empresa_proveedora, costo_base_mensual, id_ciudad) VALUES
('Acueducto', 'Suministro de agua potable.', 'Empresa de Aguas Iquira', 25000.00, 1),
('Energía', 'Suministro de energía eléctrica.', 'ElectroHuila', 40000.00, 1),
('Aseo', 'Recolección de residuos sólidos.', 'Empresa de Aseo Iquira', 15000.00, 1);

INSERT INTO ContratoServicio (id_propiedad, id_servicio, fecha_inicio_contrato, estado_contrato) VALUES
(1, 1, '2023-01-01', 'Activo'),
(1, 2, '2023-01-01', 'Activo'),
(2, 1, '2023-02-15', 'Activo'),
(3, 2, '2024-03-10', 'Activo'),
(3, 3, '2024-03-10', 'Activo');

INSERT INTO Infraestructura (nombre_infraestructura, tipo_infraestructura, direccion, fecha_construccion, capacidad_personas, id_ciudad) VALUES
('Parque Central', 'Parque', 'Frente a la Alcaldía', '1950-01-01', 500, 1),
('Hospital San Vicente', 'Hospital', 'Carrera 7 # 3-45', '1980-06-20', NULL, 1),
('Colegio La Candelaria', 'Escuela', 'Calle 12 # 8-10', '1965-09-01', 800, 1);

INSERT INTO Evento (nombre_evento, descripcion, fecha_hora_inicio, fecha_hora_fin, lugar, organizador, id_ciudad) VALUES
('Festival Folclórico Iquireño', 'Celebración anual de la cultura local con música y danza.', '2025-08-10 18:00:00', '2025-08-15 23:00:00', 'Parque Central', 'Alcaldía de Iquira', 1),
('Maratón Iquira 10K', 'Carrera atlética por las calles principales.', '2025-09-20 07:00:00', '2025-09-20 11:00:00', 'Principales Vías de la Ciudad', 'Club Deportivo Iquira', 1),
('Concierto de Verano', 'Evento musical con artistas locales.', '2025-07-25 20:00:00', '2025-07-25 23:00:00', 'Parque Central', 'Casa de la Cultura', 1);

SELECT numero_documento, email FROM Ciudadano;

SELECT P.direccion, P.tipo_uso, C.nombre_ciudad AS ciudad_perteneciente
FROM Propiedad P
JOIN Ciudad C ON P.id_ciudad = C.id_ciudad;

SELECT tipo_uso, COUNT(id_propiedad) AS total_propiedades
FROM Propiedad
GROUP BY tipo_uso
ORDER BY total_propiedades DESC;

SELECT nombre_ciudad, poblacion_estimada
FROM Ciudad
GROUP BY id_ciudad, nombre_ciudad, poblacion_estimada
HAVING poblacion_estimada > 10000;

SELECT TOP 2 nombre_infraestructura, tipo_infraestructura, fecha_construccion
FROM Infraestructura
ORDER BY fecha_construccion ASC;

SELECT AVG(valor_catastral) AS valor_catastral_promedio_residencial
FROM Propiedad
WHERE tipo_uso = 'Residencial';

SELECT DISTINCT tipo_uso FROM Propiedad;

SELECT nombre, apellido, numero_documento
FROM Ciudadano
WHERE id_ciudad_residencia IN (
    SELECT id_ciudad
    FROM Ciudad
    WHERE poblacion_estimada > 12000
);

INSERT INTO ServicioPublico (nombre_servicio, descripcion, empresa_proveedora, costo_base_mensual, id_ciudad) VALUES
('Alumbrado Público', 'Mantenimiento y gestión del alumbrado en vías públicas.', 'Electricaribe', 10000.00, 1);

UPDATE Ciudad
SET alcalde_actual = 'Nuevo Alcalde Iquira'
WHERE nombre_ciudad = 'Iquira';

UPDATE Propiedad
SET valor_catastral = 160000000.00
WHERE numero_predial = '001-001';

DELETE FROM Evento
WHERE nombre_evento = 'Concierto de Verano' AND id_ciudad = 1;
