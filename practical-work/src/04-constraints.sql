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
use curesa

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
ALTER TABLE [utilities].[generos] ADD CONSTRAINT [pk_id_genero] PRIMARY KEY ([id_genero]);

-- Países
ALTER TABLE [utilities].[paises] ADD CONSTRAINT [pk_id_pais] PRIMARY KEY ([id_pais]);

ALTER TABLE [utilities].[nacionalidades] ADD CONSTRAINT [pk_id_nacionalidad] PRIMARY KEY ([id_nacionalidad]);

-- Tipos de documentos
ALTER TABLE [utilities].[tipos_documentos] ADD CONSTRAINT [pk_id_tipo_documento] PRIMARY KEY (id_tipo_documento);

-- Especialidad
ALTER TABLE [data].[especialidad] ADD CONSTRAINT [pk_id_especialidad] PRIMARY KEY ([id_especialidad]);

-- Nombres de provincias
ALTER TABLE [utilities].[nombres_provincias] ADD CONSTRAINT [pk_id_provincia] PRIMARY KEY ([id_provincia]),
    CONSTRAINT [fk_id_pais_nombres_provincias] FOREIGN KEY ([id_pais]) REFERENCES [utilities].[paises] ([id_pais]);

-- Nombres de localidades
ALTER TABLE [utilities].[nombres_localidades] ADD CONSTRAINT [pk_id_localidad] PRIMARY KEY ([id_localidad]),
    CONSTRAINT [fk_id_provincia_localidades] FOREIGN KEY ([id_provincia]) REFERENCES [utilities].[nombres_provincias] ([id_provincia]) ;


-- Direcciones
ALTER TABLE [utilities].[direcciones] ADD CONSTRAINT [pk_id_direccion] PRIMARY KEY ([id_direccion]),
    CONSTRAINT [fk_id_pais_direcciones] FOREIGN KEY ([id_pais]) REFERENCES [utilities].[paises] ([id_pais]),
    CONSTRAINT [fk_id_provincia] FOREIGN KEY ([id_provincia]) REFERENCES [utilities].[nombres_provincias] ([id_provincia]),
    CONSTRAINT [fk_id_localidad] FOREIGN KEY ([id_localidad]) REFERENCES [utilities].[nombres_localidades] ([id_localidad]);

-- Prestadores
ALTER TABLE [data].[prestadores] ADD CONSTRAINT pk_id_prestador PRIMARY KEY (id_prestador);

-- Coberturas
ALTER TABLE [data].[coberturas] ADD CONSTRAINT [pk_id_cobertura] PRIMARY KEY ([id_cobertura]),
    CONSTRAINT [fk_id_prestador_coberturas] FOREIGN KEY ([id_prestador]) REFERENCES [data].[prestadores] ([id_prestador]);

-- Pacientes
ALTER TABLE [data].[pacientes] ADD CONSTRAINT [pk_id_paciente] PRIMARY KEY ([id_paciente]),
    CONSTRAINT [fk_id_cobertura_pacientes] FOREIGN KEY ([id_cobertura]) REFERENCES [data].[coberturas] ([id_cobertura]),
    CONSTRAINT [fk_id_direccion_pacientes] FOREIGN KEY ([id_direccion]) REFERENCES [utilities].[direcciones] ([id_direccion]),
    CONSTRAINT [fk_id_tipo_documento] FOREIGN KEY ([id_tipo_documento]) REFERENCES [utilities].[tipos_documentos] ([id_tipo_documento]),
    CONSTRAINT [fk_id_genero] FOREIGN KEY ([id_genero]) REFERENCES [utilities].[generos] ([id_genero]),
    CONSTRAINT [fk_id_nacionalidad] FOREIGN KEY ([nacionalidad]) REFERENCES [utilities].[nacionalidades] ([id_nacionalidad]);

-- Estudios
ALTER TABLE [data].[estudios] ADD CONSTRAINT [pk_id_estudio] PRIMARY KEY ([id_estudio]),
    CONSTRAINT [fk_id_paciente_estudio] FOREIGN KEY ([id_paciente]) REFERENCES [data].[pacientes] ([id_paciente]);

-- Estudios Validos
ALTER TABLE [data].[estudiosValidos] ADD CONSTRAINT [pk_id_estudioValido] PRIMARY KEY ([id_estudioValido]),
    CONSTRAINT [fk_id_prestador_estudioValido] FOREIGN KEY ([id_prestador]) REFERENCES [data].[prestadores] ([id_prestador]);

-- Usuarios
ALTER TABLE [data].[usuarios] ADD CONSTRAINT [pk_id_usuario] PRIMARY KEY ([id_usuario]),
    CONSTRAINT [fk_id_paciente_usuario] FOREIGN KEY ([id_paciente]) REFERENCES [data].[pacientes] ([id_paciente]) ON DELETE CASCADE;

-- Sedes de atención
ALTER TABLE [data].[sede_de_atencion] ADD CONSTRAINT [pk_id_medico_sede_de_atención] PRIMARY KEY ([id_sede]),
    CONSTRAINT [fk_id_direccion] FOREIGN KEY ([direccion]) REFERENCES [utilities].[direcciones] ([id_direccion]);

-- Médicos
ALTER TABLE [data].[medicos] ADD CONSTRAINT [pk_id_medico] PRIMARY KEY ([id_medico]),
    CONSTRAINT [fk_id_especialidad] FOREIGN KEY ([id_especialidad]) REFERENCES [data].[especialidad] ([id_especialidad]);

-- Días x Sede
ALTER TABLE [data].[dias_x_sede] ADD CONSTRAINT [fk_id_medico] FOREIGN KEY ([id_medico]) REFERENCES [data].[medicos] ([id_medico]),
    CONSTRAINT [fk_id_sede] FOREIGN KEY ([id_sede]) REFERENCES [data].[sede_de_atencion] ([id_sede]),
    CONSTRAINT [pk_id_dias_x_sede] PRIMARY KEY ([id_dias_x_sede]);

-- Estados de los turnos
ALTER TABLE [data].[estados_turnos] ADD CONSTRAINT [pk_id_estado_turno] PRIMARY KEY ([id_estado]),
    CONSTRAINT [check_nombre_estado_turno] CHECK (UPPER ([nombre]) IN ('ATENDIDO', 'AUSENTE', 'CANCELADO','PENDIENTE'));

-- Tipos de turnos
ALTER TABLE [data].[tipos_turnos] ADD CONSTRAINT [pk_tipo_turno] PRIMARY KEY ([id_tipo_turno]),
    CONSTRAINT [check_nombre_tipo_turno] CHECK (UPPER ([nombre_tipo]) IN ('PRESENCIAL', 'VIRTUAL'));

-- Reservas de turnos médicos
ALTER TABLE [data].[reservas_turnos_medicos] ADD CONSTRAINT [pk_id_turno] PRIMARY KEY ([id_turno]),
    CONSTRAINT [fk_id_tipo_turno] FOREIGN KEY ([id_tipo_turno]) REFERENCES [data].[tipos_turnos] ([id_tipo_turno]),
    CONSTRAINT [fk_id_estado] FOREIGN KEY ([id_tipo_turno]) REFERENCES [data].[estados_turnos] ([id_estado]),
    CONSTRAINT [fk_id_paciente_turno] FOREIGN KEY ([id_paciente]) REFERENCES [data].[pacientes] ([id_paciente]),
    CONSTRAINT [fk_id_dias_x_sede] FOREIGN KEY ([id_dias_x_sede]) REFERENCES [data].[dias_x_sede] ([id_dias_x_sede]);