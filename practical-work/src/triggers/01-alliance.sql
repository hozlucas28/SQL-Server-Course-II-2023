USE [CURESA];
GO

CREATE OR ALTER TRIGGER [data].[quitarTurnos] ON [data].[prestadores] INSTEAD OF DELETE
AS
BEGIN
    IF OBJECT_ID('tempdb..[#TurnosACancelar]') IS NOT NULL 
        DROP TABLE [#TurnosACancelar]

    CREATE TABLE [#TurnosACancelar] ([id_turno] INT PRIMARY KEY)

    INSERT INTO [#TurnosACancelar] ([id_turno])
    SELECT [rtm].[id_turno]
    FROM [data].[reservas_turnos_medicos] [rtm]
    INNER JOIN [data].[pacientes] p ON [rtm].[id_paciente] = [p].[id_paciente]
    INNER JOIN [data].[coberturas] c ON [p].[id_cobertura] = [c].[id_cobertura]
    INNER JOIN [deleted] d ON [c].[id_prestador] = [d].[id_prestador]

    DECLARE @idTurno INT

    DECLARE @count INT
    SELECT @count = COUNT(*) FROM [#TurnosACancelar]

    WHILE @count > 0
    BEGIN
        SELECT TOP 1 @idTurno = [id_turno] FROM [#TurnosACancelar]

        EXEC [data].[cancelarTurnoMedico] @idTurno

        DELETE FROM [#TurnosACancelar] WHERE [id_turno] = @idTurno

        SET @count = @count - 1
    END

    UPDATE [data].[prestadores]
    SET borrado = 1
    WHERE id_prestador IN (SELECT id_prestador FROM deleted)

    DROP TABLE [#TurnosACancelar]
END;