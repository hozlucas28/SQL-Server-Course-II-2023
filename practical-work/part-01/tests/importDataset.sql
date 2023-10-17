use [cure_sa]
go

EXEC [archivos].importarPacientesCSV 
    @rutaArchivo = "C:\Users\gonza\Desktop\Facultad\Bases de Datos Aplicada\TP-Grupal\Dataset\Pacientes.csv";

EXEC [archivos].importarPrestadoresCSV 
    @rutaArchivo = "C:\Users\gonza\Desktop\Facultad\Bases de Datos Aplicada\TP-Grupal\Dataset\Prestador.csv"

EXEC [archivos].[importarMedicosCSV]
    @rutaArchivo = "C:\Users\gonza\Desktop\Facultad\Bases de Datos Aplicada\TP-Grupal\Dataset\Medicos.csv";

EXEC [archivos].importarSedesCSV
    @rutaArchivo = "C:\Users\gonza\Desktop\Facultad\Bases de Datos Aplicada\TP-Grupal\Dataset\Sedes.csv";

select top 10 * from datos.pacientes;

select * from datos.prestadores;

select * from datos.medicos;

select * from datos.sedes;

delete from datos.pacientes;
delete from datos.prestadores;
delete from datos.medicos;
delete from datos.sedes;