GO
USE [cure_sa];

-- Importar datos desde un archivo CSV
GO
CREATE OR ALTER PROCEDURE [archivos].[importarDatosCSV]
    @tablaDestino NVARCHAR(255),
    @delimitadorCampos CHAR(4) = ';',
    @delimitadorFilas CHAR(4) = '\n',
    @rutaArchivo NVARCHAR(255)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sys.dm_os_file_exists(@rutaArchivo))
        RETURN

    DECLARE @SQL NVARCHAR(MAX)
    SET @SQL = 'BULK INSERT ' + QUOTENAME(@tablaDestino) + '
                    FROM ''' + @rutaArchivo + '''
                        WITH (
                                FIRSTROW = 2,
                                FIELDTERMINATOR = ''' + @delimitadorCampos + ''',
                                ROWTERMINATOR = ''' + @delimitadorFilas + ''', 
			                    CODEPAGE = ''65001''
		                    );'

    EXEC sp_executesql @SQL
END;