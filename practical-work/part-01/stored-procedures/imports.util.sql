GO
USE [cure_sa];

-- Importar datos desde un archivo CSV
GO
CREATE OR ALTER PROCEDURE [archivos].[importarDatosCSV]
    @tablaDestino VARCHAR(255),
    @delimitadorCampos VARCHAR(4) = ';',
    @delimitadorFilas VARCHAR(4) = '\n',
    @rutaArchivo VARCHAR(255)
AS
BEGIN
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
go
