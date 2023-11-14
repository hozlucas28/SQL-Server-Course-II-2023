USE [master];
GO

-- Ver procesos activos de la base de datos
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


/* ------------------------- Eliminar Base De Datos ------------------------- */

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'CURESA')
    ALTER DATABASE [CURESA] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE [CURESA]
GO


/* --------------------------- Crear Base De Datos -------------------------- */

CREATE DATABASE [CURESA] COLLATE Latin1_General_CS_AS;