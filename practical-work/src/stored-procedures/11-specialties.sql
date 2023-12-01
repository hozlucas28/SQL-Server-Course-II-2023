USE [CURESA];
GO


/* --------------- Procedimientos Almacenados - Especialidades -------------- */

-- Obtener el ID de una especialidad
GO
CREATE OR ALTER FUNCTION [data].[obtenerIdEspecialidad]
    (
        @nombre VARCHAR(50)
    ) RETURNS INT
AS
BEGIN
    DECLARE @id INT = -1
    SET @nombre = UPPER(TRIM(@nombre))

    IF NULLIF(@nombre, '') IS NULL
        RETURN @id

    IF NOT EXISTS (SELECT 1 FROM [data].[especialidad] WHERE UPPER(TRIM([nombre])) = @nombre) 
        RETURN @id

    SELECT @id = [id_especialidad] FROM [data].[especialidad] WHERE UPPER(TRIM([nombre])) = @nombre
    RETURN @id
END;
GO

-- Actualizar/Insertar una especialidad
CREATE OR ALTER PROCEDURE [data].[guardarEspecialidad]
    @nombre VARCHAR(50) = 'null',
    @outIdEspecialidad INT OUTPUT
AS
BEGIN
    IF NULLIF(@nombre, '') IS NULL
            RETURN
        SET @nombre = UPPER(@nombre)
        IF NOT EXISTS (SELECT 1 FROM [data].[especialidad] WHERE [nombre] = @nombre) 
            INSERT INTO [data].[especialidad] ([nombre]) VALUES (@nombre)

        SELECT @outIdEspecialidad = [id_especialidad] FROM [data].[especialidad] WHERE [nombre] = @nombre
END;