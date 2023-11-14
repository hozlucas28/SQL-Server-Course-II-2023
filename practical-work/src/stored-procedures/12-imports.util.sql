USE [CURESA];
GO


/* --------------- Procedimientos Almacenados - Importaciones --------------- */

-- TODO: Validar parámetros con INSTR.
CREATE OR ALTER PROCEDURE [archivos].[importarDatosCSV]
    @tablaDestino VARCHAR(255),
    @delimitadorCampos VARCHAR(4) = ';',
    @delimitadorFilas VARCHAR(4) = '\n',
    @rutaArchivo VARCHAR(255)
AS
BEGIN
    PRINT 'Iniciando la importación del archivo CSV...'
    
    DECLARE @error NVARCHAR(MAX)
    
    IF LEN(@tablaDestino) = 0
    BEGIN
        SET @error = 'El nombre de la tabla de destino no puede estar vacío.';
        THROW 51000, @error, 1
        RETURN
    END
    
    IF LEN(@rutaArchivo) = 0
    BEGIN
        SET @error = 'La ruta del archivo CSV no puede estar vacía.';
        THROW 51001, @error, 1
        RETURN
    END
    
    /*Validación de existencia del archivo
    IF NOT EXISTS (SELECT 1 FROM sys.dm_os_file_exists(@rutaArchivo))
    BEGIN
        SET @error = 'El archivo ' + @rutaArchivo + ' no existe.'
        THROW 51002, @error, 1
        RETURN
    END*/
    
    DECLARE @SQL NVARCHAR(MAX)
    SET @SQL = N'
        BEGIN TRY
            BULK INSERT ' + QUOTENAME(@tablaDestino) + '
            FROM ''' + @rutaArchivo + '''
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ''' + @delimitadorCampos + ''',
                ROWTERMINATOR = ''' + @delimitadorFilas + ''', 
                CODEPAGE = ''65001''
            );
        END TRY
        BEGIN CATCH
            DECLARE @err NVARCHAR(255);
            SET @err = ''Error durante la carga de datos: '' + ERROR_MESSAGE();
            THROW 51003, @err, 1;
        END CATCH'

    EXEC sp_executesql @SQL
    
    PRINT 'Se ha finalizado correctamente.'
END;