USE [CURESA];
GO


/* ---------------------------- Eliminar Esquemas --------------------------- */

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'files')
    DROP SCHEMA [files];

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'data')
    DROP SCHEMA [data];

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'utilities')
    DROP SCHEMA [utilities];
GO


/* ----------------------------- Crear Esquemas ----------------------------- */

CREATE SCHEMA [files];
GO

CREATE SCHEMA [data];
GO

CREATE SCHEMA [utilities];