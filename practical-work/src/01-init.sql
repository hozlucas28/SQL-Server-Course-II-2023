USE [master];
GO


/* ------------------------- Eliminar Base De Datos ------------------------- */

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'CURESA')
    ALTER DATABASE [CURESA] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE [CURESA]
GO


/* --------------------------- Crear Base De Datos -------------------------- */

CREATE DATABASE [CURESA] COLLATE Latin1_General_CS_AS;