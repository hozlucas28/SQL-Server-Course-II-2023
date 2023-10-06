go
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'cure_sa')
BEGIN
    USE [master];
    DROP DATABASE [cure_sa];
END;

CREATE DATABASE [cure_sa];

go
USE [cure_sa];