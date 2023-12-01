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
        IF NOT EXISTS (SELECT 1 FROM [utilities].[generos] WHERE UPPER(TRIM([nombre])) = @nombre) 
            INSERT INTO [utilities].[generos] ([nombre]) VALUES (@nombre)

        SELECT @id = [id_genero] FROM [utilities].[generos] WHERE UPPER(TRIM([nombre])) = @nombre
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
        
    IF NOT EXISTS (SELECT 1 FROM [utilities].[generos] WHERE [nombre] = @nombre) 
        INSERT INTO [utilities].[generos] ([nombre]) VALUES (@nombre)
    ELSE
        UPDATE [utilities].[generos] SET [nombre] = @nombre WHERE [nombre] = @nombre

    SELECT @outIdGenero = [id_genero], @outNombre = [nombre] FROM [utilities].[generos] WHERE [nombre] = @nombre
END;