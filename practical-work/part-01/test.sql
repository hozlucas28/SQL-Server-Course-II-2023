use [cure_sa];
GO

CREATE TABLE [#pacientes_importados] (
	nombre VARCHAR(255),
	apellido VARCHAR(255),
	fechaNacimiento VARCHAR(20),
	tipoDocumento VARCHAR(255),
	nroDocumento INT,
	sexo VARCHAR(20),
	genero VARCHAR(20),
	telefono VARCHAR(40),
	nacionalidad VARCHAR(255),
	mail VARCHAR(100),
	calleYNro VARCHAR(255),
	localidad VARCHAR(255),
	provincia VARCHAR(255)
);

EXEC [archivos].importarDatosCSV 
@tablaDestino = "#pacientes_importados",
@rutaArchivo = "C:\Users\Gonza\Desktop\TP-BBDDA\Dataset\Pacientes.csv"

Select * from #pacientes_importados

EXEC [archivos].importarPacientesCSV 
@rutaArchivo = "C:\Users\Gonza\Desktop\TP-BBDDA\Dataset\Pacientes.csv",
@rutaArchivoError = "C:\Users\Gonza\Desktop\TP-BBDDA\Dataset\ErrorPacientes.csv"


select * from datos.pacientes;

drop table #pacientes_importados;