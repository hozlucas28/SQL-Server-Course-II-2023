USE [CURESA];
GO


/* ---------------- Procedimientos Almacenados - Días X Sede ---------------- */

-- Registrar días x sede
CREATE OR ALTER PROCEDURE [data].[insertarDiasXSede]
	@dia DATE,
    @horaInicio TIME,
    @horaFin TIME,
    @idMedico INT,
    @idSede INT
AS
BEGIN
    INSERT INTO [data].[Days_X_Headquarter] ([day], [startTime], [endTime], [medicId], [careHeadquarterId])
        VALUES (@dia, @horaInicio, @horaFin, @idMedico, @idSede);
END;
GO

-- Actualizar días x sede
CREATE OR ALTER PROCEDURE [data].[actualizarDiasXSede]
    @dia DATE = NULL,
    @horaInicio TIME = NULL,
    @horaFin TIME = NULL,
    @idMedico INT = NULL,
	@idDiasXSede INT,
    @idSede INT = NULL
AS
BEGIN
    BEGIN TRY
        UPDATE [data].[Days_X_Headquarter]
        SET [day] = ISNULL(@dia, [day]),
            [startTime] = ISNULL(@horaInicio, [startTime]),
            [endTime] = ISNULL(@horaFin, [endTime]),
            [medicId] = ISNULL(@idMedico, [medicId]),
            [careHeadquarterId] = ISNULL(@idSede, [careHeadquarterId])
        WHERE [id] = @idDiasXSede
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error durante la actualización: ' + @errorMessage;
        THROW
    END CATCH
END;
GO

-- Eliminar días x sede
CREATE OR ALTER PROCEDURE [data].[eliminarDiasXSede]
    @idSede INT
AS
BEGIN
    BEGIN TRY
        UPDATE [data].[Days_X_Headquarter]
        SET [enabled] = 0
        WHERE [careHeadquarterId] = @idSede
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error durante la eliminación lógica: ' + @errorMessage;
        THROW
    END CATCH
END;