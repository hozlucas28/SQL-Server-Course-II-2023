USE [CURESA];
GO


/* ---------------------------- Eliminar Índices ---------------------------- */

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_genero')
    DROP INDEX [index_id_genero] ON [utilities].[Genders];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_pais')
    DROP INDEX [index_id_pais] ON [utilities].[Countries];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_provincia')
    DROP INDEX [index_id_provincia] ON [utilities].[Provinces];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_localidad')
    DROP INDEX [index_id_localidad] ON [utilities].[Localities];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_direccion')
    DROP INDEX [index_id_direccion] ON [utilities].[Addresses];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_tipo_documento')
    DROP INDEX [index_id_tipo_documento] ON [utilities].[Documents];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index_id_nacionalidad')
    DROP INDEX [index_id_nacionalidad] ON [utilities].[Nationalities];


/* ------------------------------ Crear Índices ----------------------------- */

-- Géneros
CREATE INDEX [index_id_genero] ON [utilities].[Genders] ([id_genero]);

-- Países
CREATE INDEX [index_id_pais] ON [utilities].[Countries] ([id_pais]);

-- Provincias
CREATE INDEX [index_id_pais] ON [utilities].[Provinces] ([id_pais]);

-- Localidades
CREATE INDEX [index_id_localidad] ON [utilities].[Localities] ([id_localidad]);

-- Direcciones
CREATE INDEX [index_id_direccion] ON [utilities].[Addresses] ([id_direccion]);

-- Documentos
CREATE INDEX [index_id_tipo_documento] ON [utilities].[Documents] ([id_tipo_documento]);

-- Nacionalidades
CREATE INDEX [index_id_nacionalidad] ON [utilities].[Nationalities] ([id_nacionalidad]);

