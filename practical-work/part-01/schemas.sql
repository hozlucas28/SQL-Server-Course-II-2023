USE [cure_sa];
GO

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'archivos')
    DROP SCHEMA [archivos];
GO

CREATE SCHEMA [archivos];
GO

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'datos')
    DROP SCHEMA [datos];
GO

CREATE SCHEMA [datos];
GO

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'referencias')
    DROP SCHEMA [referencias];
GO

CREATE SCHEMA [referencias];
GO

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'utils')
    DROP SCHEMA [utils]
GO

CREATE SCHEMA [utils];