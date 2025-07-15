IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'medico')
BEGIN
    CREATE DATABASE medico;
END;
GO

USE medico;
GO

CREATE TABLE Especialidad (
    id_especialidad INT PRIMARY KEY IDENTITY(1,1),
    nombre_especialidad VARCHAR(100) NOT NULL UNIQUE,
    descripcion_especialidad TEXT
);

CREATE TABLE Medico (
    id_medico INT PRIMARY KEY IDENTITY(1,1),
    nombre_medico VARCHAR(100) NOT NULL,
    apellido_medico VARCHAR(100) NOT NULL,
    licencia_medica VARCHAR(50) NOT NULL UNIQUE,
    telefono_contacto VARCHAR(20),
    email VARCHAR(150) UNIQUE,
    direccion_consultorio VARCHAR(255),
    id_especialidad_principal INT NOT NULL,
    FOREIGN KEY (id_especialidad_principal) REFERENCES Especialidad(id_especialidad)
);

CREATE TABLE Paciente (
    id_paciente INT PRIMARY KEY IDENTITY(1,1),
    nombre_paciente VARCHAR(100) NOT NULL,
    apellido_paciente VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    genero VARCHAR(10) CHECK (genero IN ('Masculino', 'Femenino', 'Otro')) NOT NULL,
    dni VARCHAR(20) NOT NULL UNIQUE,
    telefono_contacto VARCHAR(20),
    email VARCHAR(150) UNIQUE,
    direccion_residencia VARCHAR(255),
    tipo_sangre VARCHAR(5),
    alergias TEXT
);

CREATE TABLE HistorialMedico (
    id_historial INT PRIMARY KEY IDENTITY(1,1),
    id_paciente INT NOT NULL UNIQUE,
    fecha_creacion DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    antecedentes_familiares TEXT,
    antecedentes_personales TEXT,
    medicamentos_actuales TEXT,
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente)
);

CREATE TABLE Cita (
    id_cita INT PRIMARY KEY IDENTITY(1,1),
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    fecha_hora_cita DATETIME2 NOT NULL,
    motivo_cita VARCHAR(255),
    estado_cita VARCHAR(20) CHECK (estado_cita IN ('Programada', 'Confirmada', 'Cancelada', 'Completada', 'Reagendada')) NOT NULL DEFAULT 'Programada',
    duracion_minutos INT,
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES Medico(id_medico),
    CONSTRAINT UQ_Cita UNIQUE (id_medico, fecha_hora_cita)
);

CREATE TABLE ConsultaMedica (
    id_consulta INT PRIMARY KEY IDENTITY(1,1),
    id_cita INT NOT NULL UNIQUE,
    id_medico INT NOT NULL,
    id_paciente INT NOT NULL,
    fecha_hora_consulta DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    motivo_consulta_detalle TEXT,
    examen_fisico TEXT,
    observaciones TEXT,
    procedimientos_realizados TEXT,
    plan_tratamiento TEXT,
    FOREIGN KEY (id_cita) REFERENCES Cita(id_cita),
    FOREIGN KEY (id_medico) REFERENCES Medico(id_medico),
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente)
);

CREATE TABLE Diagnostico (
    id_diagnostico INT PRIMARY KEY IDENTITY(1,1),
    codigo_cie VARCHAR(20) UNIQUE,
    nombre_diagnostico VARCHAR(255) NOT NULL,
    descripcion_diagnostico TEXT
);

CREATE TABLE Prescripcion (
    id_prescripcion INT PRIMARY KEY IDENTITY(1,1),
    id_consulta INT NOT NULL,
    nombre_medicamento VARCHAR(255) NOT NULL,
    dosis VARCHAR(100),
    frecuencia VARCHAR(100),
    duracion_dias INT,
    instrucciones_especiales TEXT,
    FOREIGN KEY (id_consulta) REFERENCES ConsultaMedica(id_consulta)
);

CREATE TABLE MedicoEspecialidad (
    id_medico_especialidad INT PRIMARY KEY IDENTITY(1,1),
    id_medico INT NOT NULL,
    id_especialidad INT NOT NULL,
    fecha_certificacion DATE,
    FOREIGN KEY (id_medico) REFERENCES Medico(id_medico),
    FOREIGN KEY (id_especialidad) REFERENCES Especialidad(id_especialidad),
    CONSTRAINT UQ_MedicoEspecialidad UNIQUE (id_medico, id_especialidad)
);

INSERT INTO Especialidad (nombre_especialidad, descripcion_especialidad) VALUES
('Cardiología', 'Diagnóstico y tratamiento de enfermedades del corazón.'),
('Pediatría', 'Atención médica de niños y adolescentes.'),
('Dermatología', 'Tratamiento de enfermedades de la piel, cabello y uñas.'),
('Medicina General', 'Atención primaria de salud.');

INSERT INTO Medico (nombre_medico, apellido_medico, licencia_medica, telefono_contacto, email, direccion_consultorio, id_especialidad_principal) VALUES
('Juan', 'Pérez', 'MP12345', '3001234567', 'juan.perez@clinica.com', 'Calle 10 # 15-20, Cons. 101', 1),
('Ana', 'Gómez', 'MP67890', '3019876543', 'ana.gomez@clinica.com', 'Calle 10 # 15-20, Cons. 203', 2),
('Luis', 'Fernández', 'MP11223', '3023456789', 'luis.fernandez@clinica.com', 'Avenida Principal 50-05, Cons. 301', 4);

