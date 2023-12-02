USE [CURESA];
GO


/* ------------------- Procedimientos Almacenados - Países ------------------ */

-- Obtener o insertar una nacionalidad
CREATE OR ALTER PROCEDURE [utilities].[getOrInsertNationalityId]
    @nationalityName VARCHAR(50) = NULL,
    @outNationalityId INT OUTPUT
AS
BEGIN
    SET @nationalityName = UPPER(TRIM(@nationalityName))

    IF NULLIF(@nationalityName, '') IS NULL
        SET @outNationalityId = -1
    ELSE
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM [utilities].[Nationalities] WHERE UPPER(TRIM([name])) = @nationalityName) 
            INSERT INTO [utilities].[Nationalities] ([name]) VALUES (@nationalityName)

        SELECT @outNationalityId = [id] FROM [utilities].[Nationalities] WHERE UPPER(TRIM([name])) = @nationalityName
    END
END;
GO

-- Actualizar o insertar una nacionalidad
CREATE OR ALTER PROCEDURE [utilities].[updateOrInsertNationality]
    @countryName VARCHAR(50) = NULL,
    @nationalityDemonym VARCHAR(50) = NULL,
    @outCountryId INT OUTPUT
AS
BEGIN
    SET @countryName = UPPER(TRIM(@countryName))
    SET @nationalityDemonym = UPPER(TRIM(@nationalityDemonym))

    IF NULLIF(@nationalityDemonym, '') IS NULL
        RETURN

    IF NOT EXISTS (SELECT 1 FROM [utilities].[Countries] WHERE UPPER(TRIM([demonym])) = @nationalityDemonym) 
        IF NULLIF(@countryName, '') IS NULL
            RETURN
        ELSE
            INSERT INTO [utilities].[Countries] ([name], [demonym]) VALUES (@countryName, @nationalityDemonym)
    ELSE
        UPDATE [utilities].[Countries] SET [demonym] = @nationalityDemonym WHERE UPPER(TRIM([demonym])) = @nationalityDemonym

    SELECT @outCountryId = [id] FROM [utilities].[Countries] WHERE UPPER(TRIM([demonym])) = @nationalityDemonym
END;