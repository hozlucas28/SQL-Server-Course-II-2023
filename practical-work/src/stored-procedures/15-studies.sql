USE [CURESA];
GO


/* ------------------ Procedimientos Almacenados - Estudios ----------------- */

-- Registrar estudio
CREATE OR ALTER PROCEDURE [data].[registrarEstudio]
    @nombreEstudio VARCHAR(60),
    @idPaciente INT,
    @autorizado BIT = 1,
    @documentoResultado VARCHAR(128) = NULL,
    @fecha DATE,
    @imagenResultado VARCHAR(128) = NULL
AS
BEGIN
    BEGIN TRY
        INSERT INTO [data].[Researches] ([name], [patientId], [authorized], [document], [date], [imageUrl])
            VALUES (@nombreEstudio, @idPaciente, @autorizado, @documentoResultado, @fecha, @imagenResultado)
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error durante la inserción: ' + @errorMessage;
        THROW
    END CATCH
END;
GO

-- Actualizar estudio
CREATE OR ALTER PROCEDURE [data].[actualizarEstudio]
    @idEstudio INT = NULL,
    @nombreEstudio VARCHAR(60) = NULL,
    @idPaciente INT = NULL,
    @autorizado BIT = NULL,
    @documentoResultado VARCHAR(128) = NULL,
    @fecha DATE = NULL,
    @imagenResultado VARCHAR(128) = NULL
AS
BEGIN
    BEGIN TRY
        UPDATE [data].[Researches]
        SET [name] = ISNULL(@nombreEstudio, [name]),
            [patientId] = ISNULL(@idPaciente, [patientId]),
            [authorized] = ISNULL(@autorizado, [authorized]),
            [document] = ISNULL(@documentoResultado, [document]),
            [date] = ISNULL(@fecha, [date]),
            [imageUrl] = ISNULL(@imagenResultado, [imageUrl])
        WHERE [id] = @idEstudio
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error durante la actualización: ' + @errorMessage;
        THROW
    END CATCH
END;
GO

-- Eliminar estudio (forma lógica)
CREATE OR ALTER PROCEDURE [data].[eliminarEstudio]
    @idEstudio INT
AS
BEGIN
    BEGIN TRY
        UPDATE [data].[Researches]
        SET [authorized] = 0
        WHERE [id] = @idEstudio
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error durante la eliminación lógica: ' + @errorMessage;
        THROW
    END CATCH
END;
