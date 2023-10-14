GO
USE [cure_sa];

/* ----------------------------- Eliminar Tablas ---------------------------- */

GO
IF OBJECT_ID('[datos].[reservas_turnos_medicos]', 'U') IS NOT NULL
    DROP TABLE [datos].[reservas_turnos_medicos];

IF OBJECT_ID('[datos].[tipos_turnos]', 'U') IS NOT NULL
    DROP TABLE [datos].[tipos_turnos];

IF OBJECT_ID('[datos].[estados_turnos]', 'U') IS NOT NULL
    DROP TABLE [datos].[estados_turnos];

IF OBJECT_ID('[datos].[dias_x_sede]', 'U') IS NOT NULL
    DROP TABLE [datos].[dias_x_sede];

IF OBJECT_ID('[datos].[medicos]', 'U') IS NOT NULL
    DROP TABLE [datos].[medicos];

IF OBJECT_ID('[datos].[sede_de_atencion]', 'U') IS NOT NULL
    DROP TABLE [datos].[sede_de_atencion];

IF OBJECT_ID('[datos].[prestadores]', 'U') IS NOT NULL
    DROP TABLE [datos].[prestadores];

IF OBJECT_ID('[datos].[usuarios]', 'U') IS NOT NULL
    DROP TABLE [datos].[usuarios];

IF OBJECT_ID('[datos].[estudios]', 'U') IS NOT NULL
    DROP TABLE [datos].[estudios];

IF OBJECT_ID('[datos].[pacientes]', 'U') IS NOT NULL
    DROP TABLE [datos].[pacientes];

IF OBJECT_ID('[referencias].[direcciones]', 'U') IS NOT NULL
    DROP TABLE [referencias].[direcciones];

IF OBJECT_ID('[referencias].[nombres_provincias]', 'U') IS NOT NULL
    DROP TABLE [referencias].[nombres_provincias];

IF OBJECT_ID('[datos].[especialidad]', 'U') IS NOT NULL
    DROP TABLE [datos].[especialidad];

IF OBJECT_ID('[datos].[coberturas]', 'U') IS NOT NULL
    DROP TABLE [datos].[coberturas];

IF OBJECT_ID('[referencias].[nombres_localidades]', 'U') IS NOT NULL
    DROP TABLE [referencias].[nombres_localidades];

IF OBJECT_ID('[referencias].[tipos_documentos]', 'U') IS NOT NULL
    DROP TABLE [referencias].[tipos_documentos];

IF OBJECT_ID('[referencias].[paises]', 'U') IS NOT NULL
    DROP TABLE [referencias].[paises];

IF OBJECT_ID('[referencias].[generos]', 'U') IS NOT NULL
    DROP TABLE [referencias].[generos];

/* ------------------------------ Crear Tablas ------------------------------ */

GO
CREATE TABLE [referencias].[generos]
(
    id_genero INT IDENTITY (1, 1),
    nombre VARCHAR(50) COLLATE Latin1_General_CS_AS NOT NULL
);

CREATE TABLE [referencias].[paises]
(
    gentilicio VARCHAR(50) COLLATE Latin1_General_CS_AS UNIQUE NOT NULL,
    id_pais INT IDENTITY (1, 1),
    nombre VARCHAR(50) COLLATE Latin1_General_CS_AS NOT NULL
);

CREATE TABLE [referencias].[nombres_provincias]
(
    id_pais INT,
    id_provincia INT IDENTITY (1, 1),
    nombre VARCHAR(50) COLLATE Latin1_General_CS_AS NOT NULL
);

CREATE TABLE [referencias].[nombres_localidades]
(
    id_localidad INT IDENTITY (1, 1),
    id_provincia INT,
    nombre VARCHAR(50) COLLATE Latin1_General_CS_AS NOT NULL
);

CREATE TABLE [referencias].[direcciones]
(
    calle_y_nro VARCHAR(50) COLLATE Latin1_General_CS_AS NOT NULL,
    cod_postal SMALLINT,
    departamento SMALLINT,
    id_direccion INT IDENTITY (1, 1),
    id_localidad INT NOT NULL,
    id_pais INT,
    id_provincia INT NOT NULL,
    piso SMALLINT
);

CREATE TABLE [referencias].[tipos_documentos]
(
    id_tipo_documento INT IDENTITY (1, 1),
    nombre VARCHAR(50) COLLATE Latin1_General_CS_AS NOT NULL
);

CREATE TABLE [referencias].[nacionalidades]
(
    id_nacionalidad INT IDENTITY (1,1),
    nombre VARCHAR(50) COLLATE Latin1_General_CS_AS NOT NULL
);

