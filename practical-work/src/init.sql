USE [master];
GO

-- Ver processo activos de la base de datos
/*
    select * from sys.sysprocesses 
    where dbid = DB_ID('CURESA')
*/

-- Ver conexiones(usuarios) a la base de datos
/*
    exec sp_who 
*/

-- Otra forma de saber si existe la base de datos
/*
    IF DB_ID('CURESA') IS NOT NULL 
        DROP DATABASE [CURESA]
*/

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'CURESA')
    -- Eliminar todo tipo de conexiones que impidan borrar la base de datos
    ALTER DATABASE [CURESA]
    SET SINGLE_USER
    WITH ROLLBACK IMMEDIATE

    DROP DATABASE [CURESA]
GO

CREATE DATABASE [CURESA] COLLATE Latin1_General_CS_AS;
GO

USE [CURESA];