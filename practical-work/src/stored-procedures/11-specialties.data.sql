USE [CURESA];
GO


/* --------------- Procedimientos Almacenados - Especialidades -------------- */

-- Obtener una especialidad
CREATE OR ALTER PROCEDURE [data].[getSpecialtyId]
    @outSpecialtyId INT OUTPUT,
    @specialtyName VARCHAR(50) = 'null'
AS
BEGIN
    SET @outSpecialtyId = -1
    SET @specialtyName = UPPER(TRIM(@specialtyName))

    IF NULLIF(@specialtyName, '') IS NULL
        RETURN

    IF NOT EXISTS (SELECT 1 FROM [data].[Specialties] WHERE UPPER(TRIM([name])) = @specialtyName) 
        RETURN

    SELECT @outSpecialtyId = [id] FROM [data].[Specialties] WHERE UPPER(TRIM([name])) = @specialtyName
END;
GO

-- Actualizar o insertar una especialidad
CREATE OR ALTER PROCEDURE [data].[updateOrInsertSpecialty]
    @outSpecialtyId INT OUTPUT,
    @specialtyName VARCHAR(50) = 'null'
AS
BEGIN
    SET @specialtyName = UPPER(TRIM(@specialtyName))

    IF NULLIF(@specialtyName, '') IS NULL
        RETURN

    IF NOT EXISTS (SELECT 1 FROM [data].[Specialties] WHERE [name] = @specialtyName) 
        INSERT INTO [data].[Specialties] ([name]) VALUES (@specialtyName)

    SELECT @outSpecialtyId = [id] FROM [data].[Specialties] WHERE [name] = @specialtyName
END;