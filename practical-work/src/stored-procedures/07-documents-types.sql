USE [CURESA];
GO


/* ------------ Procedimientos Almacenados - Tipos De Documentos ------------ */

-- Obtener el ID de un tipo de documento
CREATE OR ALTER PROCEDURE [utilities].[obtenerOIsertarIdTipoDocumento]
    @nombre VARCHAR(50),
    @idTipo INT OUTPUT
AS
BEGIN
    SET @nombre = UPPER(TRIM(@nombre))

    IF NULLIF(@nombre, '') IS NULL
        SET @idTipo = -1
    ELSE 
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM [utilities].[Documents] WHERE [name] = @nombre) 
            INSERT INTO [utilities].[Documents] ([name]) VALUES (@nombre)
       
        SELECT @idTipo = [id] FROM [utilities].[Documents] WHERE [name] = @nombre
    END
END;
GO

-- Actualizar/Insertar un tipo de documento
CREATE OR ALTER PROCEDURE [utilities].[insertarTipoDocumento]
    @nombre VARCHAR(50) = 'null',
    @outIdTipoDocumento INT OUTPUT,
    @outNombre VARCHAR(50) OUTPUT
AS
BEGIN
    IF NULLIF(@nombre, '') IS NULL
        RETURN
        
    IF NOT EXISTS (SELECT 1 FROM [utilities].[Documents] WHERE [name] = @nombre) 
        INSERT INTO [utilities].[Documents] ([name]) VALUES (@nombre)
    ELSE
        UPDATE [utilities].[Documents] SET [name] = @nombre WHERE [name] = @nombre

    SELECT @outIdTipoDocumento = [id], @outNombre = [name] FROM [utilities].[Documents] WHERE [name] = @nombre
END;