USE [cure_sa]
GO

CREATE OR ALTER TRIGGER [datos].[quitarTurnos] 
ON [datos].[prestadores]
AFTER DELETE
AS
BEGIN
    IF OBJECT_ID('tempdb..#TurnosACancelar') IS NOT NULL 
        DROP TABLE #TurnosACancelar

    CREATE TABLE #TurnosACancelar (id_turno INT PRIMARY KEY);

    INSERT INTO #TurnosACancelar (id_turno)
    SELECT rtm.id_turno
    FROM [datos].[reservas_turnos_medicos] rtm
    INNER JOIN [datos].[pacientes] p ON rtm.id_paciente = p.id_paciente
    INNER JOIN [datos].[coberturas] c ON p.id_cobertura = c.id_cobertura
    INNER JOIN deleted d ON c.id_prestador = d.id_prestador;

    DECLARE @idTurno INT;
     
    DECLARE @count INT;
    SELECT @count = COUNT(*) FROM #TurnosACancelar;

    WHILE @count > 0
    BEGIN
        SELECT TOP 1 @idTurno = id_turno FROM #TurnosACancelar;

        EXEC [datos].[cancelarTurnoMedico] @idTurno;

        DELETE FROM #TurnosACancelar WHERE id_turno = @idTurno;

        SET @count = @count - 1;
    END;

    DROP TABLE #TurnosACancelar;
END
