USE [CURESA]
GO

CREATE OR ALTER PROCEDURE [archivos].[exportarTurnosAtendidosXML]
    @obraSocial VARCHAR(50),
	@fechaInicio DATE,
	@fechaFin DATE,
	@cadenaXML NVARCHAR(255) OUTPUT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM [datos].[prestadores] pr WHERE pr.[nombre] = @obraSocial)
		RETURN;

	SELECT
		p.[apellido] AS "Paciente/Apellido",
		p.[nombre] AS "Paciente/Nombre",
		p.[id_tipo_documento] AS "Paciente/TipoDocumento",
		p.[nro_documento] AS "Paciente/NumeroDocumento",
		m.[apellido] AS "Profesional/Apellido",
		m.[nombre] AS "Profesional/Nombre",
		m.[nro_matricula] AS "Profesional/Matricula",
		t.[fecha] AS "Fecha",
		t.[hora] AS "Hora",
		e.[nombre] AS "Especialidad"
	FROM [datos].[reservas_turnos_medicos] t
	INNER JOIN [datos].[medicos] m ON t.[id_medico] = m.[id_medico]
	INNER JOIN [datos].[especialidad] e ON t.[id_especialidad] = e.[id_especialidad]
	INNER JOIN [datos].[pacientes] p ON t.[id_paciente] = p.[id_paciente]
	INNER JOIN [datos].[coberturas] c ON p.[id_cobertura] = c.[id_cobertura]
	INNER JOIN [datos].[prestadores] pr ON c.[id_prestador] = pr.[id_prestador]
	WHERE
		pr.[nombre] = @obraSocial AND
		t.[fecha] BETWEEN @fechaInicio AND @fechaFin
	FOR XML PATH('Turno'), ROOT('Turnos')
END