USE [CURESA];
GO


/* ------------------ Procedimientos Almacenados - Géneros ------------------ */

-- Obtener o insertar un género
CREATE OR ALTER PROCEDURE [utilities].[getOrInsertGenderId]
    @genderName VARCHAR(50) = 'null',
    @outGenderId INT OUTPUT
AS
BEGIN
    SET @genderName = UPPER(TRIM(@genderName))

    IF NULLIF(@genderName, '') IS NULL
        SET @outGenderId = -1
    ELSE
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM [utilities].[Genders] WHERE UPPER(TRIM([name])) = @genderName) 
            INSERT INTO [utilities].[Genders] ([name]) VALUES (@genderName)

        SELECT @outGenderId = [id] FROM [utilities].[Genders] WHERE UPPER(TRIM([name])) = @genderName
    END
END;