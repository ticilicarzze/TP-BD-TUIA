IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'gestion_arbolado')
BEGIN
    CREATE DATABASE gestion_arbolado;
END
GO

USE gestion_arbolado;
GO

-- Evita errores de formato de fecha (configura formato Año-Mes-Día)
SET DATEFORMAT ymd;
GO

CREATE TABLE Cuadrilla (
    id_cuadrilla INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NULL
);

CREATE TABLE Especie (
    id_especie INT IDENTITY(1,1) PRIMARY KEY,
    nombre_comun VARCHAR(255) NOT NULL,
    nombre_cientifico VARCHAR(255) NOT NULL
);

CREATE TABLE Tipo_Tarea (
    id_tipo INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE Motivo_Reclamo (
    id_motivo INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE Empleado (
    CUIT VARCHAR(20) PRIMARY KEY,
    nombre_apellido VARCHAR(255) NOT NULL,
    telefono VARCHAR(255),
    fecha_ingreso DATE NOT NULL,
    id_cuadrilla INT,
    FOREIGN KEY (id_cuadrilla) REFERENCES Cuadrilla(id_cuadrilla)
);

CREATE TABLE Arbol (
    id VARCHAR(255) PRIMARY KEY,
    id_especie INT NOT NULL,
    ubicacion VARCHAR(255) NOT NULL,
    coordenadas VARCHAR(255) NOT NULL,
    fecha_plantado DATE,
    altura FLOAT,
    fecha_altura DATE,
    salud VARCHAR(20) CHECK (salud IN ('sano', 'débil', 'seco')), 
    FOREIGN KEY (id_especie) REFERENCES Especie(id_especie)
);

CREATE TABLE Tarea (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_tipo INT NOT NULL,
    id_cuadrilla INT,
    fecha_planificada DATETIME NOT NULL,
    fecha_ejecucion DATETIME,
    comentario VARCHAR(MAX),
    FOREIGN KEY (id_tipo) REFERENCES Tipo_Tarea(id_tipo),
    FOREIGN KEY (id_cuadrilla) REFERENCES Cuadrilla(id_cuadrilla)
);

CREATE TABLE Reclamo (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_arbol VARCHAR(255) NOT NULL,
    id_motivo INT NOT NULL,
    id_tarea INT NULL,
    fecha DATETIME NOT NULL,
    estado VARCHAR(20) DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'resuelto', 'cancelado')),
    fecha_asignacion DATETIME NULL,
    FOREIGN KEY (id_arbol) REFERENCES Arbol(id),
    FOREIGN KEY (id_motivo) REFERENCES Motivo_Reclamo(id_motivo),
    FOREIGN KEY (id_tarea) REFERENCES Tarea(id)
);

CREATE TABLE Tarea_Arbol (
    id_tarea INT,
    id_arbol VARCHAR(255),
    PRIMARY KEY (id_tarea, id_arbol),
    FOREIGN KEY (id_tarea) REFERENCES Tarea(id),
    FOREIGN KEY (id_arbol) REFERENCES Arbol(id)
);
GO