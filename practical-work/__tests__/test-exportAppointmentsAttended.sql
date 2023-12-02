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
EXEC [data].[registrarCobertura] @idPrestador = @id_prestador, @imagenCredencial = null, @nroSocio = @id_paciente;
SELECT * FROM [data].[Coverages] WHERE [providerId] = @id_prestador;

-- Asignar cobertura a paciente
SELECT @idCobertura = [id] FROM [data].[Coverages] WHERE [providerId] = @id_prestador;
EXEC [data].[actualizarPaciente] @idPaciente = @id_paciente, @cobertura = @idCobertura;
SELECT * FROM [data].[Patients] WHERE [id] = @id_paciente;

-- Exportar turnos atendidos
SELECT @obraSocial = [name] FROM [data].[Providers] WHERE [id] = @id_prestador;
EXEC [files].[exportarTurnosAtendidosXML] @obraSocial = @obraSocial, @fechaInicio = @fechaInicio, @fechaFin = @fechaFin, @cadenaXML = @cadenaXML OUTPUT;

-- Mostrar XML
PRINT @cadenaXML;