USE [CURESA];
GO


/* ---------------- Procedimientos Almacenados - Prestadores ---------------- */

-- Registrar prestador
CREATE OR ALTER PROCEDURE [data].[registrarPrestador]
    @nombre VARCHAR(50),
    @planPrestador VARCHAR(30)
AS
BEGIN
    BEGIN TRY
        INSERT INTO [data].[Providers] ([name], [plan])
        VALUES (@nombre, @planPrestador)
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error durante la inserción: ' + @errorMessage;
        THROW
    END CATCH
END;
GO

-- Actualizar prestador
CREATE OR ALTER PROCEDURE [data].[actualizarPrestador]
    @idPrestador INT,
    @nombre VARCHAR(50) = NULL,
    @planPrestador VARCHAR(30) = NULL
AS
BEGIN
    BEGIN TRY
        UPDATE [data].[Providers]
        SET [name] = ISNULL(@nombre, [name]),
            [plan] = ISNULL(@planPrestador, [plan])
        WHERE [id] = @idPrestador
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error durante la actualización: ' + @errorMessage;
        THROW
    END CATCH
END;
GO

-- Eliminar prestador (forma lógica)
CREATE OR ALTER PROCEDURE [data].[eliminarPrestador]
    @idPrestador INT
AS
BEGIN
    BEGIN TRY
        DELETE FROM [data].[Providers] WHERE [id] = @idPrestador
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error durante la eliminación lógica: ' + @errorMessage;
        THROW
    END CATCH
END;
