USE [CURESA];
GO


/* ---------------------------- Verificar Alianza --------------------------- */

SELECT * FROM [datos].[reservas_turnos_medicos];

DECLARE @idPaciente INT = 137;
DECLARE @idPrestador INT = 1;
DECLARE @idCobertura INT;

INSERT INTO [datos].[coberturas] ([id_prestador], [imagen_credencial], [nro_socio]) VALUES (@idPrestador, null, @idPaciente);

SELECT @idCobertura = [id_cobertura] FROM [datos].[coberturas] WHERE [id_prestador] = @idPrestador;
SELECT * FROM [datos].[pacientes] WHERE [id_paciente] = @idPaciente;

UPDATE [datos].[pacientes] SET [id_cobertura] = @idCobertura WHERE [id_paciente] = @idPaciente;
SELECT * FROM [datos].[reservas_turnos_medicos] WHERE [id_paciente] = @idPaciente;

DELETE FROM [datos].[prestadores] WHERE [id_prestador] = @idPrestador;
SELECT * FROM [datos].[reservas_turnos_medicos] WHERE [id_paciente] = @idPaciente;