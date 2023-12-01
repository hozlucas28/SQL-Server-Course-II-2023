USE [CURESA];
GO


/* ----------------------------- Eliminar Tablas ---------------------------- */

IF OBJECT_ID('[utilities].[Addresses]', 'U') IS NOT NULL
    DROP TABLE [utilities].[Addresses];

IF OBJECT_ID('[utilities].[Localities]', 'U') IS NOT NULL
    DROP TABLE [utilities].[Localities];

IF OBJECT_ID('[utilities].[Provinces]', 'U') IS NOT NULL
    DROP TABLE [utilities].[Provinces];

IF OBJECT_ID('[utilities].[Countries]', 'U') IS NOT NULL
    DROP TABLE [utilities].[Countries];

IF OBJECT_ID('[utilities].[Nationalities]', 'U') IS NOT NULL
    DROP TABLE [utilities].[Nationalities];

IF OBJECT_ID('[utilities].[Documents]', 'U') IS NOT NULL
    DROP TABLE [utilities].[Documents];

IF OBJECT_ID('[utilities].[Genders]', 'U') IS NOT NULL
    DROP TABLE [utilities].[Genders];

IF OBJECT_ID('[data].[Shifts]', 'U') IS NOT NULL
    DROP TABLE [data].[Shifts];

IF OBJECT_ID('[data].[Shift_Status]', 'U') IS NOT NULL
    DROP TABLE [data].[Shift_Status];

IF OBJECT_ID('[data].[Days_X_Headquarter]', 'U') IS NOT NULL
    DROP TABLE [data].[Days_X_Headquarter];

IF OBJECT_ID('[data].[Care_Headquarters]', 'U') IS NOT NULL
    DROP TABLE [data].[Care_Headquarters];

IF OBJECT_ID('[data].[Specialties]', 'U') IS NOT NULL
    DROP TABLE [data].[Specialties];

IF OBJECT_ID('[data].[Providers]', 'U') IS NOT NULL
    DROP TABLE [data].[Providers];

IF OBJECT_ID('[data].[Coverages]', 'U') IS NOT NULL
    DROP TABLE [data].[Coverages];

IF OBJECT_ID('[data].[Studies]', 'U') IS NOT NULL
    DROP TABLE [data].[Studies];

IF OBJECT_ID('[data].[Valid_Studies]', 'U') IS NOT NULL
    DROP TABLE [data].[Valid_Studies];

IF OBJECT_ID('[data].[Patients]', 'U') IS NOT NULL
    DROP TABLE [data].[Patients];

IF OBJECT_ID('[data].[Users]', 'U') IS NOT NULL
    DROP TABLE [data].[Users];

IF OBJECT_ID('[data].[Medics]', 'U') IS NOT NULL
    DROP TABLE [data].[Medics];

IF OBJECT_ID('[data].[Medical_Appointment_Reservations]', 'U') IS NOT NULL
    DROP TABLE [data].[Medical_Appointment_Reservations];
GO


/* ------------------------------ Crear Tablas ------------------------------ */

CREATE TABLE [utilities].[Genders]
(
    [id_genero] INT IDENTITY (1, 1),
    [nombre] VARCHAR(50) NOT NULL
);

CREATE TABLE [utilities].[Countries]
(
    [gentilicio] VARCHAR(50) UNIQUE NOT NULL,
    [id_pais] INT IDENTITY (1, 1),
    [nombre] VARCHAR(50) NOT NULL
);

CREATE TABLE [utilities].[Provinces]
(
    [id_pais] INT,
    [id_provincia] INT IDENTITY (1, 1),
    [nombre] VARCHAR(50) NOT NULL
);

CREATE TABLE [utilities].[Localities]
(
    [id_localidad] INT IDENTITY (1, 1),
    [id_provincia] INT,
    [nombre] VARCHAR(50) NOT NULL
);

CREATE TABLE [utilities].[Addresses]
(
    [calle_y_nro] VARCHAR(50) NOT NULL,
    [cod_postal] SMALLINT,
    [departamento] SMALLINT,
    [id_direccion] INT IDENTITY (1, 1),
    [id_localidad] INT NOT NULL,
    [id_pais] INT,
    [id_provincia] INT NOT NULL,
    [piso] SMALLINT
);

CREATE TABLE [utilities].[Documents]
(
    [id_tipo_documento] INT IDENTITY (1, 1),
    [nombre] VARCHAR(50) NOT NULL
);

CREATE TABLE [utilities].[Nationalities]
(
    [id_nacionalidad] INT IDENTITY (1,1),
    [nombre] VARCHAR(50) NOT NULL
);

