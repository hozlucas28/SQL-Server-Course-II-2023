USE [CURESA];
GO

/*
    Se requiere la ejecución previa de la semilla: < seed.sql >
*/


/* ----------------------------- Importar Datos ----------------------------- */

-- Pacientes
EXEC [files].[importarPacientesCSV] @rutaArchivo = "C:\importar\Pacientes.csv";
SELECT TOP 10 * FROM [data].[pacientes];
GO

-- Prestadores
EXEC [files].[importarPrestadoresCSV] @rutaArchivo = "C:\importar\Prestador.csv";
SELECT TOP 10 * FROM [data].[prestadores];
GO

-- Médicos
EXEC [files].[importarMedicosCSV] @rutaArchivo = "C:\importar\Medicos.csv";
SELECT TOP 10 * FROM [data].[medicos];
GO

-- Sedes
EXEC [files].[importarSedesCSV] @rutaArchivo = "C:\importar\Sedes.csv";
SELECT TOP 10 * FROM [data].[sede_de_atencion];

-- Estudios válidos
EXEC [files].[importarEstudiosJSON] @rutaArchivo = "C:\importar\Centro_Autorizaciones.Estudios clinicos.json";
SELECT TOP 10 * FROM [data].[estudiosValidos];