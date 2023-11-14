USE [CURESA]
GO

-- Pacientes

EXEC [archivos].importarPacientesCSV 
    @rutaArchivo = "..\dataset\Pacientes.csv";

-- Prestadores

EXEC [archivos].importarPrestadoresCSV 
    @rutaArchivo = "..\dataset\Prestador.csv"

-- Medicos

EXEC [archivos].[importarMedicosCSV]
    @rutaArchivo = "..\dataset\Medicos.csv";

-- Sedes

EXEC [archivos].importarSedesCSV
    @rutaArchivo = "..\dataset\Sedes.csv";

-- Estudios Validos

EXEC [archivos].[importarEstudiosJSON]
    @rutaArchivo = "..\Centro_Autorizaciones.Estudios clinicos.json";

-- Borrar

-- delete from datos.[pacientes];

-- delete from datos.[prestadores];

-- delete from datos.[medicos];

-- delete from datos.[sede_de_atencion];

-- delete from datos.estudiosValidos