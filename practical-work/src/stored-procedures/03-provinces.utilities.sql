USE [CURESA];
GO


/* ----------------- Procedimientos Almacenados - Provincias ---------------- */

-- Obtener o insertar una provincia
CREATE OR ALTER PROCEDURE [utilities].[getOrInsertProvinceId]
	@outProvinceId INT OUTPUT,
    @provinceName VARCHAR(255)
AS
BEGIN
    SET @provinceName = UPPER(TRIM(@provinceName))
    IF NOT EXISTS (SELECT 1 FROM [utilities].[Provinces] WHERE UPPER(TRIM([name])) = @provinceName)
        INSERT INTO [utilities].[Provinces] ([name]) VALUES (@provinceName)

	SELECT @outProvinceId = [id] FROM [utilities].[Provinces] WHERE UPPER(TRIM([name])) = @provinceName
END;
GO

-- Actualizar o insertar una provincia
CREATE OR ALTER PROCEDURE [utilities].[updateOrInsertProvinces]
    @outCountryId INT OUTPUT,
    @outProvinceId INT OUTPUT,
    @provinceName VARCHAR(50) = 'null'
AS
BEGIN
    SET @provinceName = UPPER(TRIM(@provinceName))

    IF NULLIF(@provinceName, '') IS NULL
        RETURN

    IF NOT EXISTS (SELECT 1 FROM [utilities].[Provinces] WHERE UPPER(TRIM([name])) = @provinceName)
        INSERT INTO [utilities].[Provinces] ([name]) VALUES (@provinceName)

    SELECT @outCountryId = [countryId], @outProvinceId = [id] FROM [utilities].[Provinces] WHERE UPPER(TRIM([name])) = @provinceName
END;