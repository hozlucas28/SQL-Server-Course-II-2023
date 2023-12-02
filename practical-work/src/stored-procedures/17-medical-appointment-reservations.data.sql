USE [CURESA];
GO


/* ------------------- Procedimientos Almacenados - Turnos ------------------ */

-- Insertar una reserva de cita médica
CREATE OR ALTER PROCEDURE [data].[insertMedicalAppointmentReservation]
    @date DATE,
    @headquarterName VARCHAR(255),
    @hour TIME,
    @medicLastName VARCHAR(255),
    @medicFirstName VARCHAR(255),
    @outShiftId INT = NULL OUTPUT,
    @patientId INT,
    @shiftModality VARCHAR(255),
    @specialtyName VARCHAR(255) = NULL
AS
BEGIN
	DECLARE @addressId INT
	DECLARE @daysXHeadquarterId INT
	DECLARE @headquartedId INT
	DECLARE @lastShiftHour TIME = NULL
	DECLARE @medicId INT
	DECLARE @shiftId INT
	DECLARE @shiftStatusId INT = 1
	DECLARE @specialtyId INT

    SET @medicFirstName = UPPER(TRIM(@medicFirstName))
    SET @medicLastName = UPPER(TRIM(@medicLastName))
    SET @specialtyName = UPPER(TRIM(@specialtyName))
    SET @headquarterName = UPPER(TRIM(@headquarterName))
    SET @shiftModality = UPPER(TRIM(@shiftModality))

    IF OBJECT_ID('tempdb..[#Availability]') IS NOT NULL
		DROP TABLE [#Availability]

    IF EXISTS (SELECT 1 FROM [data].[Shifts] WHERE UPPER(TRIM([modality])) = @shiftModality)
        SELECT @shiftId = [id] FROM [data].[Shifts] WHERE UPPER(TRIM([modality])) = @shiftModality
    ELSE
        BEGIN
        PRINT 'Could not register the appointment (modality not found)!'
        RETURN
        END

	SELECT
        [medic].[id] as [medicId], 
		[medic].[specialtyId], 
	    [careHeadquarter].[id] as [careHeadquarterId], 
		[careHeadquarter].[addressId] AS [addressId],
		[dayXHeadquarter].[id] as [daysXHeadquarterId],
		[reservation].[hour] as [hour],
		[reservation].[shiftId] AS [shiftId],
		[reservation].[shiftStatusId] as [shiftStatusId]
    INTO [#Availability]
    FROM [data].[Days_X_Headquarter] AS [dayXHeadquarter]
	    JOIN [data].[Medics] AS [medic] ON [medic].[id] = [dayXHeadquarter].[medicId]
        JOIN [data].[Care_Headquarters] AS [careHeadquarter] ON [careHeadquarter].[id] = [dayXHeadquarter].[careHeadquarterId]
        LEFT JOIN [data].[Medical_Appointment_Reservations] AS [reservation] ON [dayXHeadquarter].[id] = [reservation].[daysXHeadquarterId]
    WHERE
        [medic].[firstName] = @medicFirstName AND
        [medic].[lastName] = @medicLastName AND
        [careHeadquarter].[name] = @headquarterName AND
        [dayXHeadquarter].[day] = @date AND
        [dayXHeadquarter].[startTime] < @hour AND
        [dayXHeadquarter].[endTime] > DATEADD(MINUTE, 15, @hour)
	
	IF @@ROWCOUNT > 0
	BEGIN
		IF EXISTS (SELECT 1 FROM [#Availability] WHERE [hour] IS NOT NULL AND [shiftId] = @shiftId AND [shiftStatusId] = 1)
			SELECT @lastShiftHour = max([hour]) 
			FROM [#Availability] 
			WHERE [hour] < @hour AND [shiftId] = @shiftId AND [shiftStatusId] = @shiftStatusId

		IF @lastShiftHour IS NULL OR DATEADD(MINUTE, 15, @lastShiftHour) <= @hour
		BEGIN
			SELECT TOP 1 @medicId = [medicId], 
				@headquartedId = [careHeadquarterId], 
				@specialtyId = [specialtyId], 
				@addressId = [addressId],
				@daysXHeadquarterId = [daysXHeadquarterId]
			FROM [#Availability]

			INSERT INTO [data].[Medical_Appointment_Reservations] (
                [date],
                [hour],
                [medicId],
                [specialtyId],
                [careHeadquartersId],
                [patientId],
                [daysXHeadquarterId],
                [shiftId],
                [shiftStatusId]
            ) VALUES (
                @date,
                @hour,
                @medicId,
                @specialtyId,
                @addressId,
                @patientId,
                @daysXHeadquarterId,
                @shiftId,
                @shiftStatusId
            )
            SELECT @outShiftId = [shiftId] FROM [data].[Medical_Appointment_Reservations] 
            WHERE @medicId = [medicId] AND @date = [date] AND @hour = [hour] AND @patientId = [patientId]
		END
		ELSE
            PRINT 'Could not register the appointment (no availability)!'
	END

	DROP TABLE [#Availability]
END;
GO

-- Actualizar una reserva de cita médica
CREATE OR ALTER PROCEDURE [data].[updateMedicalAppointmentReservation]
    @shiftId INT,
    @state VARCHAR(255)
AS
BEGIN
    DECLARE @stateId INT = NULL

    SET @state = UPPER(TRIM(@state))
    IF @state NOT IN ('ATTENDED', 'MISSING', 'CANCELLED', 'PENDING')
        RETURN

    SELECT @stateId = [id] FROM [data].[Shift_Status] WHERE [status] = @state

    IF @stateId IS NOT NULL
        UPDATE [data].[Medical_Appointment_Reservations] SET [shiftStatusId] = @stateId WHERE [id] = @shiftId
END;
GO

-- Borrar una reserva de cita médica (forma lógica)
CREATE OR ALTER PROCEDURE [data].[deleteMedicalAppointmentReservation]
    @shiftId INT
AS
BEGIN
    DECLARE @stateId INT

    SELECT @stateId = [id] FROM [data].[Shift_Status] WHERE [status] = 'CANCELLED'

    UPDATE [data].[Medical_Appointment_Reservations] SET [shiftStatusId] = @stateId WHERE [id] = @shiftId
END;