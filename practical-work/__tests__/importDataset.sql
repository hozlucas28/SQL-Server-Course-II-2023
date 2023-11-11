USE [CURESA]
GO

-- Pacientes

EXEC [archivos].importarPacientesCSV 
    @rutaArchivo = "C:\Users\gonza\Facultad\Bases de Datos Aplicada\TP-Grupal\Dataset\Pacientes.csv";

select * from datos.pacientes;


-- Prestadores

EXEC [archivos].importarPrestadoresCSV 
    @rutaArchivo = "C:\Users\gonza\Facultad\Bases de Datos Aplicada\TP-Grupal\Dataset\Prestador.csv"

select * from datos.prestadores;


-- Medicos

EXEC [archivos].[importarMedicosCSV]
    @rutaArchivo = "C:\Users\gonza\Facultad\Bases de Datos Aplicada\TP-Grupal\Dataset\Medicos.csv";

select * from datos.medicos;


-- Sedes

EXEC [archivos].importarSedesCSV
    @rutaArchivo = "C:\Users\gonza\Facultad\Bases de Datos Aplicada\TP-Grupal\Dataset\Sedes.csv";

select * from datos.sede_de_atencion;


-- Estudios Validos

EXEC [archivos].[importarEstudiosJSON]
    @rutaArchivo = "C:\Users\gonza\Facultad\Bases de Datos Aplicada\TP-Grupal\Dataset\Centro_Autorizaciones.Estudios clinicos.json";

SELECT * FROM [datos].estudiosValidos

-- Borrar

delete from datos.[pacientes];

delete from datos.[prestadores];

delete from datos.[medicos];

delete from datos.[sede_de_atencion];

delete from datos.estudiosValidos