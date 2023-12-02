USE [CURESA];
GO


/* ------------- Procedimientos Almacenados - Otros (utilidades) ------------ */

-- Obtener sexo
CREATE OR ALTER PROCEDURE [utilities].[getSexChar]
    @outSexChar CHAR(1) OUTPUT,
    @sexName VARCHAR(25)
AS
BEGIN
    SET @outSexChar = 'N'

    IF UPPER(TRIM(@sexName)) = 'MALE'
        SET @outSexChar = 'M'
    ELSE IF UPPER(TRIM(@sexName)) = 'FEMALE'
        SET @outSexChar = 'F'
END;