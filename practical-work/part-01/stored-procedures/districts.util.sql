GO
USE [cure_sa];

-- Obtener el ID de una localidad
GO
CREATE OR ALTER FUNCTION [referencias].[obtenerIdLocalidad]
    (
        @localidad VARCHAR(50)
    ) RETURNS INT
AS
BEGIN
    DECLARE @IdLocalididad INT

    SELECT @IdLocalididad = id_localidad FROM [referencias].[nombres_localidades] WHERE nombre = @localidad

    RETURN @IdLocalididad
END;

-- Actualizar/Insertar una localidad
GO
CREATE OR ALTER FUNCTION [referencias].[insertarLocalidad]
    (
        @localidad VARCHAR(50) = 'null'
    ) RETURNS @registro TABLE (
        id_localidad INT,
        nombre VARCHAR(50) COLLATE Latin1_General_CS_AS NOT NULL
    )
AS
BEGIN
    IF NULLIF(@localidad, 'null') IS NULL
        RETURN
        
    IF NOT EXISTS (SELECT 1 FROM [referencias].[nombres_localidades] WHERE nombre = @localidad COLLATE Latin1_General_CS_AS) 
        INSERT INTO [referencias].[nombres_localidades] (nombre) VALUES (@localidad)
    ELSE
        UPDATE [referencias].[nombres_localidades] SET nombre = @localidad WHERE nombre = @localidad COLLATE Latin1_General_CS_AS

    INSERT INTO @registro SELECT id_localidad, nombre FROM [referencias].[nombres_localidades] WHERE nombre = @localidad COLLATE Latin1_General_CS_AS
    RETURN
END;