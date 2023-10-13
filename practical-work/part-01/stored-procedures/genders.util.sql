GO
USE [cure_sa];

-- Obtener el ID de un género
GO
CREATE OR ALTER FUNCTION [referencias].[obtenerIdGenero]
    (
        @nombre VARCHAR(50) = 'null'
    ) RETURNS INT
AS
BEGIN
    DECLARE @id INT = -1
    SET @nombre = UPPER(TRIM(@nombre))

    IF NULLIF(@nombre, '') IS NULL
        RETURN @id

    IF NOT EXISTS (SELECT 1 FROM [referencias].[generos] WHERE UPPER(TRIM(nombre)) = @nombre COLLATE Latin1_General_CS_AS) 
        RETURN @id

    SELECT @id = id_genero FROM [referencias].[generos] WHERE UPPER(TRIM(nombre)) = @nombre
    RETURN @id
END;

-- Actualizar/Insertar un género
GO
CREATE OR ALTER PROCEDURE [referencias].[actualizarGenero]
    @nombre VARCHAR(50) = 'null',
    @outIdGenero INT OUTPUT,
    @outNombre VARCHAR(50) OUTPUT
AS
BEGIN
    IF NULLIF(@nombre, '') IS NULL
        RETURN
        
    IF NOT EXISTS (SELECT 1 FROM [referencias].[generos] WHERE nombre = @nombre COLLATE Latin1_General_CS_AS) 
        INSERT INTO [referencias].[generos] (nombre) VALUES (@nombre)
    ELSE
        UPDATE [referencias].[generos] SET nombre = @nombre WHERE nombre = @nombre COLLATE Latin1_General_CS_AS

    SELECT @outIdGenero = id_genero, @outNombre = nombre FROM [referencias].[generos] WHERE nombre = @nombre COLLATE Latin1_General_CS_AS
    RETURN
END;