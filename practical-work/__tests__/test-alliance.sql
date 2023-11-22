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
EXEC [datos].[registrarCobertura] @idPrestador = @idPrestador, @imagenCredencial = null, @nroSocio = @idPaciente;
SELECT * FROM [datos].[coberturas] WHERE [id_prestador] = @idPrestador;

-- Asignar cobertura al paciente
SELECT @idCobertura = [id_cobertura] FROM [datos].[coberturas] WHERE [id_prestador] = @idPrestador;
EXEC [datos].[actualizarPaciente] @idPaciente = @idPaciente, @cobertura = @idCobertura;
SELECT * FROM [datos].[prestadores] WHERE [id_prestador] = @idPrestador;
SELECT * FROM [datos].[reservas_turnos_medicos] WHERE [id_paciente] = @idPaciente;

-- Verificar turnos post-eliminación del prestador
EXEC [datos].[eliminarPrestador] @idPrestador = @idPrestador;
SELECT * FROM [datos].[prestadores] WHERE [id_prestador] = @idPrestador;
SELECT * FROM [datos].[reservas_turnos_medicos] WHERE [id_paciente] = @idPaciente;