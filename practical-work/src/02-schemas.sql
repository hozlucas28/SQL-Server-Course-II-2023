USE [CURESA];
GO


/* ---------------------------- Eliminar Esquemas --------------------------- */

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'archivos')
    DROP SCHEMA [archivos];

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'datos')
    DROP SCHEMA [datos];

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'referencias')
    DROP SCHEMA [referencias];

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'utils')
    DROP SCHEMA [utils]
GO


/* ----------------------------- Crear Esquemas ----------------------------- */

CREATE SCHEMA [archivos];
GO

CREATE SCHEMA [datos];
GO

CREATE SCHEMA [referencias];
GO

CREATE SCHEMA [utils];