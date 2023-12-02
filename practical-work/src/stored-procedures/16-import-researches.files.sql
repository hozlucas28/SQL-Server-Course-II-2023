USE [CURESA];
GO


/* ------------- Procedimientos Almacenados - Importar Estudios ------------- */

-- Importar los estudios médicos desde un archivo JSON
CREATE OR ALTER PROCEDURE [files].[importResearchesJSON]
    @filePath VARCHAR(255)
AS
BEGIN
    DECLARE @error NVARCHAR(255)
    DECLARE @json NVARCHAR(MAX)
    DECLARE @paramDef NVARCHAR(100)
    DECLARE @sql NVARCHAR(MAX)
    
    IF LEN(@filePath) = 0
        BEGIN
            SET @error = 'The JSON file path cannot be empty!';
            THROW 51001, @error, 1
            RETURN
        END

    SET @sql = N'
        SET @json_string = (SELECT * FROM OPENROWSET (BULK ''' + @filePath + ''', SINGLE_CLOB) as JsonFile)
    '
    SET @paramDef = N'
        @json_string NVARCHAR(MAX) OUTPUT
    '
    
    EXECUTE sp_executesql @sql, @paramDef, @json_string = @json OUTPUT

    IF OBJECT_ID('tempdb..[#Medical_Researches]') IS NOT NULL 
        DROP TABLE [#Medical_Researches]

    CREATE TABLE [#Medical_Researches]
    (
        [id] NVARCHAR(255) COLLATE Latin1_General_CS_AS PRIMARY KEY,
        [area] NVARCHAR(255) COLLATE Latin1_General_CS_AS,
        [research] NVARCHAR(255) COLLATE Latin1_General_CS_AS,
        [providerName] NVARCHAR(255) COLLATE Latin1_General_CS_AS,
        [plan] NVARCHAR(255) COLLATE Latin1_General_CS_AS,
        [coveragePercentage] INT,
        [price] DECIMAL(18, 2),
        [requiresAuthorization] BIT
    )

    INSERT INTO [#Medical_Researches](
        [id],
        [area],
        [research],
        [providerName],
        [plan],
        [coveragePercentage],
        [price],
        [requiresAuthorization]
    ) SELECT * FROM OPENJSON(@json)  WITH (
        [id] NVARCHAR(255) '$._id."$oid"',
        [area] NVARCHAR(255) '$.Area',
        [research] NVARCHAR(255) '$.Estudio',
        [providerName] NVARCHAR(255) '$.Prestador',
        [plan] NVARCHAR(255) '$.Plan',
        [coveragePercentage] INT '$."Porcentaje Cobertura"',
        [price] DECIMAL(18, 2) '$.Costo',
        [requiresAuthorization] BIT '$."Requiere autorizacion"'
    )

    BEGIN TRY
        INSERT INTO [data].[Valid_Researches]
        (
            [id],
            [area],
            [research],
            [providerId],
            [plan],
            [coveragePercentage],
            [price],
            [requiresAuthorization]
        )
        SELECT  
            [medicalResearch].[id],
            [medicalResearch].[area],
            [medicalResearch].[research],
            [provider].[id],
            [medicalResearch].[plan],
            [medicalResearch].[coveragePercentage],
            [medicalResearch].[price],
            [medicalResearch].[requiresAuthorization]
        FROM [#Medical_Researches] AS [medicalResearch]
            INNER JOIN [data].[Providers] AS [provider] ON UPPER(TRIM([medicalResearch].[providerName])) = UPPER(TRIM([provider].[name]))
                WHERE UPPER(TRIM([provider].[plan])) = UPPER(TRIM([medicalResearch].[plan])) AND [medicalResearch].[id] NOT IN (
                    SELECT [id] FROM [data].[Valid_Researches]
                )

        DROP TABLE [#Medical_Researches]
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
		SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error during researches insertion: ' + @errorMessage;
        THROW
    END CATCH
END;