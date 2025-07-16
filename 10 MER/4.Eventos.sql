-- DDL

DROP TABLE IF EXISTS Ticket;
DROP TABLE IF EXISTS ParticipacionArtista;
DROP TABLE IF EXISTS Usuario;
DROP TABLE IF EXISTS Artista;
DROP TABLE IF EXISTS Evento;
DROP TABLE IF EXISTS TipoEntrada;
DROP TABLE IF EXISTS Lugar;

CREATE DATABASE Eventos;
GO

USE Eventos;
GO

CREATE TABLE Lugar (
    id_lugar INT PRIMARY KEY IDENTITY,
    nombre_lugar VARCHAR(150) NOT NULL UNIQUE,
    direccion VARCHAR(255) NOT NULL,
    capacidad_maxima INT NOT NULL,
    tipo_lugar VARCHAR(50),
    telefono_contacto VARCHAR(20),
    email_contacto VARCHAR(100)
);

CREATE TABLE TipoEntrada (
    id_tipo_entrada INT PRIMARY KEY IDENTITY,
    nombre_tipo VARCHAR(50) NOT NULL,
    precio_base DECIMAL(10, 2) NOT NULL,
    descripcion TEXT,
    limite_por_compra INT
);

CREATE TABLE Evento (
    id_evento INT PRIMARY KEY IDENTITY,
    nombre_evento VARCHAR(255) NOT NULL,
    descripcion TEXT,
    fecha_hora_inicio DATETIME NOT NULL,
    fecha_hora_fin DATETIME,
    id_lugar INT NOT NULL,
    estado_evento VARCHAR(50) NOT NULL DEFAULT 'Programado',
    FOREIGN KEY (id_lugar) REFERENCES Lugar(id_lugar)
);

CREATE TABLE Artista (
    id_artista INT PRIMARY KEY IDENTITY,
    nombre_artista VARCHAR(150) NOT NULL,
    genero_musical_o_actuacion VARCHAR(100),
    nacionalidad VARCHAR(50),
    sitio_web VARCHAR(255)
);

CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY IDENTITY,
    nombre_usuario VARCHAR(100) NOT NULL,
    apellido_usuario VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    fecha_registro DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE ParticipacionArtista (
    id_participacion INT PRIMARY KEY IDENTITY,
    id_evento INT NOT NULL,
    id_artista INT NOT NULL,
    rol_en_evento VARCHAR(50),
    hora_actuacion TIME,
    FOREIGN KEY (id_evento) REFERENCES Evento(id_evento),
    FOREIGN KEY (id_artista) REFERENCES Artista(id_artista),
    CONSTRAINT uq_participacion UNIQUE (id_evento, id_artista)
);

CREATE TABLE Ticket (
    id_ticket INT PRIMARY KEY IDENTITY,
    id_usuario INT NOT NULL,
    id_tipo_entrada INT NOT NULL,
    id_evento INT NOT NULL,
    fecha_compra DATETIME NOT NULL DEFAULT GETDATE(),
    precio_pagado DECIMAL(10, 2) NOT NULL,
    estado_ticket VARCHAR(50) NOT NULL DEFAULT 'Válido',
    codigo_qr VARCHAR(255) UNIQUE NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_tipo_entrada) REFERENCES TipoEntrada(id_tipo_entrada),
    FOREIGN KEY (id_evento) REFERENCES Evento(id_evento)
);

--DML

INSERT INTO Lugar (nombre_lugar, direccion, capacidad_maxima, tipo_lugar, telefono_contacto, email_contacto) VALUES
('Coliseo Iquira', 'Carrera 10 # 5-10, Iquira', 5000, 'Estadio', '3101112233', 'contacto@coliseoiquira.com'),
('Teatro Municipal', 'Calle 15 # 3-50, Iquira', 800, 'Teatro', '3204445566', 'info@teatroiquira.com');

INSERT INTO TipoEntrada (nombre_tipo, precio_base, descripcion, limite_por_compra) VALUES
('General', 50000.00, 'Acceso general al evento.', 5),
('VIP', 120000.00, 'Acceso preferencial y zona exclusiva.', 2),
('Platino', 200000.00, 'Acceso exclusivo, bebidas y asientos premium.', 1);

