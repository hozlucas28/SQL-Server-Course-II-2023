use [cure_sa]
go

EXEC [archivos].importarPacientesCSV 
@rutaArchivo = "C:\Users\Gonza\Desktop\TP-BBDDA\Dataset\Pacientes.csv",
@rutaArchivoError = "C:\Users\Gonza\Desktop\TP-BBDDA\Dataset\ErrorPacientes.csv"

select * from datos.pacientes;

delete from datos.pacientes;