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

-- Estudios Validos [Personal Técnico Clínico]

EXEC [archivos].[importarEstudiosJSON]
    @rutaArchivo = "C:\Users\gonza\Desktop\SQL-Server-Course-II-2023\practical-work\dataset\Centro_Autorizaciones.Estudios clinicos.json";

select * from datos.estudiosValidos

-- Borrar

-- delete from datos.[pacientes];

-- delete from datos.[prestadores];

-- delete from datos.[medicos];

-- delete from datos.[sede_de_atencion];

-- delete from datos.estudiosValidos