INSERT INTO Evento (nombre_evento, descripcion, fecha_hora_inicio, fecha_hora_fin, id_lugar, estado_evento) VALUES
('Concierto Rock Iquira', 'Festival de rock con bandas nacionales.', '2025-08-20 19:00:00', '2025-08-20 23:00:00', 1, 'Programado'),
('Obra de Teatro Clásica', 'Representación de una obra dramática famosa.', '2025-09-05 20:00:00', '2025-09-05 22:00:00', 2, 'Programado');

INSERT INTO Artista (nombre_artista, genero_musical_o_actuacion, nacionalidad, sitio_web) VALUES
('Banda Los Rockeros', 'Rock Alternativo', 'Colombiana', 'www.losrockeros.com'),
('Teatro Vivo', 'Drama Clásico', 'Colombiana', 'www.teatrovivo.org'),
('Solista Pop', 'Pop Latino', 'Colombiana', NULL);

INSERT INTO Usuario (nombre_usuario, apellido_usuario, email, telefono) VALUES
('Maria', 'Pérez', 'maria.perez@example.com', '3101234567'),
('Juan', 'Restrepo', 'juan.restrepo@example.com', '3209876543');

INSERT INTO ParticipacionArtista (id_evento, id_artista, rol_en_evento, hora_actuacion) VALUES
(1, 1, 'Principal', '20:30:00'),
(1, 3, 'Invitado', '19:30:00'),
(2, 2, 'Principal', '20:00:00');

INSERT INTO Ticket (id_usuario, id_tipo_entrada, id_evento, precio_pagado, codigo_qr) VALUES
(1, 1, 1, 50000.00, 'QR-ROCK-001-ABC'),
(1, 2, 1, 120000.00, 'QR-ROCK-002-DEF'),
(2, 1, 2, 50000.00, 'QR-TEATRO-001-GHI');


-- CONSULTAS

SELECT nombre_lugar, direccion FROM Lugar;

SELECT E.nombre_evento, L.nombre_lugar, L.direccion
FROM Evento E
JOIN Lugar L ON E.id_lugar = L.id_lugar;

SELECT TE.nombre_tipo, COUNT(T.id_ticket) AS total_tickets_vendidos
FROM Ticket T
JOIN TipoEntrada TE ON T.id_tipo_entrada = TE.id_tipo_entrada
GROUP BY TE.nombre_tipo
ORDER BY total_tickets_vendidos DESC;

SELECT U.nombre_usuario, U.apellido_usuario, COUNT(T.id_ticket) AS total_tickets_comprados
FROM Usuario U
JOIN Ticket T ON U.id_usuario = T.id_usuario
GROUP BY U.id_usuario, U.nombre_usuario, U.apellido_usuario
HAVING COUNT(T.id_ticket) > 1;

SELECT nombre_evento, fecha_hora_inicio, nombre_lugar
FROM Evento E
JOIN Lugar L ON E.id_lugar = L.id_lugar
WHERE E.estado_evento = 'Programado'
ORDER BY fecha_hora_inicio ASC
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;

SELECT SUM(T.precio_pagado) AS ingresos_totales_concierto
FROM Ticket T
JOIN Evento E ON T.id_evento = E.id_evento
WHERE E.nombre_evento = 'Concierto Rock Iquira' AND T.estado_ticket = 'Válido';

SELECT AVG(precio_pagado) AS precio_promedio_ticket FROM Ticket;

SELECT DISTINCT genero_musical_o_actuacion FROM Artista;

SELECT A.nombre_artista
FROM Artista A
WHERE A.id_artista IN (
    SELECT PA.id_artista
    FROM ParticipacionArtista PA
    JOIN Evento E ON PA.id_evento = E.id_evento
    JOIN Lugar L ON E.id_lugar = L.id_lugar
    WHERE L.capacidad_maxima > 1000
);

INSERT INTO Usuario (nombre_usuario, apellido_usuario, email, telefono) VALUES
('Laura', 'Gómez', 'laura.gomez@example.com', '3157778899');

UPDATE Evento
SET estado_evento = 'Cancelado'
WHERE nombre_evento = 'Obra de Teatro Clásica';

DELETE FROM TipoEntrada WHERE nombre_tipo = 'Platino';
