USE [CURESA];
GO

/*
    Se requiere la ejecución previa de los siguientes tests:
        - < test-importData.sql >
*/


/* ----------------------------- Insertar Turnos ---------------------------- */

/*
    - Caso 1 = Reserva de un turno.
    - Caso 2 = Reserva de un turno 5 minutos despues del primero, por lo que será denegado.
*/

DECLARE @medicLastName VARCHAR(255);
DECLARE @specialtyName VARCHAR(255) = NULL;
DECLARE @date DATE = '2022-12-18';
DECLARE @hour01 TIME = '12:00:00';
DECLARE @hour02 TIME = '12:05:00';
DECLARE @medicId INT;
DECLARE @patientId INT;
DECLARE @headquarterId INT;
DECLARE @medicalAppointmentReservationId INT;
DECLARE @medicFirstName VARCHAR(255);
DECLARE @headquarterName VARCHAR(255);
DECLARE @shiftModality VARCHAR(255) = 'IN-PERSON';

SELECT TOP(1) @patientId = [id] FROM [data].[Patients];
SELECT TOP(1) @medicId = [id], @medicFirstName = [firstName], @medicLastName = [lastName] FROM [data].[Medics];
SELECT TOP(1) @headquarterName = [name], @headquarterId = [id] FROM [data].[Care_Headquarters];

print @patientId;

-- Registrar Días x Sede
EXECUTE [data].[insertDayXHeadquarter]
    @date = @date,
    @startTime = '10:00:00',
    @endTime = '18:00:00',
    @medicId = @medicId,
    @careHeadquarterId = @headquarterId;

-- Insertar turnos y verificar casos
EXECUTE [data].[insertMedicalAppointmentReservation]
    @patientId = @patientId,
    @date = @date,
    @hour = @hour01,
    @medicFirstName = @medicFirstName,
    @medicLastName = @medicLastName,
    @specialtyName = @specialtyName,
    @headquarterName = @headquarterName,
    @shiftModality = @shiftModality,
    @outShiftId = @medicalAppointmentReservationId OUTPUT;

IF @medicalAppointmentReservationId IS NOT NULL
    PRINT '=> [ / ] Case 1 completed successfully (ID: ' + CAST(@medicalAppointmentReservationId AS VARCHAR) + ').'
ELSE
    PRINT '=> [ X ] Case 1 did not complete successfully!';
SELECT * FROM [data].[Medical_Appointment_Reservations] WHERE [id] = @medicalAppointmentReservationId;

EXECUTE [data].[insertMedicalAppointmentReservation]
    @patientId = @patientId,
    @date = @date,
    @hour = @hour02,
    @medicFirstName = @medicFirstName,
    @medicLastName = @medicLastName,
    @specialtyName = @specialtyName,
    @headquarterName = @headquarterName,
    @shiftModality = @shiftModality,
    @outShiftId = @medicalAppointmentReservationId OUTPUT;

IF @medicalAppointmentReservationId = -1
    PRINT '=> [ / ] Case 2 completed successfully (ID: ' + CAST(@medicalAppointmentReservationId AS VARCHAR) + ').'
ELSE
    PRINT '=> [ X ] Case 2 did not complete successfully!';
SELECT * FROM [data].[Medical_Appointment_Reservations] WHERE [id] = @medicalAppointmentReservationId;