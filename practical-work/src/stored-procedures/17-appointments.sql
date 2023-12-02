USE [CURESA];
GO


/* ------------------- Procedimientos Almacenados - Turnos ------------------ */

-- Insertar turno
CREATE OR ALTER PROCEDURE [data].[registrarTurnoMedico]
    @idPaciente INT,
    @fecha DATE,
    @hora TIME,
    @nombreMedico VARCHAR(255),
    @apellidoMedico VARCHAR(255),
    @especialidad VARCHAR(255) = NULL,
    @nombreSede VARCHAR(255),
    @tipoTurno VARCHAR(255),
    @idTurno INT = NULL OUTPUT
AS
BEGIN
	DECLARE @horaTurnoAnterior TIME = NULL
	DECLARE @idDiasXSede INT
	DECLARE @idDireccionAtencion INT
	DECLARE @idEspecialidad INT
	DECLARE @idMedico INT
	DECLARE @idSede INT
	DECLARE @idTipoTurno INT
	DECLARE @idTurnoPendiente INT = 1

	IF UPPER(@tipoTurno) = 'PRESENCIAL' SET @idTipoTurno = 1
	ELSE IF UPPER(@tipoTurno) = 'VIRTUAL' SET @idTipoTurno = 2
	ELSE return

	SELECT
        [m].[id], 
		[m].[specialtyId], 
	    [s].[id] as [careHeadquarterId], 
		[s].[addressId] AS [addressId],
		[dxs].[id] as [daysXHeadquarterId],
		[t].[hour] as [horaTurno],
		[t].[shiftId] AS [idTipoTurno],
		[t].[shiftStatusId] as [idEstadoTurno]
    INTO [#disponibilidad]
    FROM [data].[Days_X_Headquarter] AS [dxs]
	JOIN [data].[Medics] AS [m] ON [m].[id] = [dxs].[medicId]
    JOIN [data].[Care_Headquarters] AS [s] ON [s].[id] = [dxs].[careHeadquarterId]
    LEFT JOIN [data].[Medical_Appointment_Reservations] AS [t] ON [dxs].[id] = [t].[daysXHeadquarterId]
    WHERE
        [m].[name] = @nombreMedico AND
        [m].[lastName] = @apellidoMedico AND
        [s].[name] = @nombreSede AND
        [dxs].[day] = @fecha AND
        [dxs].[startTime] < @hora AND
        [dxs].[endTime] > DATEADD(MINUTE, 15, @hora)
	
	IF @@ROWCOUNT > 0
	BEGIN
		IF EXISTS (SELECT 1 FROM [#disponibilidad] WHERE [horaTurno] IS NOT NULL AND [idTipoTurno] = @idTipoTurno AND [idEstadoTurno] = 1)
			SELECT @horaTurnoAnterior = max([horaTurno]) 
			FROM [#disponibilidad] 
			WHERE [horaTurno] < @hora AND [idTipoTurno] = @idTipoTurno AND [idEstadoTurno] = @idTurnoPendiente

		IF @horaTurnoAnterior IS NULL OR DATEADD(MINUTE, 15, @horaTurnoAnterior) <= @hora
		BEGIN
			SELECT TOP 1 @idMedico = [medicId], 
				@idSede = [careHeadquarterId], 
				@idEspecialidad = [specialtyId], 
				@idDireccionAtencion = [addressId],
				@idDiasXSede = [daysXHeadquarterId]
			FROM [#disponibilidad]

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
                @fecha,
                @hora,
                @idMedico,
                @idEspecialidad,
                @idDireccionAtencion,
                @idPaciente,
                @idDiasXSede,
                @idTipoTurno,
                @idTurnoPendiente
            )
            SELECT @idTurno = [shiftId] FROM [data].[Medical_Appointment_Reservations] 
            WHERE @idMedico = [medicId] AND @fecha = [date] AND @hora = [hour] AND @idPaciente = [patientId]
		END
		ELSE
			PRINT '- No se pudo registrar el turno ( sin disponibilidad )'
	END

	DROP TABLE [#disponibilidad]
END;
GO

-- Actualizar turno
CREATE OR ALTER PROCEDURE [data].[actualizarTurnoMedico]
    @idTurno INT,
    @estado VARCHAR(255)
AS
BEGIN
    DECLARE @idEstado INT = NULL

    IF @estado = 'CANCELADO'
		RETURN

    SELECT @idEstado = [id] 
	FROM [data].[Shift_Status] 
	WHERE [name] = @estado

    IF @idEstado IS NOT NULL
        UPDATE [data].[Medical_Appointment_Reservations] 
		SET [shiftStatusId] = @idEstado 
		WHERE [id] = @idTurno
END;
GO

-- Cancelar turno
CREATE OR ALTER PROCEDURE [data].[cancelMedicalAppointment]
    @shiftId INT
AS
BEGIN
    DECLARE @idEstado INT

    SELECT @idEstado = [id] 
	FROM [data].[Shift_Status] 
	WHERE [name] = 'CANCELADO'

    UPDATE [data].[Medical_Appointment_Reservations] 
	SET [shiftStatusId] = @idEstado 
	WHERE [id] = @shiftId
END;