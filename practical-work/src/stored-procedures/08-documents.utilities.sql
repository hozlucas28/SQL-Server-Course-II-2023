USE [CURESA];
GO


/* ------------ Procedimientos Almacenados - Tipos De Documentos ------------ */

-- Obtener o insertar un tipo de documento
CREATE OR ALTER PROCEDURE [utilities].[getOrInsertDocumentId]
    @documentName VARCHAR(50),
    @outDocumentId INT OUTPUT
AS
BEGIN
    SET @documentName = UPPER(TRIM(@documentName))

    IF NULLIF(@documentName, '') IS NULL
        SET @outDocumentId = -1
    ELSE
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM [utilities].[Documents] WHERE UPPER(TRIM([name])) = @documentName) 
            INSERT INTO [utilities].[Documents] ([name]) VALUES (@documentName)
       
        SELECT @outDocumentId = [id] FROM [utilities].[Documents] WHERE UPPER(TRIM([name])) = @documentName
    END
END;
GO

-- Actualizar o insertar un documento
CREATE OR ALTER PROCEDURE [utilities].[updateOrInsertDocument]
    @documentName VARCHAR(50) = 'null',
    @outDocumentId INT OUTPUT
AS
BEGIN
    SET @documentName = UPPER(TRIM(@documentName))

    IF NULLIF(@documentName, '') IS NULL
        RETURN
        
    IF NOT EXISTS (SELECT 1 FROM [utilities].[Documents] WHERE UPPER(TRIM([name])) = @documentName) 
        INSERT INTO [utilities].[Documents] ([name]) VALUES (@documentName)
    ELSE
        UPDATE [utilities].[Documents] SET [name] = @documentName WHERE UPPER(TRIM([name])) = @documentName

    SELECT @outDocumentId = [id] FROM [utilities].[Documents] WHERE UPPER(TRIM([name])) = @documentName
END;