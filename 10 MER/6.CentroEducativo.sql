--DDL
CREATE DATABASE CentroEducativo;
GO

USE CentroEducativo;
GO


CREATE TABLE Profesor (
    id_profesor INT PRIMARY KEY IDENTITY,
    nombre_profesor VARCHAR(100) NOT NULL,
    apellido_profesor VARCHAR(100) NOT NULL,
    fecha_contratacion DATE,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20)
);
GO


CREATE TABLE Asignatura (
    id_asignatura INT PRIMARY KEY IDENTITY,
    nombre_asignatura VARCHAR(100) NOT NULL UNIQUE,
    creditos INT NOT NULL,
    descripcion_asignatura TEXT
);
GO


CREATE TABLE Curso (
    id_curso INT PRIMARY KEY IDENTITY,
    nombre_curso VARCHAR(100) NOT NULL UNIQUE,
    nivel_educativo VARCHAR(50),
    duracion_meses INT,
    id_profesor_tutor INT,
    FOREIGN KEY (id_profesor_tutor) REFERENCES Profesor(id_profesor)
);
GO

CREATE TABLE Estudiante (
    id_estudiante INT PRIMARY KEY IDENTITY,
    nombre_estudiante VARCHAR(100) NOT NULL,
    apellido_estudiante VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    genero CHAR(1),
    email VARCHAR(150) UNIQUE,
    telefono_contacto VARCHAR(20),
    id_curso_actual INT,
    FOREIGN KEY (id_curso_actual) REFERENCES Curso(id_curso)
);
GO

CREATE TABLE Clase (
    id_clase INT PRIMARY KEY IDENTITY,
    id_asignatura INT NOT NULL,
    id_profesor INT NOT NULL,
    codigo_clase VARCHAR(50) NOT NULL UNIQUE,
    año_academico INT NOT NULL,
    semestre VARCHAR(20),
    cupo_maximo INT NOT NULL,
    aula_asignada VARCHAR(50),
    FOREIGN KEY (id_asignatura) REFERENCES Asignatura(id_asignatura),
    FOREIGN KEY (id_profesor) REFERENCES Profesor(id_profesor)
);
GO


CREATE TABLE Matricula (
    id_matricula INT PRIMARY KEY IDENTITY,
    id_estudiante INT NOT NULL,
    id_clase INT NOT NULL,
    fecha_matricula DATETIME NOT NULL DEFAULT GETDATE(),
    estado_matricula VARCHAR(50) NOT NULL DEFAULT 'Activa',
    calificacion_final DECIMAL(4, 2),
    FOREIGN KEY (id_estudiante) REFERENCES Estudiante(id_estudiante),
    FOREIGN KEY (id_clase) REFERENCES Clase(id_clase),
    UNIQUE (id_estudiante, id_clase)
);
GO


CREATE TABLE Calificacion (
    id_calificacion INT PRIMARY KEY IDENTITY,
    id_matricula INT NOT NULL,
    tipo_evaluacion VARCHAR(50) NOT NULL,
    fecha_evaluacion DATE NOT NULL,
    nota_obtenida DECIMAL(4, 2) NOT NULL,
    peso_en_promedio DECIMAL(3, 2) NOT NULL,
    FOREIGN KEY (id_matricula) REFERENCES Matricula(id_matricula)
);
GO

-- DML

INSERT INTO Profesor (nombre_profesor, apellido_profesor, fecha_contratacion, email, telefono) VALUES
('Carlos', 'Ramírez', '2020-08-15', 'carlos.ramirez@educativo.com', '3101112233'),
('Laura', 'Martínez', '2021-02-01', 'laura.martinez@educativo.com', '3204445566');
GO

INSERT INTO Asignatura (nombre_asignatura, creditos, descripcion_asignatura) VALUES
('Matemáticas VII', 4, 'Álgebra y Geometría avanzada para séptimo grado.'),
('Historia de Colombia', 3, 'Estudio de los eventos históricos clave de Colombia.'),
('Física I', 5, 'Introducción a la mecánica clásica.');
GO

INSERT INTO Curso (nombre_curso, nivel_educativo, duracion_meses, id_profesor_tutor) VALUES
('Séptimo Grado A', 'Secundaria', 10, 1),
('Primer Semestre Ing. Sistemas', 'Universitario', 6, 2);
GO


INSERT INTO Estudiante (nombre_estudiante, apellido_estudiante, fecha_nacimiento, genero, email, telefono_contacto, id_curso_actual) VALUES
('Sofía', 'López', '2010-03-20', 'F', 'sofia.lopez@estudiante.com', '3157778899', 1),
('Diego', 'Sánchez', '2005-07-10', 'M', 'diego.sanchez@estudiante.com', '3189990011', 2),
('Valentina', 'Díaz', '2010-01-05', 'F', 'valentina.diaz@estudiante.com', '3123334455', 1);
GO


INSERT INTO Clase (id_asignatura, id_profesor, codigo_clase, año_academico, semestre, cupo_maximo, aula_asignada) VALUES
(1, 1, 'MAT7A-2025', 2025, '1er Semestre', 30, 'Aula 201'),
(2, 1, 'HCOL7B-2025', 2025, '1er Semestre', 25, 'Aula 202'),
(3, 2, 'FISI1-2025', 2025, '1er Semestre', 40, 'Laboratorio 305');
GO


INSERT INTO Matricula (id_estudiante, id_clase) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 1);
GO


INSERT INTO Calificacion (id_matricula, tipo_evaluacion, fecha_evaluacion, nota_obtenida, peso_en_promedio) VALUES
(1, 'Quiz', '2025-07-20', 4.0, 0.2),
(1, 'Examen', '2025-08-10', 4.5, 0.4),
(3, 'Proyecto', '2025-09-01', 3.8, 0.3);
GO
