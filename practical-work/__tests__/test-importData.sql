USE [CURESA];
GO
SELECT * FROM [data].[Valid_Researches];
/*
    Se requiere la ejecución previa de la semilla: < seed.sql >
*/


/* ----------------------------- Importar Datos ----------------------------- */

-- Pacientes
EXECUTE [files].[importPatientsCSV] @filePath = "C:\data\patients.csv";
SELECT TOP 10 * FROM [data].[Patients];
GO

-- Prestadores
EXECUTE [files].[importProvidersCSV] @filePath = "C:\data\providers.csv";
SELECT TOP 10 * FROM [data].[Providers];
GO

-- Médicos
EXECUTE [files].[importMedicsCSV] @filePath = "C:\data\medics.csv";
SELECT TOP 10 * FROM [data].[Medics];
GO

-- Sedes
EXECUTE [files].[importHeadquartersCSV] @filePath = "C:\data\headquarters.csv";
SELECT TOP 10 * FROM [data].[Care_Headquarters];

-- Estudios válidos
EXECUTE [files].[importResearchesJSON] @filePath = "C:\data\researches.json";
SELECT TOP 10 * FROM [data].[Valid_Researches];