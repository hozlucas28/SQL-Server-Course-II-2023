GO
USE [CURESA];

-- Obtener el ID de una especialidad
GO
CREATE OR ALTER FUNCTION [datos].[obtenerIdEspecialidad]
    (
        @nombre VARCHAR(50)
    ) RETURNS INT
AS
BEGIN
    DECLARE @id INT = -1
    SET @nombre = UPPER(TRIM(@nombre))

    IF NULLIF(@nombre, '') IS NULL
        RETURN @id

    IF NOT EXISTS (SELECT 1 FROM [datos].[especialidad] WHERE UPPER(TRIM(nombre)) = @nombre) 
        RETURN @id

    SELECT @id = id_especialidad FROM [datos].[especialidad] WHERE UPPER(TRIM(nombre)) = @nombre
    RETURN @id
END;

-- Actualizar/Insertar una especialidad
GO
CREATE OR ALTER PROCEDURE [datos].[guardarEspecialidad]
    @nombre VARCHAR(50) = 'null',
    @outIdEspecialidad INT OUTPUT
AS
BEGIN
    IF NULLIF(@nombre, '') IS NULL
            RETURN
        SET @nombre = UPPER(@nombre);
        IF NOT EXISTS (SELECT 1 FROM [datos].[especialidad] WHERE nombre = @nombre) 
            INSERT INTO [datos].[especialidad] (nombre) VALUES (@nombre)

        SELECT @outIdEspecialidad = id_especialidad FROM [datos].[especialidad] WHERE nombre = @nombre
        RETURN
END;