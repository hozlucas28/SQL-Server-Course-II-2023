USE [CURESA];
GO


/* ----------------- Procedimientos Almacenados - Provincias ---------------- */

-- Obtener el ID de una provincia
CREATE OR ALTER PROCEDURE [utilities].[obtenerOInsertarIdProvincia]
    @provincia VARCHAR(255),
	@idProvincia INT OUTPUT
AS
BEGIN
    SET @provincia  = UPPER (@provincia)
    IF NOT EXISTS (SELECT 1 FROM [utilities].[Provinces] WHERE [name] = @provincia)
        INSERT INTO [utilities].[Provinces] ([name]) VALUES (@provincia)

	SELECT @idProvincia = [id] FROM [utilities].[Provinces] WHERE [name] = @provincia
END;
GO

-- Actualizar/Insertar una provincia
CREATE OR ALTER PROCEDURE [utilities].[actualizarProvincias]
    @provincia VARCHAR(50),
    @outIdPais INT OUTPUT,
    @outIdProvincia INT OUTPUT,
    @outNombre VARCHAR(50) OUTPUT
AS
BEGIN
    IF NULLIF(@provincia, '') IS NULL
        RETURN

    IF NOT EXISTS (SELECT 1 FROM [utilities].[Provinces] WHERE [name] = UPPER(@provincia)) 
        INSERT INTO [utilities].[Provinces] ([name]) VALUES (UPPER(@provincia))

    SELECT @outIdPais = [countryId], @outIdProvincia = [id], @outNombre = [name] FROM [utilities].[Provinces] WHERE [name] = UPPER(@provincia)
END;