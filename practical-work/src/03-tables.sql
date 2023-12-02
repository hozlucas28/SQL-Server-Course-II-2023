USE [CURESA];
GO


/* ----------------------------- Eliminar Tablas ---------------------------- */

IF OBJECT_ID('[utilities].[Addresses]', 'U') IS NOT NULL
    DROP TABLE [utilities].[Addresses];

IF OBJECT_ID('[utilities].[Localities]', 'U') IS NOT NULL
    DROP TABLE [utilities].[Localities];

IF OBJECT_ID('[utilities].[Provinces]', 'U') IS NOT NULL
    DROP TABLE [utilities].[Provinces];

IF OBJECT_ID('[utilities].[Countries]', 'U') IS NOT NULL
    DROP TABLE [utilities].[Countries];

IF OBJECT_ID('[utilities].[Nationalities]', 'U') IS NOT NULL
    DROP TABLE [utilities].[Nationalities];

IF OBJECT_ID('[utilities].[Documents]', 'U') IS NOT NULL
    DROP TABLE [utilities].[Documents];

IF OBJECT_ID('[utilities].[Genders]', 'U') IS NOT NULL
    DROP TABLE [utilities].[Genders];

IF OBJECT_ID('[data].[Shifts]', 'U') IS NOT NULL
    DROP TABLE [data].[Shifts];

IF OBJECT_ID('[data].[Shift_Status]', 'U') IS NOT NULL
    DROP TABLE [data].[Shift_Status];

IF OBJECT_ID('[data].[Days_X_Headquarter]', 'U') IS NOT NULL
    DROP TABLE [data].[Days_X_Headquarter];

IF OBJECT_ID('[data].[Care_Headquarters]', 'U') IS NOT NULL
    DROP TABLE [data].[Care_Headquarters];

IF OBJECT_ID('[data].[Specialties]', 'U') IS NOT NULL
    DROP TABLE [data].[Specialties];

IF OBJECT_ID('[data].[Providers]', 'U') IS NOT NULL
    DROP TABLE [data].[Providers];

IF OBJECT_ID('[data].[Coverages]', 'U') IS NOT NULL
    DROP TABLE [data].[Coverages];

IF OBJECT_ID('[data].[Researches]', 'U') IS NOT NULL
    DROP TABLE [data].[Researches];

IF OBJECT_ID('[data].[Valid_Researches]', 'U') IS NOT NULL
    DROP TABLE [data].[Valid_Researches];

IF OBJECT_ID('[data].[Patients]', 'U') IS NOT NULL
    DROP TABLE [data].[Patients];

IF OBJECT_ID('[data].[Users]', 'U') IS NOT NULL
    DROP TABLE [data].[Users];

IF OBJECT_ID('[data].[Medics]', 'U') IS NOT NULL
    DROP TABLE [data].[Medics];

IF OBJECT_ID('[data].[Medical_Appointment_Reservations]', 'U') IS NOT NULL
    DROP TABLE [data].[Medical_Appointment_Reservations];
GO


/* ------------------------------ Crear Tablas ------------------------------ */

CREATE TABLE [utilities].[Genders]
(
    [id] INT IDENTITY (1, 1),
    [name] VARCHAR(50) NOT NULL
);

CREATE TABLE [utilities].[Countries]
(
    [demonym] VARCHAR(50) UNIQUE NOT NULL,
    [id] INT IDENTITY (1, 1),
    [name] VARCHAR(50) NOT NULL
);

CREATE TABLE [utilities].[Provinces]
(
    [countryId] INT,
    [id] INT IDENTITY (1, 1),
    [name] VARCHAR(50) NOT NULL
);

CREATE TABLE [utilities].[Localities]
(
    [id] INT IDENTITY (1, 1),
    [name] VARCHAR(50) NOT NULL,
    [provinceId] INT
);

CREATE TABLE [utilities].[Addresses]
(
    [countryId] INT,
    [department] SMALLINT,
    [floor] SMALLINT,
    [id] INT IDENTITY (1, 1),
    [localityId] INT NOT NULL,
    [postalCode] SMALLINT,
    [provinceId] INT NOT NULL,
    [street] VARCHAR(50) NOT NULL
);

CREATE TABLE [utilities].[Documents]
(
    [id] INT IDENTITY (1, 1),
    [name] VARCHAR(50) NOT NULL
);

CREATE TABLE [utilities].[Nationalities]
(
    [id] INT IDENTITY (1,1),
    [name] VARCHAR(50) NOT NULL
);

