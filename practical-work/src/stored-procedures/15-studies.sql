USE [CURESA];
GO


/* ------------------ Procedimientos Almacenados - Estudios ----------------- */

-- Registrar estudio
CREATE OR ALTER PROCEDURE [datos].[registrarEstudio]
    @nombre_estudio VARCHAR(60),
    @id_paciente INT,
    @autorizado BIT = 1,
    @documento_resultado VARCHAR(128) = NULL,
    @fecha DATE,
    @imagen_resultado VARCHAR(128) = NULL
AS
BEGIN
    BEGIN TRY
        INSERT INTO [datos].[estudios] ([nombre_estudio], [id_paciente], [autorizado], [documento_resultado], [fecha], [imagen_resultado])
        VALUES (@nombre_estudio, @id_paciente, @autorizado, @documento_resultado, @fecha, @imagen_resultado)
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
CREATE OR ALTER PROCEDURE [datos].[actualizarEstudio]
    @id_estudio INT,
    @nombre_estudio VARCHAR(60),
    @id_paciente INT,
    @autorizado BIT = 1,
    @documento_resultado VARCHAR(128) = NULL,
    @fecha DATE,
    @imagen_resultado VARCHAR(128) = NULL
AS
BEGIN
    BEGIN TRY
        UPDATE [datos].[estudios]
        SET [nombre_estudio] = @nombre_estudio,
            [id_paciente] = @id_paciente,
            [autorizado] = @autorizado,
            [documento_resultado] = @documento_resultado,
            [fecha] = @fecha,
            [imagen_resultado] = @imagen_resultado
        WHERE [id_estudio] = @id_estudio
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
CREATE OR ALTER PROCEDURE [datos].[eliminarEstudio]
    @id_estudio INT
AS
BEGIN
    BEGIN TRY
        UPDATE [datos].[estudios]
        SET [autorizado] = 0
        WHERE [id_estudio] = @id_estudio
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error durante la eliminación lógica: ' + @errorMessage;
        THROW
    END CATCH
END;
