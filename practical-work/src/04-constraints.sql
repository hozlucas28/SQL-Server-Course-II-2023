USE [CURESA];
GO

/* --------------------------- Ver check constraints --------------------------- */

/*
SELECT
name, definition 
FROM
    sys.check_constraints
*/


/* --------------------------- Ver foreign keys --------------------------- */

/*
SELECT 
   OBJECT_NAME(f.parent_object_id) AS 'Table name',
   COL_NAME(fc.parent_object_id,fc.parent_column_id) AS 'Field name',
   delete_referential_action_desc AS 'On Delete'
FROM sys.foreign_keys AS f,
     sys.foreign_key_columns AS fc,
     sys.tables t 
WHERE f.OBJECT_ID = fc.constraint_object_id
AND t.OBJECT_ID = fc.referenced_object_id
ORDER BY 1
*/


/* --------------------------- Crear Restricciones --------------------------- */


-- Géneros
ALTER TABLE [referencias].[generos] ADD CONSTRAINT [pk_id_genero] PRIMARY KEY ([id_genero]);

-- Países
ALTER TABLE [referencias].[paises] ADD CONSTRAINT [pk_id_pais] PRIMARY KEY ([id_pais]);

ALTER TABLE [referencias].[nacionalidades] ADD CONSTRAINT [pk_id_nacionalidad] PRIMARY KEY ([id_nacionalidad]);

-- Tipos de documentos
ALTER TABLE [referencias].[tipos_documentos] ADD CONSTRAINT [pk_id_tipo_documento] PRIMARY KEY (id_tipo_documento);

-- Especialidad
ALTER TABLE [datos].[especialidad] ADD CONSTRAINT [pk_id_especialidad] PRIMARY KEY ([id_especialidad]);

-- Nombres de provincias
ALTER TABLE [referencias].[nombres_provincias] ADD CONSTRAINT [pk_id_provincia] PRIMARY KEY ([id_provincia]),
    CONSTRAINT [fk_id_pais_nombres_provincias] FOREIGN KEY ([id_pais]) REFERENCES [referencias].[paises] ([id_pais]);

-- Nombres de localidades
ALTER TABLE [referencias].[nombres_localidades] ADD CONSTRAINT [pk_id_localidad] PRIMARY KEY ([id_localidad]),
    CONSTRAINT [fk_id_provincia_localidades] FOREIGN KEY ([id_provincia]) REFERENCES [referencias].[nombres_provincias] ([id_provincia]) ;


-- Direcciones
ALTER TABLE [referencias].[direcciones] ADD CONSTRAINT [pk_id_direccion] PRIMARY KEY ([id_direccion]),
    CONSTRAINT [fk_id_pais_direcciones] FOREIGN KEY ([id_pais]) REFERENCES [referencias].[paises] ([id_pais]),
    CONSTRAINT [fk_id_provincia] FOREIGN KEY ([id_provincia]) REFERENCES [referencias].[nombres_provincias] ([id_provincia]),
    CONSTRAINT [fk_id_localidad] FOREIGN KEY ([id_localidad]) REFERENCES [referencias].[nombres_localidades] ([id_localidad]);

-- Prestadores
ALTER TABLE [datos].[prestadores] ADD CONSTRAINT pk_id_prestador PRIMARY KEY (id_prestador);

-- Coberturas
ALTER TABLE [datos].[coberturas] ADD CONSTRAINT [pk_id_cobertura] PRIMARY KEY ([id_cobertura]),
    CONSTRAINT [fk_id_prestador_coberturas] FOREIGN KEY ([id_prestador]) REFERENCES [datos].[prestadores] ([id_prestador]) ON DELETE CASCADE;

-- Pacientes
ALTER TABLE [datos].[pacientes] ADD CONSTRAINT [pk_id_paciente] PRIMARY KEY ([id_paciente]),
    CONSTRAINT [fk_id_cobertura_pacientes] FOREIGN KEY ([id_cobertura]) REFERENCES [datos].[coberturas] ([id_cobertura]),
    CONSTRAINT [fk_id_direccion_pacientes] FOREIGN KEY ([id_direccion]) REFERENCES [referencias].[direcciones] ([id_direccion]),
    CONSTRAINT [fk_id_tipo_documento] FOREIGN KEY ([id_tipo_documento]) REFERENCES [referencias].[tipos_documentos] ([id_tipo_documento]),
    CONSTRAINT [fk_id_genero] FOREIGN KEY ([id_genero]) REFERENCES [referencias].[generos] ([id_genero]),
    CONSTRAINT [fk_id_nacionalidad] FOREIGN KEY ([nacionalidad]) REFERENCES [referencias].[nacionalidades] ([id_nacionalidad]);

