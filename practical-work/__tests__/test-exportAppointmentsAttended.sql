USE [CURESA];
GO

/*
    Se requiere la ejecución previa de los siguientes tests:
        1° - < test-importData.sql >
        2° - < test-insertAppointments.sql >
*/


/* ------------------------ Exportar Turnos Atendidos ----------------------- */

DECLARE @cadenaXML NVARCHAR(MAX);
DECLARE @fechaFin DATE = '2022-12-31';
DECLARE @fechaInicio DATE = '2022-12-01'
DECLARE @id_paciente INT = 137;
DECLARE @id_prestador INT = 1;
DECLARE @idCobertura INT;
DECLARE @obraSocial VARCHAR(50);

-- Registrar cobertura
EXEC [datos].[registrarCobertura] @idPrestador = @id_prestador, @imagenCredencial = null, @nroSocio = @id_paciente;
SELECT * FROM [datos].[coberturas] WHERE [id_prestador] = @id_prestador;

-- Asignar cobertura a paciente
SELECT @idCobertura = [id_cobertura] FROM [datos].[coberturas] WHERE [id_prestador] = @id_prestador;
EXEC [datos].[actualizarPaciente] @idPaciente = @id_paciente, @cobertura = @idCobertura;
SELECT * FROM [datos].[pacientes] WHERE [id_paciente] = @id_paciente;

-- Exportar turnos atendidos
SELECT @obraSocial = [nombre] FROM [datos].[prestadores] WHERE [id_prestador] = @id_prestador;
EXEC [archivos].[exportarTurnosAtendidosXML] @obraSocial = @obraSocial, @fechaInicio = @fechaInicio, @fechaFin = @fechaFin, @cadenaXML = @cadenaXML OUTPUT;

-- Mostrar XML
PRINT @cadenaXML;