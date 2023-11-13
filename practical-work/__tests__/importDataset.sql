USE [CURESA]
GO

-- Pacientes

EXEC [archivos].importarPacientesCSV 
    @rutaArchivo = "C:\importar\Pacientes.csv";

-- Prestadores

EXEC [archivos].importarPrestadoresCSV 
    @rutaArchivo = "C:\importar\Prestador.csv"

-- Medicos

EXEC [archivos].[importarMedicosCSV]
    @rutaArchivo = "C:\importar\Medicos.csv";

-- Sedes

EXEC [archivos].importarSedesCSV
    @rutaArchivo = "C:\importar\Sedes.csv";

-- Estudios Validos

EXEC [archivos].[importarEstudiosJSON]
    @rutaArchivo = "C:\importar\Centro_Autorizaciones.Estudios clinicos.json";

-- Borrar

-- delete from datos.[pacientes];

-- delete from datos.[prestadores];

-- delete from datos.[medicos];

-- delete from datos.[sede_de_atencion];

-- delete from datos.estudiosValidos