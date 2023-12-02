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
CREATE INDEX [INDEX_ID] ON [utilities].[Genders] ([id]);

-- Países
CREATE INDEX [INDEX_ID] ON [utilities].[Countries] ([id]);

-- Provincias
CREATE INDEX [INDEX_OF_PROVINCE_TO_COUNTRY_ID] ON [utilities].[Provinces] ([countryId]);

-- Localidades
CREATE INDEX [INDEX_ID] ON [utilities].[Localities] ([id]);

-- Direcciones
CREATE INDEX [INDEX_ID] ON [utilities].[Addresses] ([id]);

-- Documentos
CREATE INDEX [INDEX_ID] ON [utilities].[Documents] ([id]);

-- Nacionalidades
CREATE INDEX [INDEX_ID] ON [utilities].[Nationalities] ([id]);