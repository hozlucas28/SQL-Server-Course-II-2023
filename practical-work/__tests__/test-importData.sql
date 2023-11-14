USE [CURESA];
GO

/* ----------------------------- Importar Datos ----------------------------- */

-- Pacientes
EXEC [archivos].[importarPacientesCSV] @rutaArchivo = "C:\importar\Pacientes.csv";
SELECT TOP 10 * FROM [datos].[pacientes];
GO

-- Prestadores
EXEC [archivos].[importarPrestadoresCSV] @rutaArchivo = "C:\importar\Prestador.csv";
SELECT TOP 10 * FROM [datos].[prestadores];
GO

-- Médicos
EXEC [archivos].[importarMedicosCSV] @rutaArchivo = "C:\importar\Medicos.csv";
SELECT TOP 10 * FROM [datos].[medicos];
GO

-- Sedes
EXEC [archivos].[importarSedesCSV] @rutaArchivo = "C:\importar\Sedes.csv";
SELECT TOP 10 * FROM [datos].[sede_de_atencion];

-- Estudios válidos
EXEC [archivos].[importarEstudiosJSON] @rutaArchivo = "C:\importar\Centro_Autorizaciones.Estudios clinicos.json";
SELECT TOP 10 * FROM [datos].[estudiosValidos]
GO