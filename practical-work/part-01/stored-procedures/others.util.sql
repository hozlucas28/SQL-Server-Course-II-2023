GO
USE [cure_sa];

-- Obtener el ID de un sexo
GO
CREATE OR ALTER FUNCTION [utils].[obtenerCharSexo]
    (
        @sexo VARCHAR(50)
    ) RETURNS CHAR
AS
BEGIN
    DECLARE @char CHAR
    SET @char = 'N';

    IF UPPER(@sexo) = 'MASCULINO'
        SET @char = 'M';
        ELSE IF UPPER(@sexo) = 'FEMENINO'
            SET @char = 'F'
    
    RETURN @char
END;