-- Estudios
ALTER TABLE [datos].[estudios] ADD CONSTRAINT [pk_id_estudio] PRIMARY KEY ([id_estudio]),
    CONSTRAINT [fk_id_paciente_estudio] FOREIGN KEY ([id_paciente]) REFERENCES [datos].[pacientes] ([id_paciente]);

-- Estudios Validos
ALTER TABLE [datos].[estudiosValidos] ADD CONSTRAINT [pk_id_estudioValido] PRIMARY KEY ([id_estudioValido]),
    CONSTRAINT [fk_id_prestador_estudioValido] FOREIGN KEY ([id_prestador]) REFERENCES [datos].[prestadores] ([id_prestador]);

-- Usuarios
ALTER TABLE [datos].[usuarios] ADD CONSTRAINT [pk_id_usuario] PRIMARY KEY ([id_usuario]),
    CONSTRAINT [fk_id_paciente_usuario] FOREIGN KEY ([id_paciente]) REFERENCES [datos].[pacientes] ([id_paciente]) ON DELETE CASCADE;

-- Sedes de atención
ALTER TABLE [datos].[sede_de_atencion] ADD CONSTRAINT [pk_id_medico_sede_de_atención] PRIMARY KEY ([id_sede]),
    CONSTRAINT [fk_id_direccion] FOREIGN KEY ([direccion]) REFERENCES [referencias].[direcciones] ([id_direccion]);

-- Médicos
ALTER TABLE [datos].[medicos] ADD CONSTRAINT [pk_id_medico] PRIMARY KEY ([id_medico]),
    CONSTRAINT [fk_id_especialidad] FOREIGN KEY ([id_especialidad]) REFERENCES [datos].[especialidad] ([id_especialidad]);

-- Días x Sede
ALTER TABLE [datos].[dias_x_sede] ADD CONSTRAINT [fk_id_medico] FOREIGN KEY ([id_medico]) REFERENCES [datos].[medicos] ([id_medico]),
    CONSTRAINT [fk_id_sede] FOREIGN KEY ([id_sede]) REFERENCES [datos].[sede_de_atencion] ([id_sede]),
    CONSTRAINT [pk_id_dias_x_sede] PRIMARY KEY ([id_dias_x_sede]);

-- Estados de los turnos
ALTER TABLE [datos].[estados_turnos] ADD CONSTRAINT [pk_id_estado_turno] PRIMARY KEY ([id_estado]),
    CONSTRAINT [check_nombre_estado_turno] CHECK (UPPER ([nombre]) IN ('ATENDIDO', 'AUSENTE', 'CANCELADO','PENDIENTE'));

-- Tipos de turnos
ALTER TABLE [datos].[tipos_turnos] ADD CONSTRAINT [pk_tipo_turno] PRIMARY KEY ([id_tipo_turno]),
    CONSTRAINT [check_nombre_tipo_turno] CHECK (UPPER ([nombre_tipo]) IN ('PRESENCIAL', 'VIRTUAL'));

-- Reservas de turnos médicos
ALTER TABLE [datos].[reservas_turnos_medicos] ADD CONSTRAINT [pk_id_turno] PRIMARY KEY ([id_turno]),
    CONSTRAINT [fk_id_tipo_turno] FOREIGN KEY ([id_tipo_turno]) REFERENCES [datos].[tipos_turnos] ([id_tipo_turno]),
    CONSTRAINT [fk_id_estado] FOREIGN KEY ([id_tipo_turno]) REFERENCES [datos].[estados_turnos] ([id_estado]),
    CONSTRAINT [fk_id_paciente_turno] FOREIGN KEY ([id_paciente]) REFERENCES [datos].[pacientes] ([id_paciente]),
    CONSTRAINT [fk_id_dias_x_sede] FOREIGN KEY ([id_dias_x_sede]) REFERENCES [datos].[dias_x_sede] ([id_dias_x_sede]);