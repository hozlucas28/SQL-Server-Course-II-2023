use [cure_sa];
GO

--Tablas temporales para importar CSV en pacientes

CREATE TABLE [#pacientes_importados] (
	nombre VARCHAR(255),
	apellido VARCHAR(255),
	fechaNacimiento VARCHAR(20),
	tipoDocumento VARCHAR(50),
	nroDocumento INT,
	sexo VARCHAR(20),
	genero VARCHAR(20),
	telefono VARCHAR(40),
	nacionalidad VARCHAR(50),
	mail VARCHAR(100),
	calleYNro VARCHAR(255),
	localidad VARCHAR(255),
	provincia VARCHAR(255)
);
GO

/*
EXEC [archivos].importarDatosCSV 
@tablaDestino = '#pacientes_importados',
@rutaArchivo = "C:\Users\Gonza\Desktop\TP-BBDDA\Dataset\Pacientes.csv"
select * from #pacientes_importados
delete from #pacientes_importados
*/

CREATE TABLE [#pacientes_importados] (
	nombre VARCHAR(255),
	apellido VARCHAR(255),
	fechaNacimiento VARCHAR(20),
	tipoDocumento VARCHAR(50),
	nroDocumento INT,
	sexo VARCHAR(20),
	genero VARCHAR(20),
	telefono VARCHAR(40),
	nacionalidad VARCHAR(50),
	mail VARCHAR(100),
	calleYNro VARCHAR(255),
	localidad VARCHAR(255),
	provincia VARCHAR(255)
);
GO

CREATE TABLE [#pacientes_importados_formateados] (
	nombre VARCHAR(255),
	apellido VARCHAR(255),
	fechaNacimiento DATE,
	tipoDocumento VARCHAR(50),
	nroDocumento INT,
	sexo VARCHAR(20),
	genero VARCHAR(20),
	telefono VARCHAR(40),
	nacionalidad VARCHAR(50),
	mail VARCHAR(100),
	calleYNro VARCHAR(255),
	localidad VARCHAR(255),
	provincia VARCHAR(255)
);
GO

CREATE TABLE [#registros_invalidos] (
	nombre VARCHAR(255),
	apellido VARCHAR(255),
	fechaNacimiento DATE,
	tipoDocumento VARCHAR(255),
	nroDocumento INT,
	sexo VARCHAR(20),
	genero VARCHAR(20),
	telefono VARCHAR(40),
	nacionalidad VARCHAR(255),
	mail VARCHAR(100),
	calleYNro VARCHAR(255),
	localidad VARCHAR(255),
	provincia VARCHAR(255),
	error_desc VARCHAR(255)
);
GO

-- Colocar ubicación de archivo CSV
EXEC [archivos].importarPacientesCSV 
@rutaArchivo = "C:\Users\Gonza\Desktop\TP-BBDDA\Dataset\Pacientes.csv",
@rutaArchivoError = "C:\Users\Gonza\Desktop\TP-BBDDA\Dataset\ErrorPacientes.csv"

select * from datos.pacientes;
select * from #registros_invalidos;

delete from datos.pacientes;

/*
	- En caso de un throw borrar tablas temporales

	drop table #pacientes_importados;
	drop table #pacientes_importados_formateados;
	drop table #registros_invalidos;
*/