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
SELECT * FROM [data].[coberturas] WHERE [id_prestador] = @id_prestador;

-- Asignar cobertura a paciente
SELECT @idCobertura = [id_cobertura] FROM [data].[coberturas] WHERE [id_prestador] = @id_prestador;
EXEC [data].[actualizarPaciente] @idPaciente = @id_paciente, @cobertura = @idCobertura;
SELECT * FROM [data].[pacientes] WHERE [id_paciente] = @id_paciente;

-- Exportar turnos atendidos
SELECT @obraSocial = [nombre] FROM [data].[prestadores] WHERE [id_prestador] = @id_prestador;
EXEC [files].[exportarTurnosAtendidosXML] @obraSocial = @obraSocial, @fechaInicio = @fechaInicio, @fechaFin = @fechaFin, @cadenaXML = @cadenaXML OUTPUT;

-- Mostrar XML
PRINT @cadenaXML;