--DDL
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'SistemaVideojuegos')
BEGIN
    CREATE DATABASE SistemaVideojuegos;
END
GO

USE SistemaVideojuegos;
GO


CREATE TABLE Desarrollador (
    id_desarrollador INT PRIMARY KEY IDENTITY(1,1),
    nombre_desarrollador VARCHAR(100) NOT NULL UNIQUE,
    pais_origen VARCHAR(100),
    fecha_fundacion DATE,
    web_oficial VARCHAR(255) UNIQUE
);
GO

CREATE TABLE Plataforma (
    id_plataforma INT PRIMARY KEY IDENTITY(1,1),
    nombre_plataforma VARCHAR(100) NOT NULL UNIQUE,
    fabricante VARCHAR(100),
    fecha_lanzamiento DATE,
    generacion VARCHAR(50)
);
GO

CREATE TABLE Genero (
    id_genero INT PRIMARY KEY IDENTITY(1,1),
    nombre_genero VARCHAR(100) NOT NULL UNIQUE,
    descripcion_genero TEXT
);
GO

CREATE TABLE Videojuego (
    id_videojuego INT PRIMARY KEY IDENTITY(1,1),
    titulo VARCHAR(255) NOT NULL,
    fecha_lanzamiento DATE,
    clasificacion_esrb VARCHAR(10),
    precio DECIMAL(10, 2),
    descripcion_corta TEXT,
    id_desarrollador INT NOT NULL,
    id_genero_principal INT NOT NULL,
    FOREIGN KEY (id_desarrollador) REFERENCES Desarrollador(id_desarrollador),
    FOREIGN KEY (id_genero_principal) REFERENCES Genero(id_genero)
);
GO

CREATE TABLE JuegoPlataforma (
    id_juego_plataforma INT PRIMARY KEY IDENTITY(1,1),
    id_videojuego INT NOT NULL,
    id_plataforma INT NOT NULL,
    fecha_lanzamiento_plataforma DATE,
    edicion_especial VARCHAR(100),
    FOREIGN KEY (id_videojuego) REFERENCES Videojuego(id_videojuego),
    FOREIGN KEY (id_plataforma) REFERENCES Plataforma(id_plataforma),
    CONSTRAINT unq_juego_plataforma UNIQUE (id_videojuego, id_plataforma)
);
GO

CREATE TABLE Jugador (
    id_jugador INT PRIMARY KEY IDENTITY(1,1),
    nombre_usuario VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    fecha_registro DATETIME NOT NULL DEFAULT GETDATE(),
    fecha_nacimiento DATE,
    pais_residencia VARCHAR(100)
);
GO

CREATE TABLE ColeccionJuegos (
    id_coleccion INT PRIMARY KEY IDENTITY(1,1),
    id_jugador INT NOT NULL,
    id_juego_plataforma INT NOT NULL,
    fecha_adquisicion DATETIME NOT NULL DEFAULT GETDATE(),
    metodo_adquisicion VARCHAR(50),
    horas_jugadas DECIMAL(10, 2) DEFAULT 0.00,
    estado_juego VARCHAR(50) DEFAULT 'Pendiente',
    FOREIGN KEY (id_jugador) REFERENCES Jugador(id_jugador),
    FOREIGN KEY (id_juego_plataforma) REFERENCES JuegoPlataforma(id_juego_plataforma),
    CONSTRAINT unq_coleccion UNIQUE (id_jugador, id_juego_plataforma)
);
GO
--DML
INSERT INTO Desarrollador (nombre_desarrollador, pais_origen, fecha_fundacion, web_oficial) VALUES
('CD Projekt Red', 'Polonia', '2002-05-01', 'https://en.cdprojektred.com/'),
('Ubisoft', 'Francia', '1986-03-28', 'https://www.ubisoft.com/'),
('Nintendo', 'Japón', '1889-09-23', 'https://www.nintendo.com/');
GO

INSERT INTO Plataforma (nombre_plataforma, fabricante, fecha_lanzamiento, generacion) VALUES
('PC', 'Microsoft', '1981-08-12', 'Varias'),
('PlayStation 5', 'Sony', '2020-11-12', '9na Generación'),
('Nintendo Switch', 'Nintendo', '2017-03-03', '8va Generación');
GO

INSERT INTO Genero (nombre_genero, descripcion_genero) VALUES
('RPG', 'Juegos de rol con progresión de personaje y narrativa profunda.'),
('Acción', 'Juegos que se centran en el combate y la respuesta rápida.'),
('Aventura', 'Juegos con exploración, resolución de puzles y narrativa.');
GO

INSERT INTO Videojuego (titulo, fecha_lanzamiento, clasificacion_esrb, precio, descripcion_corta, id_desarrollador, id_genero_principal) VALUES
('Cyberpunk 2077', '2020-12-10', 'M', 59.99, 'Un RPG de acción y aventura de mundo abierto ambientado en Night City.', 1, 1),
('Assassin''s Creed Valhalla', '2020-11-10', 'M', 49.99, 'Un juego de rol de acción donde juegas como un asaltante vikingo.', 2, 2),
('The Legend of Zelda: Breath of the Wild', '2017-03-03', 'E10+', 59.99, 'Un juego de acción y aventura de mundo abierto en el reino de Hyrule.', 3, 3);
GO

INSERT INTO JuegoPlataforma (id_videojuego, id_plataforma, fecha_lanzamiento_plataforma, edicion_especial) VALUES
(1, 1, '2020-12-10', 'Standard'),
(1, 2, '2020-12-10', 'Standard'),
(2, 1, '2020-11-10', 'Standard'),
(2, 2, '2020-11-10', 'Standard'),
(3, 3, '2017-03-03', 'Standard');
GO

INSERT INTO Jugador (nombre_usuario, email, fecha_nacimiento, pais_residencia) VALUES
('GamerPro123', 'gamerpro123@email.com', '1995-01-20', 'Colombia'),
('LinkFanatic', 'linkfanatic@email.com', '2000-07-15', 'Colombia');
GO

INSERT INTO ColeccionJuegos (id_jugador, id_juego_plataforma, fecha_adquisicion, metodo_adquisicion, horas_jugadas, estado_juego) VALUES
(1, 1, '2025-07-10 12:00:00', 'Comprado', 150.50, 'Completado'),
(1, 3, '2025-07-12 10:30:00', 'Suscripción', 30.00, 'Jugando'),
(2, 5, '2025-07-05 18:00:00', 'Comprado', 200.00, 'Completado');
GO
