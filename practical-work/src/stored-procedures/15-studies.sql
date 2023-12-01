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
        INSERT INTO [data].[estudios] ([nombre_estudio], [id_paciente], [autorizado], [documento_resultado], [fecha], [imagen_resultado])
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
        UPDATE [data].[estudios]
        SET [nombre_estudio] = ISNULL(@nombreEstudio, [nombre_estudio]),
            [id_paciente] = ISNULL(@idPaciente, [id_paciente]),
            [autorizado] = ISNULL(@autorizado, [autorizado]),
            [documento_resultado] = ISNULL(@documentoResultado, [documento_resultado]),
            [fecha] = ISNULL(@fecha, [fecha]),
            [imagen_resultado] = ISNULL(@imagenResultado, [imagen_resultado])
        WHERE [id_estudio] = @idEstudio
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
        UPDATE [data].[estudios]
        SET [autorizado] = 0
        WHERE [id_estudio] = @idEstudio
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error durante la eliminación lógica: ' + @errorMessage;
        THROW
    END CATCH
END;