CREATE TABLE [data].[Patients]
(
    [apellido] VARCHAR (50) NOT NULL,
    [apellido_materno] VARCHAR (50),
    [email] VARCHAR (70) UNIQUE NOT NULL,
    [fecha_actualizacion] DATE,
    [fecha_nacimiento] DATE NOT NULL,
    [fecha_registro] DATE DEFAULT CAST(GETDATE () AS DATE),
    [foto_perfil] VARCHAR(128),
    [id_cobertura] INT,
    [id_direccion] INT,
    [id_genero] INT NOT NULL,
    [id_paciente] INT IDENTITY (1, 1),
    [id_tipo_documento] INT NOT NULL,
    [nacionalidad] INT,
    [nombre] VARCHAR (50) NOT NULL,
    [nro_documento] VARCHAR(50) NOT NULL,
    [sexo_biologico] CHAR(1),
    [tel_alternativo] VARCHAR(20),
    [tel_fijo] VARCHAR(20) NOT NULL,
    [tel_laboral] VARCHAR(20),
    [usuario_actualizacion] INT,
    [valido] BIT DEFAULT 1
);

CREATE TABLE [data].[Studies]
(
    [autorizado] BIT DEFAULT 1,
    [documento_resultado] VARCHAR (128),
    [fecha] DATE NOT NULL,
    [id_estudio] INT IDENTITY (1, 1),
    [id_paciente] INT,
    [imagen_resultado] VARCHAR (128),
    [nombre_estudio] VARCHAR(60) NOT NULL
);

CREATE TABLE [data].[Valid_Studies]
(
    [id_estudioValido] VARCHAR(255) NOT NULL,
    [area] NVARCHAR(255) NOT NULL,
    [estudio] NVARCHAR(255) NOT NULL ,
    [id_prestador] INT NOT NULL,
    [plan] NVARCHAR(255) NOT NULL,
    [porcentajeCobertura] INT NOT NULL,
    [costo] DECIMAL(18, 2) NOT NULL,
    [total] as (costo * (1 - CAST(porcentajeCobertura AS DECIMAL) / 100)),
    [requiereAutorizacion] BIT DEFAULT 0
);

CREATE TABLE [data].[Users]
(
    [contraseña] VARCHAR(256),
    [fecha_creacion] DATE DEFAULT CAST(GETDATE () AS DATE),
    [id_paciente] INT,
    [id_usuario] INT IDENTITY (1, 1),
);

CREATE TABLE [data].[Coverages]
(
    [fecha_registro] DATE DEFAULT CAST(GETDATE () AS DATE),
    [id_cobertura] INT IDENTITY (1, 1),
    [id_prestador] INT,
    [imagen_credencial] VARCHAR (128),
    [nro_socio] VARCHAR(30) NOT NULL,
    [borrado] BIT DEFAULT 0
);

CREATE TABLE [data].[Providers]
(
    [id_prestador] INT IDENTITY (1, 1),
    [nombre] VARCHAR(50) NOT NULL,
    [plan_prestador] VARCHAR(30) NOT NULL,
    [borrado] BIT DEFAULT 0
);

CREATE TABLE [data].[Medical_Appointment_Reservations]
(
    [fecha] DATE DEFAULT CAST (GETDATE () AS DATE),
    [hora] TIME DEFAULT CAST(GETDATE () AS TIME),
    [id_dias_x_sede] INT NOT NULL,
    [id_direccion_atencion] INT NOT NULL,
    [id_especialidad] INT NOT NULL,
    [id_estado_turno] INT NOT NULL,
    [id_medico] INT NOT NULL,
    [id_paciente] INT NOT NULL,
    [id_tipo_turno] INT NOT NULL,
    [id_turno] INT IDENTITY (1, 1)
);

CREATE TABLE [data].[Shift_Status]
(
    [id_estado] INT IDENTITY (1, 1),
    [nombre] CHAR (15)
);

CREATE TABLE [data].[Shifts]
(
    [id_tipo_turno] INT IDENTITY (1, 1),
    [nombre_tipo] CHAR (15)
);

CREATE TABLE [data].[Days_X_Headquarter]
(
	[id_dias_x_sede] INT IDENTITY(1,1),
    [alta] BIT DEFAULT 1,
    [dia] DATE NOT NULL,
    [hora_fin] TIME NOT NULL,
    [hora_inicio] TIME NOT NULL,
    [id_medico] INT NOT NULL,
    [id_sede] INT NOT NULL
);

CREATE TABLE [data].[Care_Headquarters]
(
    [direccion] INT,
    [id_sede] INT IDENTITY (1, 1),
    [nombre] VARCHAR(100) NOT NULL
);

CREATE TABLE [data].[Medics]
(
    [apellido] VARCHAR (50) NOT NULL,
    [id_especialidad] INT,
    [id_medico] INT IDENTITY (1, 1),
    [nombre] VARCHAR (50) NOT NULL,
    [nro_matricula] INT NOT NULL,
    [alta] BIT DEFAULT 1,
);

CREATE TABLE [data].[Specialties]
(
    [id_especialidad] INT IDENTITY (1, 1),
    [nombre] VARCHAR(50) NOT NULL
);