USE [CURESA];
GO


/* ------------------ Procedimientos Almacenados - Médicos ------------------ */

-- Insertar un médico
CREATE OR ALTER PROCEDURE [data].[insertMedic]
    @firstName VARCHAR(50),
    @lastName VARCHAR(50),
    @medicalLicense INT,
    @specialtyName VARCHAR(50)
AS
BEGIN
    DECLARE @specialtyId INT

    EXECUTE [data].[getSpecialtyId] @specialtyName = @specialtyName, @outSpecialtyId = @specialtyId OUT

    INSERT INTO [data].[Medics] ([firstName], [lastName], [medicalLicense], [specialtyId])
        VALUES (@firstName, @lastName, @medicalLicense, @specialtyId)
END;
GO

-- Borrar un médico (borrado lógico)
CREATE OR ALTER PROCEDURE [data].[deleteMedic]
    @medicId INT
AS
    UPDATE [data].[Medics] SET [enabled] = 0 WHERE [id] = @medicId;