USE cure_sa;

--- CAMBIAR ESTA RUTA SOLAMENTE
DECLARE @rutaDataSet VARCHAR(255) = '"C:\importar';

DECLARE @rutaMedicos VARCHAR(255) = CONCAT(@rutaDataSet,'\Medicos.csv');
DECLARE @rutaPrestador VARCHAR(255) = CONCAT(@rutaDataSet,'\Prestador.csv');
DECLARE @rutaPacientes VARCHAR(255) = CONCAT(@rutaDataSet,'\Pacientes.csv');
DECLARE @rutaSedes VARCHAR(255) = CONCAT(@rutaDataSet,'\Sedes.csv');

EXEC [archivos].[importarSedesCSV]
	@rutaArchivo = @rutaSedes,
	@separador = ';';

EXEC [archivos].[importarMedicosCSV]
	@rutaArchivo  = @rutaMedicos,
	@separador = ';';

EXEC [archivos].[importarPrestadoresCSV]
	@rutaArchivo  = @rutaPrestador,
	@separador = ';'

EXEC [archivos].[importarPacientesCSV]
	@rutaArchivo = @rutaPacientes,
	@separador = ';'
