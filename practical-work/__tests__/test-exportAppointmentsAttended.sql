USE [CURESA];
GO

/*
    Se requiere la ejecución previa de los siguientes tests:
        1° - < test-importData.sql >
        2° - < test-insertAppointments.sql >
*/


/* ------------------------ Exportar Turnos Atendidos ----------------------- */

DECLARE @XMLString NVARCHAR(MAX);
DECLARE @endDate DATE = '2022-12-31';
DECLARE @startDate DATE = '2022-12-01';
DECLARE @patientId INT = 137;
DECLARE @providerId INT = 1;
DECLARE @coverageId INT;
DECLARE @providerName VARCHAR(50);

-- Registrar cobertura
EXECUTE [data].[insertCoverage] @providerId = @providerId, @imageUrl = null, @membershipNumber = @patientId;
SELECT * FROM [data].[Coverages] WHERE [providerId] = @providerId;

-- Asignar cobertura a paciente
SELECT @coverageId = [id] FROM [data].[Coverages] WHERE [providerId] = @providerId;
EXECUTE [data].[updatePatient] @patientId = @patientId, @coverageId = @coverageId;
SELECT * FROM [data].[Patients] WHERE [id] = @patientId;

-- Exportar turnos atendidos
SELECT @providerName = [name] FROM [data].[Providers] WHERE [id] = @providerId;
EXECUTE [files].[showShiftsAttendedAsXML] @providerName = @providerName, @startDate = @startDate, @endDate = @endDate, @outXMLString = @XMLString OUTPUT;

-- Mostrar XML
PRINT @XMLString;