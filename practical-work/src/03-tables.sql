USE [CURESA];
GO


/* ----------------------------- Eliminar Tablas ---------------------------- */

IF OBJECT_ID('[utilities].[direcciones]', 'U') IS NOT NULL
    DROP TABLE [utilities].[direcciones];

IF OBJECT_ID('[utilities].[nombres_localidades]', 'U') IS NOT NULL
    DROP TABLE [utilities].[nombres_localidades];

IF OBJECT_ID('[utilities].[nombres_provincias]', 'U') IS NOT NULL
    DROP TABLE [utilities].[nombres_provincias];

IF OBJECT_ID('[utilities].[paises]', 'U') IS NOT NULL
    DROP TABLE [utilities].[paises];

IF OBJECT_ID('[utilities].[nacionalidades]', 'U') IS NOT NULL
    DROP TABLE [utilities].[nacionalidades];

IF OBJECT_ID('[utilities].[tipos_documentos]', 'U') IS NOT NULL
    DROP TABLE [utilities].[tipos_documentos];

IF OBJECT_ID('[utilities].[generos]', 'U') IS NOT NULL
    DROP TABLE [utilities].[generos];

IF OBJECT_ID('[data].[tipos_turnos]', 'U') IS NOT NULL
    DROP TABLE [data].[tipos_turnos];

IF OBJECT_ID('[data].[estados_turnos]', 'U') IS NOT NULL
    DROP TABLE [data].[estados_turnos];

IF OBJECT_ID('[data].[dias_x_sede]', 'U') IS NOT NULL
    DROP TABLE [data].[dias_x_sede];

IF OBJECT_ID('[data].[sede_de_atencion]', 'U') IS NOT NULL
    DROP TABLE [data].[sede_de_atencion];

IF OBJECT_ID('[data].[especialidad]', 'U') IS NOT NULL
    DROP TABLE [data].[especialidad];

IF OBJECT_ID('[data].[prestadores]', 'U') IS NOT NULL
    DROP TABLE [data].[prestadores];

IF OBJECT_ID('[data].[coberturas]', 'U') IS NOT NULL
    DROP TABLE [data].[coberturas];

IF OBJECT_ID('[data].[estudios]', 'U') IS NOT NULL
    DROP TABLE [data].[estudios];

IF OBJECT_ID('[data].[estudiosValidos]', 'U') IS NOT NULL
    DROP TABLE [data].[estudiosValidos];

IF OBJECT_ID('[data].[pacientes]', 'U') IS NOT NULL
    DROP TABLE [data].[pacientes];

IF OBJECT_ID('[data].[usuarios]', 'U') IS NOT NULL
    DROP TABLE [data].[usuarios];

IF OBJECT_ID('[data].[medicos]', 'U') IS NOT NULL
    DROP TABLE [data].[medicos];

IF OBJECT_ID('[data].[reservas_turnos_medicos]', 'U') IS NOT NULL
    DROP TABLE [data].[reservas_turnos_medicos];
GO


/* ------------------------------ Crear Tablas ------------------------------ */

CREATE TABLE [utilities].[generos]
(
    [id_genero] INT IDENTITY (1, 1),
    [nombre] VARCHAR(50) NOT NULL
);

CREATE TABLE [utilities].[paises]
(
    [gentilicio] VARCHAR(50) UNIQUE NOT NULL,
    [id_pais] INT IDENTITY (1, 1),
    [nombre] VARCHAR(50) NOT NULL
);

CREATE TABLE [utilities].[nombres_provincias]
(
    [id_pais] INT,
    [id_provincia] INT IDENTITY (1, 1),
    [nombre] VARCHAR(50) NOT NULL
);

CREATE TABLE [utilities].[nombres_localidades]
(
    [id_localidad] INT IDENTITY (1, 1),
    [id_provincia] INT,
    [nombre] VARCHAR(50) NOT NULL
);

CREATE TABLE [utilities].[direcciones]
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

CREATE TABLE [utilities].[tipos_documentos]
(
    [id_tipo_documento] INT IDENTITY (1, 1),
    [nombre] VARCHAR(50) NOT NULL
);

CREATE TABLE [utilities].[nacionalidades]
(
    [id_nacionalidad] INT IDENTITY (1,1),
    [nombre] VARCHAR(50) NOT NULL
);

CREATE TABLE [data].[pacientes]
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

CREATE TABLE [data].[estudios]
(
    [autorizado] BIT DEFAULT 1,
    [documento_resultado] VARCHAR (128),
    [fecha] DATE NOT NULL,
    [id_estudio] INT IDENTITY (1, 1),
    [id_paciente] INT,
    [imagen_resultado] VARCHAR (128),
    [nombre_estudio] VARCHAR(60) NOT NULL
);

CREATE TABLE [data].[estudiosValidos]
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

CREATE TABLE [data].[usuarios]
(
    [contraseña] VARCHAR(256),
    [fecha_creacion] DATE DEFAULT CAST(GETDATE () AS DATE),
    [id_paciente] INT,
    [id_usuario] INT IDENTITY (1, 1),
);

CREATE TABLE [data].[coberturas]
(
    [fecha_registro] DATE DEFAULT CAST(GETDATE () AS DATE),
    [id_cobertura] INT IDENTITY (1, 1),
    [id_prestador] INT,
    [imagen_credencial] VARCHAR (128),
    [nro_socio] VARCHAR(30) NOT NULL,
    [borrado] BIT DEFAULT 0
);

CREATE TABLE [data].[prestadores]
(
    [id_prestador] INT IDENTITY (1, 1),
    [nombre] VARCHAR(50) NOT NULL,
    [plan_prestador] VARCHAR(30) NOT NULL,
    [borrado] BIT DEFAULT 0
);

CREATE TABLE [data].[reservas_turnos_medicos]
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

CREATE TABLE [data].[estados_turnos]
(
    [id_estado] INT IDENTITY (1, 1),
    [nombre] CHAR (15)
);

CREATE TABLE [data].[tipos_turnos]
(
    [id_tipo_turno] INT IDENTITY (1, 1),
    [nombre_tipo] CHAR (15)
);

CREATE TABLE [data].[dias_x_sede]
(
	[id_dias_x_sede] INT IDENTITY(1,1),
    [alta] BIT DEFAULT 1,
    [dia] DATE NOT NULL,
    [hora_fin] TIME NOT NULL,
    [hora_inicio] TIME NOT NULL,
    [id_medico] INT NOT NULL,
    [id_sede] INT NOT NULL
);

CREATE TABLE [data].[sede_de_atencion]
(
    [direccion] INT,
    [id_sede] INT IDENTITY (1, 1),
    [nombre] VARCHAR(100) NOT NULL
);

CREATE TABLE [data].[medicos]
(
    [apellido] VARCHAR (50) NOT NULL,
    [id_especialidad] INT,
    [id_medico] INT IDENTITY (1, 1),
    [nombre] VARCHAR (50) NOT NULL,
    [nro_matricula] INT NOT NULL,
    [alta] BIT DEFAULT 1,
);

CREATE TABLE [data].[especialidad]
(
    [id_especialidad] INT IDENTITY (1, 1),
    [nombre] VARCHAR(50) NOT NULL
);