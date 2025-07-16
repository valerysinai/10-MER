CREATE DATABASE CentroProyectos;
GO

USE CentroProyectos;
GO

CREATE TABLE Equipo (
    id_equipo INT PRIMARY KEY IDENTITY,
    nombre_equipo VARCHAR(100) NOT NULL UNIQUE,
    descripcion_equipo TEXT,
    fecha_creacion DATE NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Proyecto (
    id_proyecto INT PRIMARY KEY IDENTITY,
    nombre_proyecto VARCHAR(255) NOT NULL,
    descripcion_proyecto TEXT,
    fecha_inicio_proyecto DATE NOT NULL,
    fecha_fin_prevista DATE,
    estado_proyecto VARCHAR(50) NOT NULL DEFAULT 'Activo',
    id_equipo_asignado INT NOT NULL,
    FOREIGN KEY (id_equipo_asignado) REFERENCES Equipo(id_equipo)
);

CREATE TABLE Miembro (
    id_miembro INT PRIMARY KEY IDENTITY,
    nombre_miembro VARCHAR(100) NOT NULL,
    apellido_miembro VARCHAR(100) NOT NULL,
    rol_en_equipo VARCHAR(50),
    email VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    id_equipo INT NOT NULL,
    FOREIGN KEY (id_equipo) REFERENCES Equipo(id_equipo)
);

CREATE TABLE Tarea (
    id_tarea INT PRIMARY KEY IDENTITY,
    nombre_tarea VARCHAR(255) NOT NULL,
    descripcion_tarea TEXT,
    fecha_creacion_tarea DATETIME NOT NULL DEFAULT GETDATE(),
    fecha_vencimiento DATE,
    prioridad VARCHAR(20) NOT NULL DEFAULT 'Media',
    estado_tarea VARCHAR(50) NOT NULL DEFAULT 'Pendiente',
    id_proyecto INT NOT NULL,
    FOREIGN KEY (id_proyecto) REFERENCES Proyecto(id_proyecto)
);

CREATE TABLE AsignacionTarea (
    id_asignacion INT PRIMARY KEY IDENTITY,
    id_tarea INT NOT NULL,
    id_miembro INT NOT NULL,
    fecha_asignacion DATETIME NOT NULL DEFAULT GETDATE(),
    porcentaje_completado DECIMAL(5, 2) DEFAULT 0.00,
    comentarios_asignacion TEXT,
    FOREIGN KEY (id_tarea) REFERENCES Tarea(id_tarea),
    FOREIGN KEY (id_miembro) REFERENCES Miembro(id_miembro),
    UNIQUE (id_tarea, id_miembro)
);

CREATE TABLE DependenciaTarea (
    id_dependencia INT PRIMARY KEY IDENTITY,
    id_tarea_predecesora INT NOT NULL,
    id_tarea_sucesora INT NOT NULL,
    tipo_dependencia VARCHAR(50) NOT NULL DEFAULT 'Final a Inicio',
    FOREIGN KEY (id_tarea_predecesora) REFERENCES Tarea(id_tarea),
    FOREIGN KEY (id_tarea_sucesora) REFERENCES Tarea(id_tarea),
    UNIQUE (id_tarea_predecesora, id_tarea_sucesora),
    CHECK (id_tarea_predecesora <> id_tarea_sucesora)
);

CREATE TABLE ComentarioTarea (
    id_comentario INT PRIMARY KEY IDENTITY,
    id_tarea INT NOT NULL,
    id_miembro INT NOT NULL,
    fecha_comentario DATETIME NOT NULL DEFAULT GETDATE(),
    texto_comentario TEXT NOT NULL,
    FOREIGN KEY (id_tarea) REFERENCES Tarea(id_tarea),
    FOREIGN KEY (id_miembro) REFERENCES Miembro(id_miembro)
);

-- Insertar datos
INSERT INTO Equipo (nombre_equipo, descripcion_equipo, fecha_creacion) VALUES
('Equipo Alpha', 'Equipo principal de desarrollo de software.', '2024-01-01'),
('Equipo Beta', 'Equipo de diseño y pruebas.', '2024-03-10');

INSERT INTO Proyecto (nombre_proyecto, descripcion_proyecto, fecha_inicio_proyecto, fecha_fin_prevista, estado_proyecto, id_equipo_asignado) VALUES
('Desarrollo App Móvil', 'Creación de una aplicación de gestión de tareas.', '2025-07-01', '2025-12-31', 'Activo', 1),
('Rediseño Web Corporativa', 'Actualización completa del sitio web de la empresa.', '2025-06-15', '2025-10-31', 'Activo', 2);

INSERT INTO Miembro (nombre_miembro, apellido_miembro, rol_en_equipo, email, telefono, id_equipo) VALUES
('Ana', 'Soto', 'Líder', 'ana.soto@empresa.com', '3101234567', 1),
('Luis', 'Contreras', 'Desarrollador', 'luis.contreras@empresa.com', '3209876543', 1),
('Marta', 'Herrera', 'Diseñador', 'marta.herrera@empresa.com', '3157778899', 2);

INSERT INTO Tarea (nombre_tarea, descripcion_tarea, fecha_vencimiento, prioridad, id_proyecto) VALUES
('Definir Requisitos Funcionales', 'Levantamiento de todos los requisitos de la app.', '2025-07-15', 'Alta', 1),
('Diseñar Interfaz de Usuario', 'Creación de wireframes y mockups.', '2025-07-25', 'Alta', 1),
('Implementar Módulo de Usuarios', 'Codificación del sistema de registro y login.', '2025-08-10', 'Alta', 1),
('Revisar Contenido Actual', 'Auditoría del contenido existente en la web.', '2025-06-20', 'Media', 2);

INSERT INTO AsignacionTarea (id_tarea, id_miembro, porcentaje_completado) VALUES
(1, 1, 80.00),
(1, 2, 80.00),
(2, 3, 50.00),
(4, 3, 100.00);

INSERT INTO DependenciaTarea (id_tarea_predecesora, id_tarea_sucesora, tipo_dependencia) VALUES
(1, 2, 'Final a Inicio'),
(2, 3, 'Final a Inicio');

INSERT INTO ComentarioTarea (id_tarea, id_miembro, texto_comentario) VALUES
(1, 1, 'Necesitamos Clarificación sobre el módulo de pagos.'),
(2, 3, 'Se enviaron los primeros mockups para revisión.');

