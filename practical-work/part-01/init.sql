GO
USE [master];

GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'cure_sa')
BEGIN
    DROP DATABASE [cure_sa];
END;

CREATE DATABASE [cure_sa];

GO
USE [cure_sa];