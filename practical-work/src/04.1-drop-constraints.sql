USE [CURESA];
GO

-- Estudios
ALTER TABLE [datos].[estudios] DROP CONSTRAINT [pk_id_estudio],
    CONSTRAINT [fk_id_paciente_estudio];

-- Usuarios
ALTER TABLE [datos].[usuarios] DROP CONSTRAINT [pk_id_usuario],
    CONSTRAINT [fk_id_paciente_usuario];

-- Pacientes
ALTER TABLE [datos].[pacientes] DROP CONSTRAINT [pk_id_paciente],
    CONSTRAINT [fk_id_cobertura_pacientes],
    CONSTRAINT [fk_id_direccion_pacientes],
    CONSTRAINT [fk_id_tipo_documento],
    CONSTRAINT [fk_id_genero],
    CONSTRAINT [fk_id_nacionalidad];

-- Reservas de turnos médicos
ALTER TABLE [datos].[reservas_turnos_medicos] DROP CONSTRAINT [pk_id_turno],
    CONSTRAINT [fk_id_tipo_turno],
    CONSTRAINT [fk_id_estado],
    CONSTRAINT [fk_id_paciente_turno],
    CONSTRAINT [fk_id_dias_x_sede];

-- Días x Sede
ALTER TABLE [datos].[dias_x_sede] DROP CONSTRAINT [fk_id_medico],
    CONSTRAINT [fk_id_sede],
    CONSTRAINT [pk_id_dias_x_sede];

-- Médicos
ALTER TABLE [datos].[medicos] DROP CONSTRAINT [pk_id_medico],
    CONSTRAINT [fk_id_especialidad];

-- Especialidad
ALTER TABLE [datos].[especialidad] DROP CONSTRAINT [pk_id_especialidad];

-- Tipos de documentos
ALTER TABLE [referencias].[tipos_documentos] DROP CONSTRAINT [pk_id_tipo_documento];

-- Nacionalidades
ALTER TABLE [referencias].[nacionalidades] DROP CONSTRAINT [pk_id_nacionalidad];

-- Países
ALTER TABLE [referencias].[paises] DROP CONSTRAINT [pk_id_pais];

-- Géneros
ALTER TABLE [referencias].[generos] DROP CONSTRAINT [pk_id_genero];

-- Nombres de provincias
ALTER TABLE [referencias].[nombres_provincias] DROP CONSTRAINT [pk_id_provincia],
    CONSTRAINT [fk_id_pais_nombres_provincias];

-- Nombres de localidades
ALTER TABLE [referencias].[nombres_localidades] DROP CONSTRAINT [pk_id_localidad],
    CONSTRAINT [fk_id_provincia_localidades];

-- Direcciones
ALTER TABLE [referencias].[direcciones] DROP CONSTRAINT [pk_id_direccion],
    CONSTRAINT [fk_id_pais_direcciones],
    CONSTRAINT [fk_id_provincia],
    CONSTRAINT [fk_id_localidad];

-- Prestadores
ALTER TABLE [datos].[prestadores] DROP CONSTRAINT [pk_id_prestador];

-- Coberturas
ALTER TABLE [datos].[coberturas] DROP CONSTRAINT [pk_id_cobertura],
    CONSTRAINT [fk_id_prestador_coberturas];

-- Estudios Validos
ALTER TABLE [datos].[estudiosValidos] DROP CONSTRAINT [pk_id_estudioValido],
    CONSTRAINT [fk_id_prestador_estudioValido];

-- Sedes de atención
ALTER TABLE [datos].[sede_de_atencion] DROP CONSTRAINT [pk_id_medico_sede_de_atención],
    CONSTRAINT [fk_id_direccion];

-- Estados de los turnos
ALTER TABLE [datos].[estados_turnos] DROP CONSTRAINT [pk_id_estado_turno],
    CONSTRAINT [check_nombre_estado_turno];

-- Tipos de turnos
ALTER TABLE [datos].[tipos_turnos] DROP CONSTRAINT [pk_tipo_turno],
    CONSTRAINT [check_nombre_tipo_turno];