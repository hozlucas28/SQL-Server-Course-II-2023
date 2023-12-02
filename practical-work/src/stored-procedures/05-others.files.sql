USE [CURESA];
GO


/* -------------- Procedimientos Almacenados - Otros (archivos) ------------- */

-- Importar datos de un CSV
CREATE OR ALTER PROCEDURE [files].[importDataCSV]
    @destTable VARCHAR(255),
    @fieldDelimiter VARCHAR(4) = ';',
    @filePath VARCHAR(255),
    @rowDelimiter VARCHAR(4) = '\n'
AS
BEGIN
    DECLARE @error NVARCHAR(MAX)
    DECLARE @SQL NVARCHAR(MAX)
    PRINT 'Starting CSV file import...'
    
    IF LEN(@destTable) = 0
    BEGIN
        SET @error = 'The destination table name cannot be empty!';
        THROW 51000, @error, 1
        RETURN
    END
    
    IF LEN(@filePath) = 0
    BEGIN
        SET @error = 'The CSV file path cannot be empty!';
        THROW 51001, @error, 1
        RETURN
    END
    
    SET @SQL = N'
        BEGIN TRY
            BULK INSERT ' + QUOTENAME(@destTable) + '
            FROM ''' + @filePath + '''
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ''' + @fieldDelimiter + ''',
                ROWTERMINATOR = ''' + @rowDelimiter + ''', 
                CODEPAGE = ''65001''
            );
        END TRY
        BEGIN CATCH
            DECLARE @err NVARCHAR(255);
            SET @err = ''Error during data loading: '' + ERROR_MESSAGE();
            THROW 51003, @err, 1;
        END CATCH'

    EXECUTE sp_executesql @SQL
    PRINT 'Process of import data from CSV completed successfully :D !'
END;