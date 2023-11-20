USE [CURESA];
GO


/* ------------- Procedimientos Almacenados - Importar Estudios ------------- */

CREATE OR ALTER PROCEDURE [archivos].[importarEstudiosJSON]
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
        [estudio] NVARCHAR(255) COLLATE Latin1_General_CS_AS,
        [prestador] NVARCHAR(255) COLLATE Latin1_General_CS_AS,
        [plan] NVARCHAR(255) COLLATE Latin1_General_CS_AS,
        [porcentajeCobertura] INT,
        [costo] DECIMAL(18, 2),
        [requiereAutorizacion] BIT
    )

    INSERT INTO [#EstudiosMedicos](
        [id],
        [area],
        [estudio],
        [prestador],
        [plan],
        [porcentajeCobertura],
        [costo],
        [requiereAutorizacion]
    ) 
    SELECT * FROM OPENJSON(@json) 
    WITH (
        [id] NVARCHAR(255) '$._id."$oid"',
        [area] NVARCHAR(255) '$.Area',
        [estudio] NVARCHAR(255) '$.Estudio',
        [prestador] NVARCHAR(255) '$.Prestador',
        [plan] NVARCHAR(255) '$.Plan',
        [porcentajeCobertura] INT '$."Porcentaje Cobertura"',
        [costo] DECIMAL(18, 2) '$.Costo',
        [requiereAutorizacion] BIT '$."Requiere autorizacion"'
    )

    BEGIN TRY
        INSERT INTO [datos].[estudiosValidos]
        (
            [id_estudioValido],
            [area],
            [estudio],
            [id_prestador],
            [plan],
            [porcentajeCobertura],
            [costo],
            [requiereAutorizacion]
        )
        SELECT  
            [em].[id],
            [em].[area],
            [em].[estudio],
            [p].[id_prestador],
            [em].[plan],
            [em].[porcentajeCobertura],
            [em].[costo],
            [em].[requiereAutorizacion]
        FROM [#EstudiosMedicos] [em]
        INNER JOIN [datos].[prestadores] p ON [em].[prestador] = [p].[nombre]
        WHERE [p].[plan_prestador] = [em].[plan] AND [em].[id] NOT IN (
            SELECT [id_estudioValido] FROM [datos].[estudiosValidos]
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