CREATE TABLE [data].[Patients]
(
    [addressId] INT,
    [alternativePhone] VARCHAR(20),
    [biologicalSex] CHAR(1),
    [birthdate] DATE NOT NULL,
    [coverageId] INT,
    [documentId] INT NOT NULL,
    [documentNumber] VARCHAR(50) NOT NULL,
    [email] VARCHAR (70) UNIQUE NOT NULL,
    [genderId] INT NOT NULL,
    [id] INT IDENTITY (1, 1),
    [lastName] VARCHAR (50) NOT NULL,
    [maternalLastName] VARCHAR (50),
    [name] VARCHAR (50) NOT NULL,
    [nationalityId] INT,
    [phone] VARCHAR(20) NOT NULL,
    [photo] VARCHAR(128),
    [profesionalPhone] VARCHAR(20),
    [registrationDate] DATE DEFAULT CAST(GETDATE () AS DATE),
    [updateDate] DATE,
    [userUpdate] INT,
    [valid] BIT DEFAULT 1
);

CREATE TABLE [data].[Researches]
(
    [authorized] BIT DEFAULT 1,
    [date] DATE NOT NULL,
    [document] VARCHAR (128),
    [id] INT IDENTITY (1, 1),
    [imageUrl] VARCHAR (128),
    [name] VARCHAR(60) NOT NULL,
    [patientId] INT
);

CREATE TABLE [data].[Valid_Researches]
(
    [area] NVARCHAR(255) NOT NULL,
    [coveragePercentage] INT NOT NULL,
    [id] VARCHAR(255) NOT NULL,
    [plan] NVARCHAR(255) NOT NULL,
    [price] DECIMAL(18, 2) NOT NULL,
    [providerId] INT NOT NULL,
    [requiresAuthorization] BIT DEFAULT 0,
    [research] NVARCHAR(255) NOT NULL,
    [totalPrice] AS (price * (1 - CAST(coveragePercentage AS DECIMAL) / 100))
);

CREATE TABLE [data].[Users]
(
    [creationDate] DATE DEFAULT CAST(GETDATE () AS DATE),
    [id] INT IDENTITY (1, 1),
    [password] VARCHAR(256),
    [patientId] INT
);

CREATE TABLE [data].[Coverages]
(
    [deleted] BIT DEFAULT 0,
    [id] INT IDENTITY (1, 1),
    [imageUrl] VARCHAR (128),
    [membershipNumber] VARCHAR(30) NOT NULL,
    [providerId] INT,
    [registrationDate] DATE DEFAULT CAST(GETDATE () AS DATE)
);

CREATE TABLE [data].[Providers]
(
    [deleted] BIT DEFAULT 0,
    [id] INT IDENTITY (1, 1),
    [name] VARCHAR(50) NOT NULL,
    [plan] VARCHAR(30) NOT NULL
);

CREATE TABLE [data].[Medical_Appointment_Reservations]
(
    [careHeadquartersId] INT NOT NULL,
    [date] DATE DEFAULT CAST (GETDATE () AS DATE),
    [daysXHeadquarterId] INT NOT NULL,
    [hour] TIME DEFAULT CAST(GETDATE () AS TIME),
    [id] INT IDENTITY (1, 1),
    [medicId] INT NOT NULL,
    [patientId] INT NOT NULL,
    [shiftId] INT NOT NULL,
    [shiftStatusId] INT NOT NULL,
    [specialtyId] INT NOT NULL
);

CREATE TABLE [data].[Shift_Status]
(
    [id] INT IDENTITY (1, 1),
    [name] CHAR (15)
);

CREATE TABLE [data].[Shifts]
(
    [id] INT IDENTITY (1, 1),
    [modality] CHAR (15)
);

CREATE TABLE [data].[Days_X_Headquarter]
(
	[id] INT IDENTITY(1,1),
    [enabled] BIT DEFAULT 1,
    [careHeadquarterId] INT NOT NULL,
    [day] DATE NOT NULL,
    [endTime] TIME NOT NULL,
    [medicId] INT NOT NULL,
    [startTime] TIME NOT NULL
);

CREATE TABLE [data].[Care_Headquarters]
(
    [addressId] INT,
    [id] INT IDENTITY (1, 1),
    [name] VARCHAR(100) NOT NULL
);

CREATE TABLE [data].[Medics]
(
    [enabled] BIT DEFAULT 1,
    [id] INT IDENTITY (1, 1),
    [lastName] VARCHAR (50) NOT NULL,
    [medicalLicense] INT NOT NULL,
    [name] VARCHAR (50) NOT NULL,
    [specialtyId] INT
);

CREATE TABLE [data].[Specialties]
(
    [id] INT IDENTITY (1, 1),
    [name] VARCHAR(50) NOT NULL
);