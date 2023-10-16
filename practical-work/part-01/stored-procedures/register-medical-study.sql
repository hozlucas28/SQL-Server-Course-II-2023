USE [cure_sa]
GO

CREATE OR ALTER PROCEDURE [datos].[registrarEstudiosValidosDesdeJSON]
    @rutaArchivo NVARCHAR(MAX)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @json NVARCHAR(MAX);
    DECLARE @paramDef NVARCHAR(100);
    
    SET @sql = N'
        SET @json_string = (SELECT * FROM OPENROWSET (BULK ''' + @rutaArchivo + ''', SINGLE_CLOB) as JsonFile)
    '
    SET @paramDef = N'
        @json_string NVARCHAR(MAX) OUTPUT';  
    
    EXEC sp_executesql @sql, @paramDef, @json_string = @json OUTPUT;

    SELECT * INTO #EstudiosMedicos FROM
    OPENJSON(@json) 
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
        SELECT  
            em.id,
            em.area,
            em.estudio,
            p.id_prestador,
            em.[plan],
            em.porcentajeCobertura,
            em.costo,
            em.requiereAutorizacion
        FROM #EstudiosMedicos em
        INNER JOIN [datos].[prestadores] p ON em.prestador = p.nombre COLLATE Latin1_General_CS_AS
        WHERE 
            em.area IS NOT NULL AND
            em.estudio IS NOT NULL AND
            em.prestador IS NOT NULL AND
            em.[plan] IS NOT NULL AND p.plan_prestador = em.[plan] COLLATE Latin1_General_CS_AS AND
            em.porcentajeCobertura IS NOT NULL AND
            em.costo IS NOT NULL 

        DROP TABLE #EstudiosMedicos;
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
		SET @errorMessage = ERROR_MESSAGE()
		PRINT 'Error durante la inserción: ' + @errorMessage;
        THROW;
    END CATCH
END;

