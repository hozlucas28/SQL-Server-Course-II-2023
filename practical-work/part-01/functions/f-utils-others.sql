USE [cure_sa];
GO

-- Obtener el ID de un sexo
CREATE OR ALTER FUNCTION [utils].[obtenerCharSexo]
    (
        @sexo VARCHAR(25)
    ) RETURNS CHAR
AS
BEGIN
    DECLARE @char CHAR;
    SET @char = 'N';

    IF UPPER(TRIM(@sexo)) = 'MASCULINO'
        SET @char = 'M';
    ELSE IF UPPER(TRIM(@sexo)) = 'FEMENINO'
        SET @char = 'F';
    
    RETURN @char
END;
GO

CREATE OR ALTER FUNCTION [utils].[obtenerSexoConChar]
(
    @sexo CHAR(1)
)RETURNS CHAR(9)
AS
BEGIN
    IF @sexo = 'M'
        return 'MASCULINO' 
    return 'FEMENINO'
END;