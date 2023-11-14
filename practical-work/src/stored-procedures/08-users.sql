USE [CURESA];
GO


/* ------------------ Procedimientos Almacenados - Usuarios ----------------- */

-- Actualizar contraseña
CREATE OR ALTER PROCEDURE [datos].[actualizarContraseña]
    @idUsuario INT,
    @contraseña VARCHAR(256)
AS
BEGIN
    UPDATE [datos].[usuarios] SET [contraseña] = @contraseña WHERE [id_usuario] = @idUsuario
END;