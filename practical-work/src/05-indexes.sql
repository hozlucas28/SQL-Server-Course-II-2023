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

