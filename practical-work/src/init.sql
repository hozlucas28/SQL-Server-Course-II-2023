USE [master];
GO

-- Ver processo activos de la base de datos
/*
    select * from sys.sysprocesses 
    where dbid = DB_ID('cure_sa')
*/

-- Ver conexiones(usuarios) a la base de datos
/*
    exec sp_who 
*/

-- Otra forma de saber si existe la base de datos
/*
    IF DB_ID('cure_sa') IS NOT NULL 
        DROP DATABASE [cure_sa]
*/

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'cure_sa')
    -- Eliminar todo tipo de conexiones que impidan borrar la base de datos
    ALTER DATABASE [cure_sa]
    SET SINGLE_USER
    WITH ROLLBACK IMMEDIATE
    GO

    DROP DATABASE [cure_sa];
GO

CREATE DATABASE [cure_sa]
    COLLATE Latin1_General_CS_AS;
GO

USE [cure_sa];