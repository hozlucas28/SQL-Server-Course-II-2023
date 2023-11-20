USE [CURESA];
GO


/* ----------------- Procedimientos Almacenados - Coberturas ---------------- */

-- Registrar cobertura
CREATE OR ALTER PROCEDURE [datos].[registrarCobertura]
    @idPrestador INT,
    @imagenCredencial VARCHAR (128),
    @nroSocio VARCHAR(30)
AS
BEGIN
    BEGIN TRY
        INSERT INTO [datos].[coberturas] ([id_prestador], [imagen_credencial], [nro_socio])
        VALUES (@idPrestador, @imagenCredencial, @nroSocio)
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error durante la inserción: ' + @errorMessage;
        THROW
    END CATCH
END;
GO

-- Actualizar cobertura
CREATE OR ALTER PROCEDURE [datos].[actualizarCobertura]
    @fechaRegistro DATE = NULL,
    @idCobertura INT,
    @idPrestador INT = NULL,
    @imagenCredencial VARCHAR (128) = NULL,
    @nroSocio VARCHAR(30) = NULL
AS
BEGIN
    BEGIN TRY
        UPDATE [datos].[coberturas]
        SET [fecha_registro] = ISNULL(@fechaRegistro, [fecha_registro]),
            [id_prestador] = ISNULL(@idPrestador, [id_prestador]),
            [imagen_credencial] = ISNULL(@imagenCredencial, [imagen_credencial]),
            [nro_socio] = ISNULL(@nroSocio, [nro_socio])
        WHERE [id_cobertura] = @idCobertura
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error durante la actualización: ' + @errorMessage;
        THROW
    END CATCH
END;
GO

-- Eliminar cobertura (forma lógica)
CREATE OR ALTER PROCEDURE [datos].[eliminarCobertura]
    @idCobertura INT
AS
BEGIN
    BEGIN TRY
        UPDATE [datos].[coberturas]
        SET [borrado] = 1
        WHERE [id_cobertura] = @idCobertura
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error durante la eliminación lógica: ' + @errorMessage;
        THROW
    END CATCH
END;