INSERT INTO Paciente (nombre_paciente, apellido_paciente, fecha_nacimiento, genero, dni, telefono_contacto, email, direccion_residencia, tipo_sangre, alergias) VALUES
('María', 'López', '1985-03-10', 'Femenino', '101010101', '3055551122', 'maria.lopez@email.com', 'Carrera 7 # 2-30', 'O+', 'Penicilina'),
('Carlos', 'Ramírez', '2010-11-25', 'Masculino', '202020202', '3066663344', 'carlos.ramirez@email.com', 'Transversal 3 # 8-15', 'A-', NULL);

INSERT INTO HistorialMedico (id_paciente, antecedentes_familiares, antecedentes_personales, medicamentos_actuales) VALUES
(1, 'Hipertensión, Diabetes', 'Asma infantil', 'Omeprazol (si es necesario)'),
(2, 'Ninguno relevante', 'Varicela a los 5 años', 'Ninguno');

INSERT INTO Cita (id_paciente, id_medico, fecha_hora_cita, motivo_cita, estado_cita, duracion_minutos) VALUES
(1, 1, '2025-07-20 09:00:00', 'Chequeo cardiológico', 'Programada', 45),
(2, 2, '2025-07-21 10:30:00', 'Control de crecimiento', 'Confirmada', 30),
(1, 3, '2025-07-22 11:00:00', 'Consulta por dolor de cabeza', 'Programada', 30);

INSERT INTO ConsultaMedica (id_cita, id_medico, id_paciente, fecha_hora_consulta, motivo_consulta_detalle, examen_fisico, observaciones, procedimientos_realizados, plan_tratamiento) VALUES
(1, 1, 1, '2025-07-20 09:00:00', 'Paciente refiere palpitaciones ocasionales.', 'PA 130/80, FC 75, Ruidos cardíacos normales.', 'Se recomienda EKG y holter.', 'Electrocardiograma (EKG)', 'Programar Holter. Revisión en 1 semana.'),
(2, 2, 2, '2025-07-21 10:30:00', 'Control rutinario pediátrico.', 'Peso y talla en percentil 50. Auscultación pulmonar normal.', 'Desarrollo adecuado para la edad.', 'Ninguno', 'Seguir con controles anuales. Dieta balanceada.');

INSERT INTO Diagnostico (codigo_cie, nombre_diagnostico, descripcion_diagnostico) VALUES
('I10', 'Hipertensión esencial (primaria)', 'Presión arterial alta sin causa secundaria identificable.'),
('R51', 'Cefalea', 'Dolor de cabeza no especificado.'),
('Z00.0', 'Examen médico general de salud', 'Chequeo de rutina.');

INSERT INTO Prescripcion (id_consulta, nombre_medicamento, dosis, frecuencia, duracion_dias, instrucciones_especiales) VALUES
(1, 'Amlodipino', '5 mg', 'Una vez al día', 30, 'Tomar con alimentos.'),
(1, 'Losartan', '50 mg', 'Una vez al día', 30, 'Tomar por la mañana.'),
(2, 'Vitamina D', '400 UI', 'Una vez al día', 90, 'Suplemento nutricional.');

INSERT INTO MedicoEspecialidad (id_medico, id_especialidad, fecha_certificacion) VALUES
(1, 4, '2015-06-01');

SELECT
    C.fecha_hora_cita,
    C.motivo_cita,
    P.nombre_paciente,
    P.apellido_paciente,
    M.nombre_medico,
    M.apellido_medico,
    E.nombre_especialidad
FROM
    Cita C
JOIN
    Paciente P ON C.id_paciente = P.id_paciente
JOIN
    Medico M ON C.id_medico = M.id_medico
JOIN
    Especialidad E ON M.id_especialidad_principal = E.id_especialidad
WHERE
    C.estado_cita = 'Programada'
ORDER BY
    C.fecha_hora_cita;

SELECT
    P.nombre_paciente,
    P.apellido_paciente,
    HM.antecedentes_familiares,
    HM.antecedentes_personales,
    HM.medicamentos_actuales,
    C.fecha_hora_consulta,
    C.motivo_consulta_detalle,
    C.plan_tratamiento,
    M.nombre_medico AS medico_consulta
FROM
    Paciente P
JOIN
    HistorialMedico HM ON P.id_paciente = HM.id_paciente
LEFT JOIN
    ConsultaMedica C ON P.id_paciente = C.id_paciente
LEFT JOIN
    Medico M ON C.id_medico = M.id_medico
WHERE
    P.nombre_paciente = 'María' AND P.apellido_paciente = 'López'
ORDER BY
    C.fecha_hora_consulta DESC;

SELECT
    P.nombre_medicamento,
    P.dosis,
    P.frecuencia,
    P.duracion_dias,
    P.instrucciones_especiales,
    CM.fecha_hora_consulta,
    Med.nombre_medico,
    Pac.nombre_paciente
FROM
    Prescripcion P
JOIN
    ConsultaMedica CM ON P.id_consulta = CM.id_consulta
JOIN
    Medico Med ON CM.id_medico = Med.id_medico
JOIN
    Paciente Pac ON CM.id_paciente = Pac.id_paciente
WHERE
    P.id_consulta = 1;

SELECT
    E.nombre_especialidad,
    COUNT(M.id_medico) AS numero_medicos
FROM
    Especialidad E
LEFT JOIN
    Medico M ON E.id_especialidad = M.id_especialidad_principal
GROUP BY
    E.nombre_especialidad
ORDER BY
    numero_medicos DESC;

SELECT DISTINCT
    P.nombre_paciente,
    P.apellido_paciente,
    P.telefono_contacto
FROM
    Paciente P
JOIN
    Cita C ON P.id_paciente = C.id_paciente
JOIN
    Medico M ON C.id_medico = M.id_medico
WHERE
    M.nombre_medico = 'Juan' AND M.apellido_medico = 'Pérez';
