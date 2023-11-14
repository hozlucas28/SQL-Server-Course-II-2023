USE [CURESA];
GO


/* ----------------- Procedimientos Almacenados - Provincias ---------------- */

-- Obtener el ID de una provincia
CREATE OR ALTER PROCEDURE [referencias].[obtenerOInsertarIdProvincia]
    @provincia VARCHAR(255),
	@idProvincia INT OUTPUT
AS
BEGIN
    SET @provincia  = UPPER (@provincia)
    IF NOT EXISTS (SELECT 1 FROM [referencias].[nombres_provincias] WHERE [nombre] = @provincia)
        INSERT INTO [referencias].[nombres_provincias] ([nombre]) VALUES (@provincia)

	SELECT @idProvincia = [id_provincia] FROM [referencias].[nombres_provincias] WHERE [nombre] = @provincia
END;
GO

-- Actualizar/Insertar una provincia
CREATE OR ALTER PROCEDURE [referencias].[actualizarProvincias]
    @provincia VARCHAR(50),
    @outIdPais INT OUTPUT,
    @outIdProvincia INT OUTPUT,
    @outNombre VARCHAR(50) OUTPUT
AS
BEGIN
    IF NULLIF(@provincia, '') IS NULL
        RETURN

    IF NOT EXISTS (SELECT 1 FROM [referencias].[nombres_provincias] WHERE [nombre] = UPPER(@provincia)) 
        INSERT INTO [referencias].[nombres_provincias] ([nombre]) VALUES (UPPER(@provincia))

    SELECT @outIdPais = [id_pais], @outIdProvincia = [id_provincia], @outNombre = [nombre] FROM [referencias].[nombres_provincias] WHERE [nombre] = UPPER(@provincia)
END;