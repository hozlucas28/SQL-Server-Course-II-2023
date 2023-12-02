USE [CURESA];
GO

CREATE OR ALTER TRIGGER [data].[quitarTurnos] ON [data].[Providers] INSTEAD OF DELETE
AS
BEGIN
    IF OBJECT_ID('tempdb..[#TurnosACancelar]') IS NOT NULL 
        DROP TABLE [#TurnosACancelar]

    CREATE TABLE [#TurnosACancelar] ([id] INT PRIMARY KEY)

    INSERT INTO [#TurnosACancelar] ([id])
    SELECT [rtm].[id]
    FROM [data].[Medical_Appointment_Reservations] [rtm]
    INNER JOIN [data].[Patients] p ON [rtm].[patientId] = [p].[id]
    INNER JOIN [data].[Coverages] c ON [p].[coverageId] = [c].[id]
    INNER JOIN [deleted] d ON [c].[providerId] = [d].[id]

    DECLARE @idTurno INT

    DECLARE @count INT
    SELECT @count = COUNT(*) FROM [#TurnosACancelar]

    WHILE @count > 0
    BEGIN
        SELECT TOP 1 @idTurno = [id] FROM [#TurnosACancelar]

        EXEC [data].[cancelarTurnoMedico] @idTurno

        DELETE FROM [#TurnosACancelar] WHERE [id] = @idTurno

        SET @count = @count - 1
    END

    UPDATE [data].[Providers]
    SET deleted = 1
    WHERE id IN (SELECT id FROM deleted)

    DROP TABLE [#TurnosACancelar]
END;