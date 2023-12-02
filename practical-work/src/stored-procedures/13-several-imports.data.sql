USE [CURESA];
GO


/* ---------------- Procedimientos Almacenados - Importar CSV --------------- */

-- Importar los médicos desde un archivo CSV
CREATE OR ALTER PROCEDURE [files].[importMedicsCSV]
	@filePath VARCHAR(255),
	@fieldDelimiter VARCHAR(4) = ';'
AS
BEGIN
	IF OBJECT_ID('tempdb..[#Imported_Medics]') IS NOT NULL
		DROP TABLE [#Imported_Medics]
	
	CREATE TABLE [#Imported_Medics] (
		[lastName] VARCHAR(255) COLLATE Latin1_General_CS_AS,
		[firstName] VARCHAR(255) COLLATE Latin1_General_CS_AS,
		[Specialties] VARCHAR(255) COLLATE Latin1_General_CS_AS,
		[medicalLicense] INT PRIMARY KEY
	)

	EXECUTE [files].[importDataCSV] 
		@destTable = '#Imported_Medics', 
		@filePath = @filePath, 
		@fieldDelimiter = @fieldDelimiter

	DECLARE	@firstName VARCHAR(255)
	DECLARE	@specialtyName VARCHAR(255)
	DECLARE @count INT
	DECLARE @lastName VARCHAR(255)
	DECLARE @medicalLicense INT
	DECLARE @specialtyId INT

	DELETE FROM [#Imported_Medics] WHERE [#Imported_Medics].[medicalLicense] IN (SELECT [medicalLicense] FROM [data].[Medics])

	SELECT @count = COUNT(*) FROM [#Imported_Medics]

	SET NOCOUNT ON
	WHILE @count > 0
	BEGIN
		SELECT TOP(1) 
			@firstName = UPPER(TRIM([firstName])),
			@lastName = UPPER(TRIM([lastName])),
			@specialtyName = UPPER(TRIM([Specialties])),
			@medicalLicense = [medicalLicense]
		FROM [#Imported_Medics]

		EXECUTE [data].[updateOrInsertSpecialty] 
			@specialtyName = @specialtyName, 
			@outSpecialtyId = @specialtyId OUTPUT

		EXECUTE [data].[insertMedic] 
			@firstName = @firstName, 
			@lastName = @lastName, 
			@specialtyName = @specialtyName, 
			@medicalLicense = @medicalLicense

		DELETE TOP(1) FROM [#Imported_Medics]
		SET @count = @count - 1
	END
	SET NOCOUNT OFF

	DROP TABLE [#Imported_Medics]
END;
GO

-- Importar los prestadores desde un archivo CSV
CREATE OR ALTER PROCEDURE [files].[importProvidersCSV]
	@filePath VARCHAR(255),
	@fieldDelimiter VARCHAR(4) = ';'
AS
BEGIN
	IF OBJECT_ID('tempdb..[#Imported_Providers]') IS NOT NULL
		DROP TABLE [#Imported_Providers]
	
	CREATE TABLE [#Imported_Providers] (
		[name] VARCHAR(255) COLLATE Latin1_General_CS_AS, 
		[plan] VARCHAR(255) COLLATE Latin1_General_CS_AS,
		[emptyField] CHAR COLLATE Latin1_General_CS_AS,
	)

	EXECUTE [files].[importDataCSV] 
		@destTable = '#Imported_Providers', 
		@filePath = @filePath, 
		@fieldDelimiter = @fieldDelimiter

	DELETE FROM [#Imported_Providers]
	WHERE EXISTS (
    	SELECT 1
  		FROM [data].[Providers] AS [provider]
  	  	WHERE 
			UPPER(TRIM([#Imported_Providers].[name])) = UPPER(TRIM([provider].[name])) AND 
			UPPER(TRIM([#Imported_Providers].[plan])) = UPPER(TRIM([provider].[plan]))
	)

	INSERT INTO [data].[Providers] ([name], [plan]) SELECT UPPER(TRIM([name])), UPPER(TRIM([plan])) FROM [#Imported_Providers]
	DROP TABLE [#Imported_Providers]
END;
GO

-- Importar los pacientes desde un archivo CSV
GO
CREATE OR ALTER PROCEDURE [files].[importPatientsCSV]
	@filePath VARCHAR(255),
	@fieldDelimiter VARCHAR(4) = ';'
AS
BEGIN
	IF OBJECT_ID('tempdb..[#Imported_Patients]') IS NOT NULL
		DROP TABLE [#Imported_Patients]

    CREATE TABLE [#Imported_Patients] (
		[firstName] VARCHAR(255) COLLATE Latin1_General_CS_AS,
		[lastName] VARCHAR(255) COLLATE Latin1_General_CS_AS,
		[birthdate] VARCHAR(20),
		[documentName] VARCHAR(20) COLLATE Latin1_General_CS_AS,
		[documentNumber] INT PRIMARY KEY,
		[biologicalSex] VARCHAR(20) COLLATE Latin1_General_CS_AS,
		[genderName] VARCHAR(20) COLLATE Latin1_General_CS_AS,
		[phone] VARCHAR(40),
		[nationalityName] VARCHAR(50) COLLATE Latin1_General_CS_AS,
		[email] VARCHAR(100) COLLATE Latin1_General_CS_AS,
		[street] VARCHAR(255) COLLATE Latin1_General_CS_AS,
		[localityName] VARCHAR(255) COLLATE Latin1_General_CS_AS,
		[provinceName] VARCHAR(255) COLLATE Latin1_General_CS_AS
	)
	
	IF OBJECT_ID('tempdb..[#Imported_Patients_Formatted]') IS NOT NULL
		DROP TABLE [#Imported_Patients_Formatted]
	
	CREATE TABLE [#Imported_Patients_Formatted] (
		[firstName] VARCHAR(255) COLLATE Latin1_General_CS_AS,
		[lastName] VARCHAR(255) COLLATE Latin1_General_CS_AS,
		[birthdate] DATE,
		[documentName] VARCHAR(20) COLLATE Latin1_General_CS_AS,
		[documentNumber] INT PRIMARY KEY,
		[biologicalSex] VARCHAR(20) COLLATE Latin1_General_CS_AS,
		[genderName] VARCHAR(20) COLLATE Latin1_General_CS_AS,
		[phone] VARCHAR(40),
		[nationalityName] VARCHAR(50) COLLATE Latin1_General_CS_AS,
		[email] VARCHAR(100) COLLATE Latin1_General_CS_AS,
		[street] VARCHAR(255) COLLATE Latin1_General_CS_AS,
		[localityName] VARCHAR(255) COLLATE Latin1_General_CS_AS,
		[provinceName] VARCHAR(255) COLLATE Latin1_General_CS_AS
	)
	
	IF OBJECT_ID('tempdb..[#Invalid_Records]') IS NOT NULL
		DROP TABLE [#Invalid_Records]
	
	CREATE TABLE [#Invalid_Records] (
		[firstName] VARCHAR(255) COLLATE Latin1_General_CS_AS,
		[lastName] VARCHAR(255) COLLATE Latin1_General_CS_AS,
		[birthdate] DATE,
		[documentName] VARCHAR(20) COLLATE Latin1_General_CS_AS,
		[documentNumber] INT,
		[biologicalSex] VARCHAR(20) COLLATE Latin1_General_CS_AS,
		[genderName] VARCHAR(20) COLLATE Latin1_General_CS_AS,
		[phone] VARCHAR(40),
		[nationalityName] VARCHAR(50) COLLATE Latin1_General_CS_AS,
		[email] VARCHAR(100) COLLATE Latin1_General_CS_AS,
		[street] VARCHAR(255) COLLATE Latin1_General_CS_AS,
		[localityName] VARCHAR(255) COLLATE Latin1_General_CS_AS,
		[provinceName] VARCHAR(255) COLLATE Latin1_General_CS_AS,
		[error] VARCHAR(255) COLLATE Latin1_General_CS_AS
	)

	EXECUTE [files].[importDataCSV] 
		@destTable = '#Imported_Patients', 
		@filePath = @filePath, 
		@fieldDelimiter = @fieldDelimiter
	
	SET NOCOUNT ON

	INSERT INTO [#Imported_Patients_Formatted]
	SELECT
		UPPER(TRIM([firstName])),
		UPPER(TRIM([lastName])),
		CONVERT(DATE, [birthdate], 103) AS [birthdate],
		UPPER(TRIM([documentName])),
		[documentNumber],
		UPPER(TRIM([biologicalSex])),
		UPPER(TRIM([genderName])),
		[phone],
		UPPER(TRIM([nationalityName])),
		[email],
		UPPER(TRIM([street])),
		UPPER(TRIM([localityName])),
		UPPER(TRIM([provinceName]))
	FROM [#Imported_Patients]
	
	DROP TABLE [#Imported_Patients]

	-- Validaciones
	INSERT INTO [#Invalid_Records]
	SELECT 
		[firstName],
		[lastName],
		[birthdate],
		[documentName],
		[documentNumber],
		[biologicalSex],
		[genderName],
		[phone],
		[nationalityName],
		[email],
		[street],
		[localityName],
		[provinceName],
		'Duplicate records'
	FROM [#Imported_Patients_Formatted] GROUP BY
		[firstName],
		[lastName],
		[birthdate],
		[documentName],
		[documentNumber],
		[biologicalSex],
		[genderName],
		[phone],
		[nationalityName],
		[email],
		[street],
		[localityName],
		[provinceName]
	HAVING COUNT(*) > 1

    INSERT INTO [#Invalid_Records] SELECT *, 'Non-numeric document!' FROM [#Imported_Patients_Formatted]
        WHERE ISNUMERIC([documentNumber]) = 0

    INSERT INTO [#Invalid_Records] SELECT *, 'Over 120 years old!' FROM [#Imported_Patients_Formatted]
        WHERE DATEDIFF(YEAR, [birthdate], GETDATE()) NOT BETWEEN 0 AND 120

    INSERT INTO [#Invalid_Records] SELECT *, 'Invalid email!' FROM [#Imported_Patients_Formatted]
	    WHERE [email] NOT LIKE '%_@_%.%'

	INSERT INTO [#Invalid_Records] 
    SELECT *, 'Duplicate email' FROM [#Imported_Patients_Formatted] AS [IMF]
	WHERE EXISTS (
		SELECT 1 FROM [#Imported_Patients_Formatted]
		WHERE UPPER(TRIM([email])) = UPPER(TRIM([IMF].[email]))
		HAVING COUNT([documentNumber]) > 1
	)
    OR UPPER(TRIM([email])) IN (
		SELECT UPPER(TRIM([email])) FROM [data].[Patients]
	)
	AND [documentNumber] NOT IN (
		SELECT MAX([documentNumber]) FROM [#Imported_Patients_Formatted]
		WHERE UPPER(TRIM([email])) = UPPER(TRIM([IMF].[email]))
		GROUP BY UPPER(TRIM([email]))
		HAVING COUNT([documentNumber]) > 1
	)

	-- Borrar registros inválidos de pacientes importados
	DELETE FROM [#Imported_Patients_Formatted]
	WHERE EXISTS (
    SELECT 1
    FROM [#Invalid_Records] [IR]
    WHERE 
        UPPER(TRIM([IR].[documentName])) = UPPER(TRIM([#Imported_Patients_Formatted].[documentName])) AND
        [IR].[documentNumber] = [#Imported_Patients_Formatted].[documentNumber] 
	)

	-- Agregar información a los registros de pacientes
	BEGIN TRY
		DECLARE	@addressId INT 
		DECLARE	@phone VARCHAR(40) 
		DECLARE @count INT = (SELECT count(1) from [#Imported_Patients_Formatted])
		DECLARE @firstName VARCHAR(255) 
        DECLARE @biologicalSex VARCHAR(20) 
        DECLARE @birthdate DATE
        DECLARE @documentId INT 
        DECLARE @documentName VARCHAR(20) 
        DECLARE @documentNumber INT 
        DECLARE @email VARCHAR(40) 
        DECLARE @genderId INT
        DECLARE @genderName VARCHAR(20)
        DECLARE @lastName VARCHAR(255) 
        DECLARE @localityName VARCHAR(255) 
        DECLARE @nationalityId INT 
        DECLARE @nationalityName VARCHAR(50) 
        DECLARE @provinceName VARCHAR(255) 
        DECLARE @sexChar CHAR(1) 
        DECLARE @street VARCHAR(255) 

		WHILE @count > 0
		BEGIN 
			SELECT TOP(1)
				@firstName = UPPER(TRIM([firstName])),
				@lastName = UPPER(TRIM([lastName])),
				@birthdate = [birthdate],
				@documentName = UPPER(TRIM([documentName])),
				@documentNumber = [documentNumber],
				@biologicalSex = UPPER(TRIM([biologicalSex])),
				@genderName = UPPER(TRIM([genderName])),
				@phone = [phone],
				@nationalityName = UPPER(TRIM([nationalityName])),
				@email = [email],
				@street = UPPER(TRIM([street])),
				@localityName = UPPER(TRIM([localityName])),
				@provinceName = UPPER(TRIM([provinceName]))
			FROM [#Imported_Patients_Formatted]

			EXECUTE [data].[insertPatient] 
				@firstName = @firstName, 
				@lastName = @lastName, 
				@birthdate = @birthdate, 
				@documentName = @documentName, 
				@documentNumber = @documentNumber,
				@biologicalSex = @biologicalSex, 
				@genderName = @genderName, 
				@phone = @phone, 
				@nationalityName = @nationalityName, 
				@email = @email, 
				@street = @street, 
				@localityName = @localityName, 
				@provinceName = @provinceName
			
			DELETE TOP (1) FROM [#Imported_Patients_Formatted]
			SET @count = @count - 1 
		END
	END TRY
	BEGIN CATCH
		DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = 'Error during patient insertion: ' + ERROR_MESSAGE();
		THROW 51004, @errorMessage, 1
	END CATCH
	
	DECLARE @amountOfInvalidRecords INT = (SELECT count(1) FROM [#Invalid_Records])
	
	IF @amountOfInvalidRecords > 0
	BEGIN
        PRINT 'Total number of invalid records: ' + CAST(@amountOfInvalidRecords AS VARCHAR)
		SELECT [error], count(1) AS [amount] FROM [#Invalid_Records]
		GROUP BY [error]
	END
    ELSE PRINT 'Records without errors.'
	
	SET NOCOUNT OFF

    DROP TABLE [#Imported_Patients_Formatted]
	DROP TABLE [#Invalid_Records]
END;
GO

-- Importar las sedes desde un archivo CSV
GO
CREATE OR ALTER PROCEDURE [files].[importHeadquartersCSV]
	@filePath VARCHAR(255),
	@fieldDelimiter VARCHAR(4) = ';'
AS
BEGIN
	IF OBJECT_ID('tempdb..[#Imported_Headquearters]') IS NOT NULL
		DROP TABLE [#Imported_Headquearters]

	CREATE TABLE [#Imported_Headquearters] (
		[name] VARCHAR(255) COLLATE Latin1_General_CS_AS,
		[street] VARCHAR (255) COLLATE Latin1_General_CS_AS,
		[localityName] VARCHAR (255) COLLATE Latin1_General_CS_AS,
		[provinceName] VARCHAR (255) COLLATE Latin1_General_CS_AS
	)

	EXECUTE [files].[importDataCSV] 
		@destTable = '#Imported_Headquearters', 
		@filePath = @filePath, 
		@fieldDelimiter = @fieldDelimiter

	DECLARE @count INT = (SELECT count(1) FROM [#Imported_Headquearters])

	DECLARE @addressId VARCHAR(255)
	DECLARE @localityName VARCHAR(255)
	DECLARE @name VARCHAR(255)
	DECLARE @provinceName VARCHAR(255)
	DECLARE @street VARCHAR(255)

	SET NOCOUNT ON

	WHILE @count > 0
	BEGIN
		SELECT TOP(1)
			@name = UPPER(TRIM([name])),
			@street = UPPER(TRIM([street])),
			@localityName = UPPER(TRIM([localityName])),
			@provinceName = UPPER(TRIM([provinceName]))
		FROM [#Imported_Headquearters]

		EXECUTE [utilities].[getOrInsertAddressId] 
			@addressStreet = @street, 
			@localityName = @localityName, 
			@provinceName = @provinceName, 
			@outAddressId = @addressId OUTPUT

		INSERT INTO [data].[Care_Headquarters] ([name], [addressId]) 
		VALUES (@name, @addressId)
	
		DELETE TOP(1) FROM [#Imported_Headquearters]
		SET @count = @count - 1
	END

	SET NOCOUNT OFF

	DROP TABLE [#Imported_Headquearters]
END;