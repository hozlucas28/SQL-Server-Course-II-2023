GO
USE [cure_sa];

-- Obtener el ID de una especialidad
GO
CREATE OR ALTER FUNCTION [datos].[obtenerIdEspecialidad]
    (
        @nombre VARCHAR(50) = 'null'
    ) RETURNS INT
AS
BEGIN
    DECLARE @id INT = -1
    SET @nombre = UPPER(TRIM(@nombre))

    IF NULLIF(@nombre, '') IS NULL
        RETURN @id

    IF NOT EXISTS (SELECT 1 FROM [datos].[especialidad] WHERE UPPER(TRIM(nombre)) = @nombre COLLATE Latin1_General_CS_AS) 
        RETURN @id

    SELECT @id = id_especialidad FROM [datos].[especialidad] WHERE UPPER(TRIM(nombre)) = @nombre
    RETURN @id
END;

-- Actualizar/Insertar una especialidad
GO
CREATE OR ALTER PROCEDURE [datos].[actualizarEspecialidad]
    @nombre VARCHAR(50) = 'null',
    @outIdEspecialidad INT OUTPUT,
    @outNombre VARCHAR(50) OUTPUT
AS
BEGIN
    IF NULLIF(@nombre, '') IS NULL
            RETURN
        
        IF NOT EXISTS (SELECT 1 FROM [datos].[especialidad] WHERE nombre = @nombre COLLATE Latin1_General_CS_AS) 
            INSERT INTO [datos].[especialidad] (nombre) VALUES (@nombre)
        ELSE
            UPDATE [datos].[especialidad] SET nombre = @nombre WHERE nombre = @nombre COLLATE Latin1_General_CS_AS

        SELECT @outIdEspecialidad = id_especialidad, @outNombre = nombre FROM [datos].[especialidad] WHERE nombre = @nombre COLLATE Latin1_General_CS_AS
        RETURN
END;