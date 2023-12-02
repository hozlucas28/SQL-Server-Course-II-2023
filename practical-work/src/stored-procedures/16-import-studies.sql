USE [CURESA];
GO


/* ------------- Procedimientos Almacenados - Importar Estudios ------------- */

CREATE OR ALTER PROCEDURE [files].[importarEstudiosJSON]
    @rutaArchivo VARCHAR(255)
AS
BEGIN
    DECLARE @error NVARCHAR(255)
    DECLARE @sql NVARCHAR(MAX)
    DECLARE @json NVARCHAR(MAX)
    DECLARE @paramDef NVARCHAR(100)
    
    IF LEN(@rutaArchivo) = 0
    BEGIN
        SET @error = 'La ruta del archivo JSON no puede estar vacía.';
        THROW 51001, @error, 1
        RETURN
    END

    SET @sql = N'
        SET @json_string = (SELECT * FROM OPENROWSET (BULK ''' + @rutaArchivo + ''', SINGLE_CLOB) as JsonFile)
    '
    SET @paramDef = N'
        @json_string NVARCHAR(MAX) OUTPUT'
    
    EXEC sp_executesql @sql, @paramDef, @json_string = @json OUTPUT

    IF OBJECT_ID('tempdb..[#EstudiosMedicos]') IS NOT NULL 
        DROP TABLE [#EstudiosMedicos]

    CREATE TABLE [#EstudiosMedicos]
    (
        [id] NVARCHAR(255) COLLATE Latin1_General_CS_AS PRIMARY KEY,
        [area] NVARCHAR(255) COLLATE Latin1_General_CS_AS,
        [research] NVARCHAR(255) COLLATE Latin1_General_CS_AS,
        [prestador] NVARCHAR(255) COLLATE Latin1_General_CS_AS,
        [plan] NVARCHAR(255) COLLATE Latin1_General_CS_AS,
        [coveragePercentage] INT,
        [price] DECIMAL(18, 2),
        [requiresAuthorization] BIT
    )

    INSERT INTO [#EstudiosMedicos](
        [id],
        [area],
        [research],
        [prestador],
        [plan],
        [coveragePercentage],
        [price],
        [requiresAuthorization]
    ) 
    SELECT * FROM OPENJSON(@json) 
    WITH (
        [id] NVARCHAR(255) '$._id."$oid"',
        [area] NVARCHAR(255) '$.Area',
        [research] NVARCHAR(255) '$.Estudio',
        [prestador] NVARCHAR(255) '$.Prestador',
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
            [em].[id],
            [em].[area],
            [em].[research],
            [p].[id],
            [em].[plan],
            [em].[coveragePercentage],
            [em].[price],
            [em].[requiresAuthorization]
        FROM [#EstudiosMedicos] [em]
        INNER JOIN [data].[Providers] p ON [em].[prestador] = [p].[name]
        WHERE [p].[plan] = [em].[plan] AND [em].[id] NOT IN (
            SELECT [id] FROM [data].[Valid_Researches]
        )

        DROP TABLE [#EstudiosMedicos]
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
		SET @errorMessage = ERROR_MESSAGE()
		PRINT 'Error durante la inserción: ' + @errorMessage;
        THROW
    END CATCH
END;