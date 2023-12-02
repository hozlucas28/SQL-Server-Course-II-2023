USE [CURESA];
GO


/* ----------------- Procedimientos Almacenados - Coberturas ---------------- */

-- Registrar una cobertura
CREATE OR ALTER PROCEDURE [data].[insertCoverage]
    @imageUrl VARCHAR(128),
    @membershipNumber VARCHAR(30),
    @providerId INT
AS
BEGIN
    SET @imageUrl = TRIM(@imageUrl)
    SET @membershipNumber = TRIM(@membershipNumber)

    BEGIN TRY
        INSERT INTO [data].[Coverages] ([providerId], [imageUrl], [membershipNumber]) VALUES (@providerId, @imageUrl, @membershipNumber)
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error during coverage insertion: ' + @errorMessage;
        THROW
    END CATCH
END;
GO

-- Actualizar una cobertura
CREATE OR ALTER PROCEDURE [data].[updateCoverage]
    @coverageId INT,
    @imageUrl VARCHAR(128) = NULL,
    @membershipNumber VARCHAR(30) = NULL,
    @providerId INT = NULL,
    @registrationDate DATE = NULL
AS
BEGIN
    SET @imageUrl = TRIM(@imageUrl)
    SET @membershipNumber = TRIM(@membershipNumber)

    BEGIN TRY
        UPDATE [data].[Coverages]
        SET [registrationDate] = ISNULL(@registrationDate, [registrationDate]),
            [providerId] = ISNULL(@providerId, [providerId]),
            [imageUrl] = ISNULL(@imageUrl, TRIM([imageUrl])),
            [membershipNumber] = ISNULL(@membershipNumber, TRIM([membershipNumber]))
        WHERE [id] = @coverageId
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error during coverage update: ' + @errorMessage;
        THROW
    END CATCH
END;
GO

-- Borrar una cobertura (forma lógica)
CREATE OR ALTER PROCEDURE [data].[deleteCoverage]
    @coverageId INT
AS
BEGIN
    BEGIN TRY
        UPDATE [data].[Coverages] SET [deleted] = 1 WHERE [id] = @coverageId
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error during coverage logical delete: ' + @errorMessage;
        THROW
    END CATCH
END;