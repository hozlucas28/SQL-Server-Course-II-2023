USE [CURESA];
GO

/*
    Se requiere la ejecución previa de los siguientes tests:
        1° - < test-importData.sql >
        2° - < test-insertAppointments.sql > (por cada iteración del presente test)
*/


/* ---------------------------- Verificar Alianza --------------------------- */

DECLARE @idPaciente INT = 137;
DECLARE @idPrestador INT = 1;
DECLARE @idCobertura INT;

-- Registrar cobertura
EXEC [data].[registrarCobertura] @idPrestador = @idPrestador, @imagenCredencial = null, @nroSocio = @idPaciente;
SELECT * FROM [data].[Coverages] WHERE [id_prestador] = @idPrestador;

-- Asignar cobertura al paciente
SELECT @idCobertura = [id_cobertura] FROM [data].[Coverages] WHERE [id_prestador] = @idPrestador;
EXEC [data].[actualizarPaciente] @idPaciente = @idPaciente, @cobertura = @idCobertura;
SELECT * FROM [data].[Providers] WHERE [id_prestador] = @idPrestador;
SELECT * FROM [data].[Medical_Appointment_Reservations] WHERE [id_paciente] = @idPaciente;

-- Verificar turnos post-eliminación del prestador
EXEC [data].[eliminarPrestador] @idPrestador = @idPrestador;
SELECT * FROM [data].[Providers] WHERE [id_prestador] = @idPrestador;
SELECT * FROM [data].[Medical_Appointment_Reservations] WHERE [id_paciente] = @idPaciente;