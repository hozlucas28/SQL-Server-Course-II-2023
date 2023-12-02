USE [CURESA];
GO


/* ------------------ Procedimientos Almacenados - Estudios ----------------- */

-- Registrar un estudio
CREATE OR ALTER PROCEDURE [data].[insertResearch]
    @authorized BIT = 1,
    @date DATE,
    @documentUrl VARCHAR(128) = NULL,
    @imageUrl VARCHAR(128) = NULL,
    @patientId INT,
    @researchName VARCHAR(60)
AS
BEGIN
    SET @documentUrl = TRIM(@documentUrl)
    SET @imageUrl = TRIM(@imageUrl)
    SET @researchName = UPPER(TRIM(@researchName))

    BEGIN TRY
        INSERT INTO [data].[Researches] ([name], [patientId], [authorized], [documentUrl], [date], [imageUrl])
            VALUES (@researchName, @patientId, @authorized, @documentUrl, @date, @imageUrl)
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error during research insertion: ' + @errorMessage;
        THROW
    END CATCH
END;
GO

-- Actualizar un estudio
CREATE OR ALTER PROCEDURE [data].[updateResearch]
    @authorized BIT = NULL,
    @date DATE = NULL,
    @documentUrl VARCHAR(128) = NULL,
    @imageUrl VARCHAR(128) = NULL,
    @patientId INT = NULL,
    @researchId INT = NULL,
    @researchName VARCHAR(60) = NULL
AS
BEGIN
    SET @documentUrl = TRIM(@documentUrl)
    SET @imageUrl = TRIM(@imageUrl)
    SET @researchName = UPPER(TRIM(@researchName))

    BEGIN TRY
        UPDATE [data].[Researches]
        SET [name] = ISNULL(@researchName, UPPER(TRIM([name]))),
            [patientId] = ISNULL(@patientId, [patientId]),
            [authorized] = ISNULL(@authorized, [authorized]),
            [documentUrl] = ISNULL(@documentUrl, TRIM([documentUrl])),
            [date] = ISNULL(@date, [date]),
            [imageUrl] = ISNULL(@imageUrl, TRIM([imageUrl]))
        WHERE [id] = @researchId
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error during research update: ' + @errorMessage;
        THROW
    END CATCH
END;
GO

-- Borrar un estudio (borrado lógico)
CREATE OR ALTER PROCEDURE [data].[deleteResearch]
    @researchId INT
AS
BEGIN
    BEGIN TRY
        UPDATE [data].[Researches] SET [authorized] = 0 WHERE [id] = @researchId
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error during research logical delete: ' + @errorMessage;
        THROW
    END CATCH
END;
