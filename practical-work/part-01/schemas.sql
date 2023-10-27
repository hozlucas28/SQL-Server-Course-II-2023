USE [cure_sa];
GO

-- DROP SCHEMA

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'archivos')
    DROP SCHEMA [archivos];
GO

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'datos')
    DROP SCHEMA [datos];
GO

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'referencias')
    DROP SCHEMA [referencias];
GO

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'utils')
    DROP SCHEMA [utils]
GO

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'vistasPacientes')
    DROP SCHEMA [vistasPacientes]
GO

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'vistasMedicos')
    DROP SCHEMA [vistasMedicos]
GO

-- CREATE SCHEMA

CREATE SCHEMA [utils];
GO

CREATE SCHEMA [referencias];
GO

CREATE SCHEMA [datos];
GO

CREATE SCHEMA [archivos];
GO

CREATE SCHEMA [vistasPacientes]
GO

CREATE SCHEMA [vistasMedicos]
GO