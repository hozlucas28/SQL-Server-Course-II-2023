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
    IF NOT EXISTS (SELECT 1 FROM [data].[Providers] pr WHERE pr.[name] = @obraSocial)
        RETURN

    IF @fechaInicio > @fechaFin 
    BEGIN	
        PRINT('Fecha inicio mayor a fecha fin.')
        RETURN
    END

    SET @cadenaXML = (
        SELECT
            p.[lastName] AS "Paciente/Apellido",
            p.[name] AS "Paciente/Nombre",
            p.[documentId] AS "Paciente/TipoDocumento",
            p.[documentNumber] AS "Paciente/NumeroDocumento",
            m.[lastName] AS "Profesional/Apellido",
            m.[name] AS "Profesional/Nombre",
            m.[medicalLicense] AS "Profesional/Matricula",
            t.[date] AS "Fecha",
            t.[hour] AS "Hora",
            e.[name] AS "Especialidad"
        FROM [data].[Medical_Appointment_Reservations] t
        INNER JOIN [data].[Medics] m ON t.[medicId] = m.[id]
        INNER JOIN [data].[Specialties] e ON t.[specialtyId] = e.[id]
        INNER JOIN [data].[Patients] p ON t.[patientId] = p.[id]
        INNER JOIN [data].[Coverages] c ON p.[coverageId] = c.[id]
        INNER JOIN [data].[Providers] pr ON c.[providerId] = pr.[id]
        WHERE
            pr.[name] = @obraSocial AND
            t.[date] BETWEEN @fechaInicio AND @fechaFin
        FOR XML PATH('Turno'), ROOT('Turnos')
    )
END;