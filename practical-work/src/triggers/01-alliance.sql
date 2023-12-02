USE [CURESA];
GO


CREATE OR ALTER TRIGGER [data].[deleteShifts] ON [data].[Providers] INSTEAD OF DELETE
AS
BEGIN
    DECLARE @count INT
    DECLARE @shiftId INT

    IF OBJECT_ID('tempdb..[#Shifts_To_Cancel]') IS NOT NULL 
        DROP TABLE [#Shifts_To_Cancel]

    CREATE TABLE [#Shifts_To_Cancel] ([id] INT PRIMARY KEY)

    INSERT INTO [#Shifts_To_Cancel] ([id])
        SELECT [Medical_Appointment_Reservations].[id]
            FROM [data].[Medical_Appointment_Reservations]
                INNER JOIN [data].[Patients] ON [Medical_Appointment_Reservations].[patientId] = [Patients].[id]
                INNER JOIN [data].[Coverages] ON [Patients].[coverageId] = [Coverages].[id]
                INNER JOIN [deleted] ON [Coverages].[providerId] = [deleted].[id]

    SELECT @count = COUNT(*) FROM [#Shifts_To_Cancel]

    WHILE @count > 0
    BEGIN
        SELECT TOP 1 @shiftId = [id] FROM [#Shifts_To_Cancel]
        EXECUTE [data].[deleteMedicalAppointmentReservation] @shiftId = @shiftId
        DELETE FROM [#Shifts_To_Cancel] WHERE [id] = @shiftId
        SET @count = @count - 1
    END

    UPDATE [data].[Providers] SET [deleted] = 1 WHERE [id] IN (SELECT [id] FROM [deleted])
    DROP TABLE [#Shifts_To_Cancel]
END;