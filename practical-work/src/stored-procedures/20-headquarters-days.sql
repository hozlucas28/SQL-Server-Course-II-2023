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
    INSERT INTO [data].[dias_x_sede] ([dia], [hora_inicio], [hora_fin], [id_medico], [id_sede])
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
        UPDATE [data].[dias_x_sede]
        SET [dia] = ISNULL(@dia, [dia]),
            [hora_inicio] = ISNULL(@horaInicio, [hora_inicio]),
            [hora_fin] = ISNULL(@horaFin, [hora_fin]),
            [id_medico] = ISNULL(@idMedico, [id_medico]),
            [id_sede] = ISNULL(@idSede, [id_sede])
        WHERE [id_dias_x_sede] = @idDiasXSede
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
        UPDATE [data].[dias_x_sede]
        SET [alta] = 0
        WHERE [id_sede] = @idSede
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error durante la eliminación lógica: ' + @errorMessage;
        THROW
    END CATCH
END;