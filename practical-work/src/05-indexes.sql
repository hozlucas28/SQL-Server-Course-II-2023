USE [CURESA];
GO


/* ---------------------------- Eliminar Índices ---------------------------- */

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'INDEX_OF_GENDER_ID')
    DROP INDEX [INDEX_OF_GENDER_ID] ON [utilities].[Genders];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'INDEX_OF_COUNTRY_ID')
    DROP INDEX [INDEX_OF_COUNTRY_ID] ON [utilities].[Countries];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'INDEX_OF_PROVINCE_TO_COUNTRY_ID')
    DROP INDEX [INDEX_OF_PROVINCE_TO_COUNTRY_ID] ON [utilities].[Provinces];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'INDEX_OF_LOCALITY_ID')
    DROP INDEX [INDEX_OF_LOCALITY_ID] ON [utilities].[Localities];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'INDEX_OF_ADDRESS_ID')
    DROP INDEX [INDEX_OF_ADDRESS_ID] ON [utilities].[Addresses];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'INDEX_OF_DOCUMENT_ID')
    DROP INDEX [INDEX_OF_DOCUMENT_ID] ON [utilities].[Documents];

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'INDEX_OF_NATIONALITY_ID')
    DROP INDEX [INDEX_OF_NATIONALITY_ID] ON [utilities].[Nationalities];
GO


/* ------------------------------ Crear Índices ----------------------------- */

-- Géneros
CREATE INDEX [INDEX_OF_GENDER_ID] ON [utilities].[Genders] ([id]);

-- Países
CREATE INDEX [INDEX_OF_COUNTRY_ID] ON [utilities].[Countries] ([id]);

-- Provincias
CREATE INDEX [INDEX_OF_PROVINCE_TO_COUNTRY_ID] ON [utilities].[Provinces] ([countryId]);

-- Localidades
CREATE INDEX [INDEX_OF_LOCALITY_ID] ON [utilities].[Localities] ([id]);

-- Direcciones
CREATE INDEX [INDEX_OF_ADDRESS_ID] ON [utilities].[Addresses] ([id]);

-- Documentos
CREATE INDEX [INDEX_OF_DOCUMENT_ID] ON [utilities].[Documents] ([id]);

-- Nacionalidades
CREATE INDEX [INDEX_OF_NATIONALITY_ID] ON [utilities].[Nationalities] ([id]);