CREATE TABLE [datos].[pacientes]
(
    apellido VARCHAR (50) COLLATE Latin1_General_CS_AS NOT NULL,
    apellido_materno VARCHAR (50) COLLATE Latin1_General_CS_AS,
    email VARCHAR (70) COLLATE Latin1_General_CS_AS UNIQUE NOT NULL,
    fecha_actualizacion DATE,
    fecha_nacimiento DATE NOT NULL,
    fecha_registro DATE DEFAULT CAST(GETDATE () AS DATE),
    foto_perfil VARCHAR(128),
    id_cobertura INT,
    id_direccion INT,
    id_genero INT NOT NULL,
    id_paciente INT IDENTITY (1, 1),
    id_tipo_documento INT NOT NULL,
    nacionalidad INT,
    nombre VARCHAR (50) COLLATE Latin1_General_CS_AS NOT NULL,
    nro_documento VARCHAR(50) COLLATE Latin1_General_CS_AS NOT NULL,
    sexo_biologico CHAR(1),
    tel_alternativo VARCHAR(20),
    tel_fijo VARCHAR(20) NOT NULL,
    tel_laboral VARCHAR(20),
    usuario_actualizacion INT,
    valido BIT DEFAULT 1
);

CREATE TABLE [datos].[estudios]
(
    autorizado BIT DEFAULT 1,
    documento_resultado VARCHAR (128),
    fecha DATE NOT NULL,
    id_estudio INT IDENTITY (1, 1),
    id_paciente INT,
    imagen_resultado VARCHAR (128),
    nombre_estudio VARCHAR(60) COLLATE Latin1_General_CS_AS NOT NULL
);

CREATE TABLE [datos].[usuarios]
(
    contraseña VARCHAR(256) COLLATE Latin1_General_CS_AS,
    fecha_creacion DATE DEFAULT CAST(GETDATE () AS DATE),
    id_paciente INT,
    id_usuario INT IDENTITY (1, 1),
);

CREATE TABLE [datos].[coberturas]
(
    fecha_registro DATE DEFAULT CAST(GETDATE () AS DATE),
    id_cobertura INT IDENTITY (1, 1),
    id_prestador INT,
    imagen_credencial VARCHAR (128),
    nro_socio VARCHAR(30) COLLATE Latin1_General_CS_AS NOT NULL
);

CREATE TABLE [datos].[prestadores]
(
    id_prestador INT IDENTITY (1, 1),
    nombre VARCHAR(50) COLLATE Latin1_General_CS_AS NOT NULL,
    plan_prestador VARCHAR(30) COLLATE Latin1_General_CS_AS NOT NULL
);

CREATE TABLE [datos].[reservas_turnos_medicos]
(
    fecha DATE DEFAULT CAST (GETDATE () AS DATE),
    hora TIME DEFAULT CAST(GETDATE () AS TIME),
    id_dias_x_sede INT NOT NULL,
    id_direccion_atencion INT NOT NULL,
    id_especialidad INT NOT NULL,
    id_estado_turno INT NOT NULL,
    id_medico INT NOT NULL,
    id_paciente INT NOT NULL,
    id_tipo_turno INT NOT NULL,
    id_turno INT IDENTITY (1, 1)
);

CREATE TABLE [datos].[estados_turnos]
(
    id_estado INT IDENTITY (1, 1),
    nombre CHAR (15) COLLATE Latin1_General_CS_AS
);

CREATE TABLE [datos].[tipos_turnos]
(
    id_tipo_turno INT IDENTITY (1, 1),
    nombre_tipo CHAR (15) COLLATE Latin1_General_CS_AS
);

CREATE TABLE [datos].[dias_x_sede]
(
    dia DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    id_medico INT NOT NULL,
	id_dias_x_sede INT IDENTITY(1,1),
    id_sede INT NOT NULL,
);

CREATE TABLE [datos].[sede_de_atencion]
(
    direccion INT,
    id_sede INT IDENTITY (1, 1),
    nombre VARCHAR(100) COLLATE Latin1_General_CS_AS NOT NULL
);

CREATE TABLE [datos].[medicos]
(
    apellido VARCHAR (50) COLLATE Latin1_General_CS_AS NOT NULL,
    id_especialidad INT,
    id_medico INT IDENTITY (1, 1),
    nombre VARCHAR (50) COLLATE Latin1_General_CS_AS NOT NULL,
    nro_matricula INT NOT NULL,
    alta BIT DEFAULT 1,
);

CREATE TABLE [datos].[especialidad]
(
    id_especialidad INT IDENTITY (1, 1),
    nombre VARCHAR(50) COLLATE Latin1_General_CS_AS NOT NULL
);
use master;