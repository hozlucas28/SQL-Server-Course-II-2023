GO
USE [cure_sa];

-- Obtener el ID de un tipo de documento
GO
CREATE OR ALTER FUNCTION [referencias].[obtenerIdTipoDocumento]
	(
        @tipo VARCHAR(50)
    ) RETURNS INT
AS
BEGIN
    DECLARE @idTipo INT
    SET @tipo = UPPER(TRIM(@tipo))
	
    SELECT @idTipo = id_tipo_documento FROM [referencias].[tipos_documentos] WHERE UPPER(TRIM(nombre)) = UPPER(TRIM(@tipo))

    RETURN @idTipo
END;

-- Actualizar/Insertar un tipo de documento
GO
CREATE OR ALTER FUNCTION [referencias].[insertarTipoDocumento]
    (
        @nombre VARCHAR(50) = 'null'
    ) RETURNS @registro TABLE (
        id_tipo_documento INT,
        nombre VARCHAR(50) COLLATE Latin1_General_CS_AS NOT NULL
    )
AS
BEGIN
    IF NULLIF(@nombre, '') IS NULL
        RETURN
        
    IF NOT EXISTS (SELECT 1 FROM [referencias].[tipos_documentos] WHERE nombre = @nombre COLLATE Latin1_General_CS_AS) 
        INSERT INTO [referencias].[tipos_documentos] (nombre) VALUES (@nombre)
    ELSE
        UPDATE [referencias].[tipos_documentos] SET nombre = @nombre WHERE nombre = @nombre COLLATE Latin1_General_CS_AS

    INSERT INTO @registro SELECT id_tipo_documento, nombre FROM [referencias].[tipos_documentos] WHERE nombre = @nombre COLLATE Latin1_General_CS_AS
    RETURN
END;