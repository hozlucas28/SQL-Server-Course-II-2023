USE [CURESA];
GO

/*
    Se requiere la ejecución previa de los siguientes tests:
        1° - < test-importData.sql >
        2° - < test-insertAppointments.sql > (por cada iteración del presente test)
*/


/* ---------------------------- Verificar Alianza --------------------------- */

DECLARE @coverageId INT;
DECLARE @patientId INT = 137;
DECLARE @providerId INT = 1;

-- Registrar cobertura
EXECUTE [data].[insertCoverage] @providerId = @providerId, @imageUrl = null, @membershipNumber = @patientId;
SELECT * FROM [data].[Coverages] WHERE [providerId] = @providerId;

-- Asignar cobertura al paciente
SELECT @coverageId = [id] FROM [data].[Coverages] WHERE [providerId] = @providerId;
EXECUTE [data].[updatePatient] @patientId = @patientId, @coverageId = @coverageId;
SELECT * FROM [data].[Providers] WHERE [id] = @providerId;
SELECT * FROM [data].[Medical_Appointment_Reservations] WHERE [patientId] = @patientId;

-- Verificar turnos post-eliminación del prestador
EXECUTE [data].[deleteProvider] @providerId = @providerId;
SELECT * FROM [data].[Providers] WHERE [id] = @providerId;
SELECT * FROM [data].[Medical_Appointment_Reservations] WHERE [patientId] = @patientId;