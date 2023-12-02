USE [CURESA];
GO


/* ----- Procedimientos Almacenados - Exportaciones De Turnos Atendidos ----- */

-- Mostrar turnos atendidos como XML
CREATE OR ALTER PROCEDURE [files].[showShiftsAttendedAsXML]
    @endDate DATE,
    @providerName VARCHAR(50),
    @startDate DATE,
    @outXMLString NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET @providerName = UPPER(TRIM(@providerName))

    IF NOT EXISTS (SELECT 1 FROM [data].[Providers] AS [provider] WHERE UPPER(TRIM([provider].[name])) = @providerName)
        RETURN

    IF @startDate > @endDate 
    BEGIN	
        PRINT '• Error: Start date is greater than end date!'
        RETURN
    END

    SET @outXMLString = (
        SELECT
            UPPER(TRIM([patient].[firstName])) AS "patient/firstName",
            UPPER(TRIM([patient].[lastName])) AS "patient/lastName",
            [patient].[documentNumber] AS "patient/documentNumber",
            [patient].[documentId] AS "patient/documentId",
            UPPER(TRIM([medic].[firstName])) AS "medic/firstName",
            UPPER(TRIM([medic].[lastName])) AS "medic/lastName",
            UPPER(TRIM([speciality].[name])) AS "medic/specialityName",
            [medic].[medicalLicense] AS "medic/medicalLicense",
            [reservation].[date] AS "date",
            [reservation].[hour] AS "hour"
        FROM [data].[Medical_Appointment_Reservations] AS [reservation]
        INNER JOIN [data].[Medics] AS [medic] ON [reservation].[medicId] = [medic].[id]
        INNER JOIN [data].[Specialties] AS [speciality] ON [reservation].[specialtyId] = [speciality].[id]
        INNER JOIN [data].[Patients] AS [patient] ON [reservation].[patientId] = [patient].[id]
        INNER JOIN [data].[Coverages] AS [coverage] ON [patient].[coverageId] = [coverage].[id]
        INNER JOIN [data].[Providers] AS [provider] ON [coverage].[providerId] = [provider].[id]
        WHERE
            UPPER(TRIM([provider].[name])) = @providerName AND
            [reservation].[date] BETWEEN @startDate AND @endDate
        FOR XML PATH('shift'), ROOT('shifts')
    )
END;