USE [CURESA];
GO


/* ------------------ Procedimientos Almacenados - Géneros ------------------ */

-- Obtener el ID de un género
CREATE OR ALTER PROCEDURE [utilities].[obtenerOInsertarIdGenero]
    @nombre VARCHAR(50) = 'null',
    @id INT OUTPUT 
AS
BEGIN
    SET @nombre = UPPER(TRIM(@nombre))

    IF NULLIF(@nombre, '') IS NULL
        SET @id = -1
    ELSE
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM [utilities].[Genders] WHERE UPPER(TRIM([name])) = @nombre) 
            INSERT INTO [utilities].[Genders] ([name]) VALUES (@nombre)

        SELECT @id = [id] FROM [utilities].[Genders] WHERE UPPER(TRIM([name])) = @nombre
    END
END;
GO

-- Actualizar/Insertar un género
CREATE OR ALTER PROCEDURE [utilities].[actualizarGenero]
    @nombre VARCHAR(50) = 'null',
    @outIdGenero INT OUTPUT,
    @outNombre VARCHAR(50) OUTPUT
AS
BEGIN
    IF NULLIF(@nombre, '') IS NULL
        RETURN
        
    IF NOT EXISTS (SELECT 1 FROM [utilities].[Genders] WHERE [name] = @nombre) 
        INSERT INTO [utilities].[Genders] ([name]) VALUES (@nombre)
    ELSE
        UPDATE [utilities].[Genders] SET [name] = @nombre WHERE [name] = @nombre

    SELECT @outIdGenero = [id], @outNombre = [name] FROM [utilities].[Genders] WHERE [name] = @nombre
END;