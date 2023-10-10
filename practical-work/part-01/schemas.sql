GO
USE [cure_sa];

GO
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'archivos')
BEGIN
    DROP SCHEMA [archivos];
END;

GO
CREATE SCHEMA [archivos];

GO
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'datos')
BEGIN
    DROP SCHEMA [datos];
END;

GO
CREATE SCHEMA [datos];

GO
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'referencias')
BEGIN
    DROP SCHEMA [referencias];
END;

GO
CREATE SCHEMA [referencias];