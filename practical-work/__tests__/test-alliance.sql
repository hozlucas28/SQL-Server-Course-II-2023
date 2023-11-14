USE [CURESA];
GO

/* ---------------------------- Verificar Alianza --------------------------- */

-- Pacientes
EXEC [archivos].[importarPacientesCSV] @rutaArchivo = "C:\Users\gonza\Desktop\SQL-Server-Course-II-2023\practical-work\dataset\Pacientes.csv";
SELECT TOP 10 * FROM [datos].[pacientes];
GO

-- Prestadores
EXEC [archivos].[importarPrestadoresCSV] @rutaArchivo = "C:\Users\gonza\Desktop\SQL-Server-Course-II-2023\practical-work\dataset\Prestador.csv";
SELECT TOP 10 * FROM [datos].[prestadores];
GO

-- Médicos
EXEC [archivos].[importarMedicosCSV] @rutaArchivo = "C:\Users\gonza\Desktop\SQL-Server-Course-II-2023\practical-work\dataset\Medicos.csv";
SELECT TOP 10 * FROM [datos].[medicos];
GO

-- Sedes
EXEC [archivos].[importarSedesCSV] @rutaArchivo = "C:\Users\gonza\Desktop\SQL-Server-Course-II-2023\practical-work\dataset\Sedes.csv";
SELECT TOP 10 * FROM [datos].[sede_de_atencion];


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