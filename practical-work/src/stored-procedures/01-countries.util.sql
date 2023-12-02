USE [CURESA];
GO


/* ------------------- Procedimientos Almacenados - Países ------------------ */

-- Obtener el ID de una nacionalidad
CREATE OR ALTER PROCEDURE [utilities].[getOrInsertNationalityId]
    @nationality VARCHAR(50) = NULL,
    @id INT OUTPUT
AS
BEGIN
    SET @nationality = UPPER(TRIM(@nationality))

    IF NULLIF(@nationality, '') IS NULL
        SET @id = -1
    ELSE
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM [utilities].[Nationalities] WHERE UPPER(TRIM([name])) = @nationality) 
            INSERT INTO [utilities].[Nationalities] ([name]) VALUES (@nationality)

        SELECT @id = [id] FROM [utilities].[Nationalities] WHERE UPPER(TRIM([name])) = @nationality
    END
END;
GO

-- Actualizar/Insertar una nacionalidad
CREATE OR ALTER PROCEDURE [utilities].[updateNationality]
    @country VARCHAR(50) = NULL,
    @nationality VARCHAR(50) = NULL,
    @outDemonym VARCHAR(50) OUTPUT,
    @outCountryId INT OUTPUT,
    @outName VARCHAR(50) OUTPUT
AS
BEGIN
    IF NULLIF(@nationality, '') IS NULL
        RETURN

    IF NOT EXISTS (SELECT 1 FROM [utilities].[Countries] WHERE [demonym] = @nationality) 
        IF NULLIF(@country, '') IS NULL
            RETURN
        ELSE
            INSERT INTO [utilities].[Countries] ([name], [demonym]) VALUES (@country, @nationality)
    ELSE
        UPDATE [utilities].[Countries] SET [demonym] = @nationality WHERE [demonym] = @nationality

    SELECT @outDemonym = [demonym], @outCountryId = [id], @outName = [name] FROM [utilities].[Countries] WHERE [demonym] = @nationality
END;