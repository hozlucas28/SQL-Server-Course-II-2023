GO
USE [cure_sa];

-- Importar datos desde un archivo CSV
GO
CREATE OR ALTER PROCEDURE [archivos].[importarDatosCSV]
    @tablaDestino NVARCHAR(255),
    @delimitadorCampos CHAR(1) = ';',
    @delimitadorFilas CHAR(2) = '\n',
    @rutaArchivo NVARCHAR(255)
AS
BEGIN
    DECLARE @Error NVARCHAR(MAX);

    PRINT 'Iniciando la importación del archivo CSV...';
    
    IF LEN(@tablaDestino) = 0
    BEGIN
        SET @Error = 'El nombre de la tabla de destino no puede estar vacío.';
        THROW 51000, @Error, 1;
        RETURN;
    END
    
    IF LEN(@rutaArchivo) = 0
    BEGIN
        SET @Error = 'La ruta del archivo CSV no puede estar vacía.';
        THROW 51001, @Error, 1;
        RETURN;
    END
    
    /*Validación de existencia del archivo
    IF NOT EXISTS (SELECT 1 FROM sys.dm_os_file_exists(@rutaArchivo))
    BEGIN
        SET @Error = 'El archivo ' + @rutaArchivo + ' no existe.'
        THROW 51002, @Error, 1;
        RETURN;
    END*/

    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @ParamDef NVARCHAR(MAX);

    SET @SQL = N'
        BEGIN TRY
            BULK INSERT ' + QUOTENAME(@tablaDestino) + '
            FROM ''' + @rutaArchivo + '''
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ''' + @delimitadorCampos + ''',
                ROWTERMINATOR = ''' + @delimitadorFilas + ''', 
                CODEPAGE = 65001
            );
        END TRY
        BEGIN CATCH
            DECLARE @err NVARCHAR(255);
            SET @err = ''Error durante la carga de datos: '' + ERROR_MESSAGE();
            THROW 51003, @err, 1;
        END CATCH
    '

    EXEC sp_executesql
        @SQL
   
    PRINT 'Se ha finalizado correctamente.'
END;