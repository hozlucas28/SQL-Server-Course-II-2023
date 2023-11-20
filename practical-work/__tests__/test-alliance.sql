USE [CURESA];
GO


/* ---------------------------- Verificar Alianza --------------------------- */

DECLARE @id_paciente INT = 137;
DECLARE @id_prestador INT = 1;
DECLARE @idCobertura INT;

SELECT * FROM [datos].[reservas_turnos_medicos];

EXEC [datos].[registrarCobertura] @idPrestador = @id_prestador, @imagenCredencial = null, @nroSocio = @id_paciente;

SELECT * FROM [datos].[coberturas] WHERE [id_prestador] = @id_prestador;

SELECT @idCobertura = [id_cobertura] FROM [datos].[coberturas] WHERE [id_prestador] = @id_prestador;
EXEC [datos].[actualizarPaciente] @idPaciente = @id_paciente, @cobertura = @idCobertura;

SELECT * FROM [datos].[prestadores] WHERE [id_prestador] = @id_prestador;
SELECT * FROM [datos].[reservas_turnos_medicos] WHERE [id_paciente] = @id_Paciente;

EXEC [datos].[eliminarPrestador] @idPrestador = @id_prestador;

SELECT * FROM [datos].[prestadores];
SELECT * FROM [datos].[reservas_turnos_medicos] WHERE [id_paciente] = @id_Paciente;