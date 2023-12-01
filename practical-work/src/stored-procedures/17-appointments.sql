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
        [m].[id_medico], 
		[m].[id_especialidad], 
	    [s].[id_sede], 
		[s].[direccion],
		[dxs].[id_dias_x_sede],
		[t].[hora] as [horaTurno],
		[t].[id_tipo_turno] AS [idTipoTurno],
		[t].[id_estado_turno] as [idEstadoTurno]
    INTO [#disponibilidad]
    FROM [data].[Days_X_Headquarter] AS [dxs]
	JOIN [data].[Medics] AS [m] ON [m].[id_medico] = [dxs].[id_medico]
    JOIN [data].[Care_Headquarters] AS [s] ON [s].[id_sede] = [dxs].[id_sede]
    LEFT JOIN [data].[Medical_Appointment_Reservations] AS [t] ON [dxs].[id_dias_x_sede] = [t].[id_dias_x_sede]
    WHERE
        [m].[nombre] = @nombreMedico AND
        [m].[apellido] = @apellidoMedico AND
        [s].[nombre] = @nombreSede AND
        [dxs].[dia] = @fecha AND
        [dxs].[hora_inicio] < @hora AND
        [dxs].[hora_fin] > DATEADD(MINUTE, 15, @hora)
	
	IF @@ROWCOUNT > 0
	BEGIN
		IF EXISTS (SELECT 1 FROM [#disponibilidad] WHERE [horaTurno] IS NOT NULL AND [idTipoTurno] = @idTipoTurno AND [idEstadoTurno] = 1)
			SELECT @horaTurnoAnterior = max([horaTurno]) 
			FROM [#disponibilidad] 
			WHERE [horaTurno] < @hora AND [idTipoTurno] = @idTipoTurno AND [idEstadoTurno] = @idTurnoPendiente

		IF @horaTurnoAnterior IS NULL OR DATEADD(MINUTE, 15, @horaTurnoAnterior) <= @hora
		BEGIN
			SELECT TOP 1 @idMedico = [id_medico], 
				@idSede = [id_sede], 
				@idEspecialidad = [id_especialidad], 
				@idDireccionAtencion = [direccion],
				@idDiasXSede = [id_dias_x_sede]
			FROM [#disponibilidad]

			INSERT INTO [data].[Medical_Appointment_Reservations] (
                [fecha],
                [hora],
                [id_medico],
                [id_especialidad],
                [id_direccion_atencion],
                [id_paciente],
                [id_dias_x_sede],
                [id_tipo_turno],
                [id_estado_turno]
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
            SELECT @idTurno = id_turno FROM [data].[Medical_Appointment_Reservations] 
            WHERE @idMedico = id_medico AND @fecha = fecha AND @hora = hora AND @idPaciente = id_paciente
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

    SELECT @idEstado = [id_estado] 
	FROM [data].[Shift_Status] 
	WHERE [nombre] = @estado

    IF @idEstado IS NOT NULL
        UPDATE [data].[Medical_Appointment_Reservations] 
		SET [id_estado_turno] = @idEstado 
		WHERE [id_turno] = @idTurno
END;
GO

-- Cancelar turno
CREATE OR ALTER PROCEDURE [data].[cancelarTurnoMedico]
    @idTurno INT
AS
BEGIN
    DECLARE @idEstado INT

    SELECT @idEstado = [id_estado] 
	FROM [data].[Shift_Status] 
	WHERE [nombre] = 'CANCELADO'

    UPDATE [data].[Medical_Appointment_Reservations] 
	SET [id_estado_turno] = @idEstado 
	WHERE [id_turno] = @idTurno
END;