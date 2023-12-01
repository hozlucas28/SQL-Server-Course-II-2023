USE [CURESA];
GO


/* ----- Procedimientos Almacenados - Exportaciones De Turnos Atendidos ----- */

-- Exportar turnos atendidos a un archivo XML
CREATE OR ALTER PROCEDURE [files].[exportarTurnosAtendidosXML]
    @obraSocial VARCHAR(50),
    @fechaInicio DATE,
    @fechaFin DATE,
    @cadenaXML NVARCHAR(MAX) OUTPUT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [data].[Providers] pr WHERE pr.[nombre] = @obraSocial)
        RETURN

    IF @fechaInicio > @fechaFin 
    BEGIN	
        PRINT('Fecha inicio mayor a fecha fin.')
        RETURN
    END

    SET @cadenaXML = (
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
        FROM [data].[Medical_Appointment_Reservations] t
        INNER JOIN [data].[Medics] m ON t.[id_medico] = m.[id_medico]
        INNER JOIN [data].[Specialties] e ON t.[id_especialidad] = e.[id_especialidad]
        INNER JOIN [data].[Patients] p ON t.[id_paciente] = p.[id_paciente]
        INNER JOIN [data].[Coverages] c ON p.[id_cobertura] = c.[id_cobertura]
        INNER JOIN [data].[Providers] pr ON c.[id_prestador] = pr.[id_prestador]
        WHERE
            pr.[nombre] = @obraSocial AND
            t.[fecha] BETWEEN @fechaInicio AND @fechaFin
        FOR XML PATH('Turno'), ROOT('Turnos')
    )
END;