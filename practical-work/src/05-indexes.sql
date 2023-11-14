USE [CURESA];
GO


/* ---------------------------- Eliminar Índices ---------------------------- */

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_genero')
    DROP INDEX [index_id_genero] ON [referencias].[generos];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_pais')
    DROP INDEX [index_id_pais] ON [referencias].[paises];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_provincia')
    DROP INDEX [index_id_provincia] ON [referencias].[nombres_provincias];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_localidad')
    DROP INDEX [index_id_localidad] ON [referencias].[nombres_localidades];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_direccion')
    DROP INDEX [index_id_direccion] ON [referencias].[direcciones];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_tipo_documento')
    DROP INDEX [index_id_tipo_documento] ON [referencias].[tipos_documentos];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_nacionalidad')
    DROP INDEX [index_id_nacionalidad] ON [referencias].[nacionalidades];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_paciente')
    DROP INDEX [index_id_paciente] ON [datos].[pacientes];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_estudio')
    DROP INDEX [index_id_estudio] ON [datos].[estudios];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_estudioValido')
    DROP INDEX [index_id_estudioValido] ON [datos].[estudiosValidos];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_usuario')
    DROP INDEX [index_id_usuario] ON [datos].[usuarios];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_cobertura')
    DROP INDEX [index_id_cobertura] ON [datos].[coberturas];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_prestador')
    DROP INDEX [index_id_prestador] ON [datos].[prestadores];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_turno')
    DROP INDEX [index_id_turno] ON [datos].[reservas_turnos_medicos];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_estado')
    DROP INDEX [index_id_estado] ON [datos].[estados_turnos];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_tipo_turno')
    DROP INDEX [index_id_tipo_turno] ON [datos].[tipos_turnos];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_dias_x_sede')
    DROP INDEX [index_id_dias_x_sede] ON [datos].[dias_x_sede];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_sede')
    DROP INDEX [index_id_sede] ON [datos].[sede_de_atencion];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_medico')
    DROP INDEX [index_id_medico] ON [datos].[medicos];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_especialidad')
    DROP INDEX [index_id_especialidad] ON [datos].[especialidad];
GO


/* ------------------------------ Crear Índices ----------------------------- */

-- Géneros
CREATE INDEX [index_id_genero] ON [referencias].[generos] ([id_genero]);

-- Países
CREATE INDEX [index_id_pais] ON [referencias].[paises] ([id_pais]);

-- Provincias
CREATE INDEX [index_id_pais] ON [referencias].[nombres_provincias] ([id_pais]);

-- Localidades
CREATE INDEX [index_id_localidad] ON [referencias].[nombres_localidades] ([id_localidad]);

-- Direcciones
CREATE INDEX [index_id_direccion] ON [referencias].[direcciones] ([id_direccion]);

-- Documentos
CREATE INDEX [index_id_tipo_documento] ON [referencias].[tipos_documentos] ([id_tipo_documento]);

-- Nacionalidades
CREATE INDEX [index_id_nacionalidad] ON [referencias].[nacionalidades] ([id_nacionalidad]);

-- Pacientes
CREATE INDEX [index_id_paciente] ON [datos].[pacientes] ([id_paciente]);

-- Estudios
CREATE INDEX [index_id_estudio] ON [datos].[estudios] ([id_estudio]);

-- Estudios validos
CREATE INDEX [index_id_estudioValido] ON [datos].[estudiosValidos] ([id_estudioValido]);

-- Usuarios
CREATE INDEX [index_id_usuario] ON [datos].[usuarios] ([id_usuario]);

-- Coberturas
CREATE INDEX [index_id_cobertura] ON [datos].[coberturas] ([id_cobertura]);

-- Prestadores
CREATE INDEX [index_id_prestador] ON [datos].[prestadores] ([id_prestador]);

-- Reservas de turnos médicos
CREATE INDEX [index_id_turno] ON [datos].[reservas_turnos_medicos] ([id_turno]);

-- Estados de los turnos
CREATE INDEX [index_id_estado] ON [datos].[estados_turnos] ([id_estado]);

-- Tipos de turnos
CREATE INDEX [index_id_tipo_turno] ON [datos].[tipos_turnos] ([id_tipo_turno]);

-- Días x Sede
CREATE INDEX [index_id_dias_x_sede] ON [datos].[dias_x_sede] ([id_dias_x_sede]);

-- Sedes de atención
CREATE INDEX [index_id_sede] ON [datos].[sede_de_atencion] ([id_sede]);

-- Médicos
CREATE INDEX [index_id_medico] ON [datos].[medicos] ([id_medico]);

-- Especialidades
CREATE INDEX [index_id_especialidad] ON [datos].[especialidad] ([id_especialidad]);