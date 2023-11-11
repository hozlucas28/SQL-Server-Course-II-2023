GO
USE [CURESA];

-- Obtener el ID de un tipo de documento
GO
CREATE OR ALTER PROCEDURE [referencias].[obtenerOIsertarIdTipoDocumento]
    @nombre VARCHAR(50),
    @idTipo INT OUTPUT
AS
BEGIN
    SET @nombre = UPPER(TRIM(@nombre));

    IF NULLIF(@nombre, '') IS NULL
        SET @idTipo = -1;
    ELSE 
    BEGIN

        IF NOT EXISTS (SELECT 1 FROM [referencias].[tipos_documentos] WHERE nombre = @nombre) 
            INSERT INTO [referencias].[tipos_documentos] (nombre) VALUES (@nombre);
       
        SELECT @idTipo = id_tipo_documento FROM [referencias].[tipos_documentos] WHERE nombre = @nombre;
 
    END
END;

-- Actualizar/Insertar un tipo de documento
GO
CREATE OR ALTER PROCEDURE [referencias].[insertarTipoDocumento]
    @nombre VARCHAR(50) = 'null',
    @outIdTipoDocumento INT OUTPUT,
    @outNombre VARCHAR(50) OUTPUT
AS
BEGIN
    IF NULLIF(@nombre, '') IS NULL
        RETURN
        
    IF NOT EXISTS (SELECT 1 FROM [referencias].[tipos_documentos] WHERE nombre = @nombre) 
        INSERT INTO [referencias].[tipos_documentos] (nombre) VALUES (@nombre)
    ELSE
        UPDATE [referencias].[tipos_documentos] SET nombre = @nombre WHERE nombre = @nombre

    SELECT @outIdTipoDocumento = id_tipo_documento, @outNombre = nombre FROM [referencias].[tipos_documentos] WHERE nombre = @nombre
    RETURN
END;