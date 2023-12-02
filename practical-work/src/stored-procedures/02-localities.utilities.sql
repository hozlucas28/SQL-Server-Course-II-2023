USE [CURESA];
GO


/* ---------------- Procedimientos Almacenados - Localidades ---------------- */

-- Obtener o insertar una localidad
CREATE OR ALTER PROCEDURE [utilities].[getOrInsertLocalityId]
	@outLocalityId INT OUTPUT,
	@provinceId INT,
    @localityName VARCHAR(255)
AS
BEGIN
    SET @localityName = UPPER(TRIM(@localityName))

    IF NOT EXISTS (SELECT 1 FROM [utilities].[Localities] WHERE [provinceId] = @provinceId AND UPPER(TRIM([name])) = @localityName)
        INSERT INTO [utilities].[Localities] ([name], [provinceId]) VALUES (@localityName, @provinceId)

	SELECT @outLocalityId = [id] FROM [utilities].[Localities] WHERE [provinceId] = @provinceId AND UPPER(TRIM([name])) = @localityName
END;
GO

-- Actualizar o insertar una localidad
CREATE OR ALTER PROCEDURE [utilities].[updateOrInsertLocality]
    @localityName VARCHAR(50) = 'null',
    @outLocalityId INT OUTPUT
AS
BEGIN
    SET @localityName = UPPER(TRIM(@localityName))

    IF NULLIF(@localityName, 'null') IS NULL
        RETURN
        
    IF NOT EXISTS (SELECT 1 FROM [utilities].[Localities] WHERE UPPER(TRIM([name])) = @localityName)
        INSERT INTO [utilities].[Localities] ([name]) VALUES (@localityName)
    ELSE
        UPDATE [utilities].[Localities] SET [name] = @localityName WHERE UPPER(TRIM([name])) = @localityName

    SELECT @outLocalityId = [id] FROM [utilities].[Localities] WHERE UPPER(TRIM([name])) = @localityName
END;