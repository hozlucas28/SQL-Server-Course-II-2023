USE [CURESA];
GO


/* ----------------- Procedimientos Almacenados - Pacientes ----------------- */

-- Insertar un paciente
CREATE OR ALTER PROCEDURE [data].[insertPatient]  
	@documentName VARCHAR(20), 
	@firstName VARCHAR(255), 
	@phone VARCHAR(40), 
	@street VARCHAR(255), 
    @alternativePhone VARCHAR(20) = NULL,
    @biologicalSex VARCHAR(20), 
    @birthdate DATE,
    @coverageId INT = NULL,
    @documentNumber INT,
    @email VARCHAR(40), 
    @genderName VARCHAR(20),
    @lastName VARCHAR(255), 
    @localityName VARCHAR(255), 
    @maternalLastName VARCHAR (50) = NULL,
    @nationalityName VARCHAR(50), 
    @photoUrl VARCHAR(128) = NULL,
    @profesionalPhone VARCHAR(20) = NULL,
    @provinceName VARCHAR(255)
AS
BEGIN
    DECLARE @addressId INT
    DECLARE @documentId INT
    DECLARE @genderId INT
    DECLARE @nationalityId INT
    DECLARE @sexChar CHAR(1)
    DECLARE @today DATE = GETDATE()

    EXECUTE [utilities].[getOrInsertAddressId] @addressStreet = @street, @localityName = @localityName, @provinceName = @provinceName, @outAddressId = @addressId OUT
	EXECUTE [utilities].[getOrInsertDocumentId] @documentName = @documentName, @outDocumentId = @documentId OUT
	EXECUTE [utilities].[getOrInsertNationalityId] @nationalityName = @nationalityName, @outNationalityId = @nationalityId OUT
	EXECUTE [utilities].[getSexChar] @sexName = @biologicalSex, @outSexChar = @sexChar OUT 
	EXECUTE [utilities].[getOrInsertGenderId] @genderName = @genderName, @outGenderId = @genderId OUT

    INSERT INTO [data].[Patients]
        (
            [addressId],
            [alternativePhone],
            [biologicalSex],
            [birthdate],
            [coverageId],
            [documentId],
            [documentNumber],
            [email],
            [genderId],
            [lastName],
            [maternalLastName],
            [firstName],
            [nationalityId],
            [phone],
            [photoUrl],
            [profesionalPhone],
            [updateDate],
            [valid]
        ) VALUES (
            @addressId,
            @alternativePhone,
            @sexChar,
            @birthdate,
            @coverageId,
            @documentId,
            @documentNumber,
            @email,
            @genderId,
            @lastName,
            @maternalLastName,
            @firstName,
            @nationalityId,
            @phone,
            @photoUrl,
            @profesionalPhone,
            @today,
            1
	)
END;
GO

-- Actualizar un paciente
CREATE OR ALTER PROCEDURE [data].[updatePatient]
    @addressId INT = NULL,
    @alternativePhone VARCHAR(20) = NULL,
    @biologicalSex CHAR(1) = NULL,
    @birthdate DATE = NULL,
    @coverageId INT = NULL,
    @documentId INT = NULL,
    @documentNumber VARCHAR(50) = NULL,
    @email VARCHAR(70) = NULL,
    @firstName VARCHAR(30) = NULL,
    @genderName VARCHAR(255) = NULL,
    @lastName VARCHAR(50) = NULL,
    @maternalLastName VARCHAR(30) = NULL,
    @nationalityName VARCHAR(255) = NULL,
    @patientId INT,
    @phone VARCHAR(20) = NULL,
    @photoUrl VARCHAR(128) = NULL,
    @profesionalPhone VARCHAR(20) = NULL
AS
BEGIN
    DECLARE @genderId INT = NULL
    DECLARE @nationalityId INT = NULL

    SET @documentNumber = TRIM(@documentNumber)
    SET @firstName = TRIM(@firstName)
    SET @lastName = TRIM(@lastName)
    SET @maternalLastName = TRIM(@maternalLastName)
    SET @genderName = UPPER(TRIM(@genderName))
    SET @nationalityName = UPPER(TRIM(@nationalityName))
    SET @photoUrl = TRIM(@photoUrl)
    SET @email = TRIM(@email)
    SET @phone = TRIM(@phone)
    SET @alternativePhone = TRIM(@alternativePhone)
    SET @profesionalPhone = TRIM(@profesionalPhone)

    IF @genderName IS NOT NULL 
        EXECUTE [utilities].[getOrInsertGenderId] @genderName = @genderName, @outGenderId = @genderId OUT

    IF @nationalityName IS NOT NULL
        EXECUTE [utilities].[getOrInsertNationalityId] @nationalityName = @nationalityName, @outNationalityId = @nationalityId OUT

    UPDATE [data].[Patients] SET
        [coverageId] = ISNULL(@coverageId, [coverageId]),
        [addressId] = ISNULL(@addressId, [addressId]),
        [documentId] = ISNULL(@documentId, [documentId]),
        [documentNumber] = ISNULL(@documentNumber, TRIM([documentNumber])),
        [firstName] = ISNULL(@firstName, TRIM([firstName])),
        [lastName] = ISNULL(@lastName, TRIM([lastName])),
        [maternalLastName] = ISNULL(@maternalLastName, TRIM([maternalLastName])),
        [birthdate] = ISNULL(@birthdate, [birthdate]),
        [biologicalSex] = UPPER(ISNULL(@biologicalSex, TRIM([biologicalSex]))),
        [genderId] = ISNULL(@genderId, [genderId]),
        [nationalityId] = ISNULL(@nationalityId, [nationalityId]),
		[photoUrl] = ISNULL(@photoUrl, TRIM([photoUrl])),
        [email] = ISNULL(@email, TRIM([email])),
        [phone] = ISNULL(@phone, TRIM([phone])),
        [alternativePhone] = ISNULL(@alternativePhone, TRIM([alternativePhone])),
        [profesionalPhone] = ISNULL(@profesionalPhone, TRIM([profesionalPhone]))
    WHERE
        [id] = @patientId
END;
GO

-- Borrar un paciente (borrado lógico)
CREATE OR ALTER PROCEDURE [data].[deletePatient]
    @patientId INT
AS
    UPDATE [data].[Patients] SET [valid] = 0 WHERE [id] = @patientId;
GO

-- ¿Existe el paciente?
CREATE OR ALTER PROCEDURE [data].[patientExists]
    @email VARCHAR(255),
    @exists BIT OUT
AS
BEGIN
    SET @exists = 0

    IF EXISTS (SELECT 1 FROM [data].[Patients] WHERE TRIM([email]) = @email)
        SET @exists = 1
END;