GO
USE [cure_sa];

-- Obtener el ID de una provincia
GO
CREATE OR ALTER FUNCTION [referencias].[obtenerIdProvincia]
    (
        @provincia VARCHAR(50)
    ) RETURNS INT
AS
BEGIN
    DECLARE @idProvincia INT

    SELECT @idProvincia = id_provincia FROM [referencias].[nombres_provincias] WHERE nombre = @provincia
    RETURN @idProvincia
END;

-- Actualizar/Insertar una provincia
GO
CREATE OR ALTER FUNCTION [referencias].[actualizarProvincias]
    (
        @provincia VARCHAR(50)
    ) RETURNS @registro TABLE (
        id_pais INT NOT NULL,
        id_provincia INT,
        nombre VARCHAR(50) COLLATE Latin1_General_CS_AS NOT NULL
    )
AS
BEGIN
    IF NULLIF(@provincia, '') IS NULL
        RETURN

    IF NOT EXISTS (SELECT 1 FROM [referencias].[nombres_provincias] WHERE nombre = @provincia COLLATE Latin1_General_CS_AS) 
        INSERT INTO [referencias].[nombres_provincias] (nombre) VALUES (@provincia)
    ELSE
        UPDATE [referencias].[nombres_provincias] SET nombre = @provincia WHERE nombre = @provincia COLLATE Latin1_General_CS_AS

    INSERT INTO @registro SELECT id_pais, id_provincia, nombre FROM [referencias].[nombres_provincias] WHERE nombre = @provincia COLLATE Latin1_General_CS_AS
    RETURN
END;