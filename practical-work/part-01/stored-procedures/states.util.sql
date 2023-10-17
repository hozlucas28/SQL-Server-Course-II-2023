GO
USE [cure_sa];

-- Obtener el ID de una provincia -- TODO: se usa?
GO
CREATE OR ALTER PROCEDURE [referencias].[obtenerOInsertarIdProvincia]
    @Provincia VARCHAR(255),
	@IdProvincia INT OUTPUT
AS
BEGIN
    SET @provincia  = UPPER (@Provincia)
    IF NOT EXISTS (SELECT 1 FROM referencias.nombres_provincias WHERE nombre = @Provincia)
        INSERT INTO referencias.nombres_provincias (nombre) VALUES (@Provincia);

	SELECT @IdProvincia = id_provincia FROM referencias.nombres_provincias WHERE nombre = @Provincia;
END;

-- Actualizar/Insertar una provincia
GO
CREATE OR ALTER PROCEDURE [referencias].[actualizarProvincia]
    @provincia VARCHAR(50),
    @outIdPais INT OUTPUT,
    @outIdProvincia INT OUTPUT,
    @outNombre VARCHAR(50) OUTPUT
AS
BEGIN
    IF NULLIF(@provincia, '') IS NULL
        RETURN

    IF NOT EXISTS (SELECT 1 FROM [referencias].[nombres_provincias] WHERE nombre = UPPER(@provincia) COLLATE Latin1_General_CS_AS) 
        INSERT INTO [referencias].[nombres_provincias] (nombre) VALUES (UPPER(@provincia))

    SELECT @outIdPais = id_pais, @outIdProvincia = id_provincia, @outNombre = nombre FROM [referencias].[nombres_provincias] WHERE nombre = UPPER(@provincia) COLLATE Latin1_General_CS_AS
    RETURN
END;

