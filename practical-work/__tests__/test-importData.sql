USE [CURESA]
GO

-- Pacientes

EXEC [archivos].importarPacientesCSV 
    @rutaArchivo = "C:\importar\Pacientes.csv";

select top 10 

-- Prestadores

EXEC [archivos].importarPrestadoresCSV 
    @rutaArchivo = "C:\importar\Prestador.csv"

select top 10 from datos.prestadores

-- Medicos

EXEC [archivos].[importarMedicosCSV]
    @rutaArchivo = "C:\importar\Medicos.csv";

select top 10 from datos.medicos

-- Sedes

EXEC [archivos].importarSedesCSV
    @rutaArchivo = "C:\importar\Sedes.csv";

select top 10 from datos.sede_de_atencion

-- Estudios Validos [Personal Técnico Clínico]

EXEC [archivos].[importarEstudiosJSON]
    @rutaArchivo = "C:\importar\Centro_Autorizaciones.Estudios clinicos.json";

select top 10 from datos.estudiosValidos

-- Borrar

-- delete from datos.[pacientes];

-- delete from datos.[prestadores];

-- delete from datos.[medicos];

-- delete from datos.[sede_de_atencion];

-- delete from datos.estudiosValidos