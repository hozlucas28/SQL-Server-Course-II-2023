GO
USE [cure_sa];

-- Actualizar contraseña
CREATE OR ALTER PROCEDURE [datos].[actualizarContraseña]
    @idUsuario INT,
    @contraseña VARCHAR(256) COLLATE Latin1_General_CS_AS
AS
BEGIN
    UPDATE [datos].[usuarios] SET contraseña = @contraseña WHERE id_usuario = @idUsuario;
END;