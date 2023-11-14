USE [CURESA];
GO

/* ---------------------------- BULK INSERT ---------------------------- */

-- Pacientes

EXEC [archivos].importarPacientesCSV 
    @rutaArchivo = ".\dataset\Pacientes.csv";

-- Prestadores

EXEC [archivos].importarPrestadoresCSV 
    @rutaArchivo = ".\dataset\Prestador.csv"

-- Medicos

EXEC [archivos].[importarMedicosCSV]
    @rutaArchivo = ".\dataset\Medicos.csv";

-- Sedes

EXEC [archivos].importarSedesCSV
    @rutaArchivo = ".\dataset\Sedes.csv";

-- Estudios Validos [Personal Técnico Clínico]

EXEC [archivos].[importarEstudiosJSON]
    @rutaArchivo = ".\Centro_Autorizaciones.Estudios clinicos.json";
