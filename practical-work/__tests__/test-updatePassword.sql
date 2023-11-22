USE [CURESA];
GO


/* -------------------------- Actualizar Contraseña ------------------------- */

DECLARE @nuevaContra VARCHAR(255) = 'LaYutaExistePorUstedes62-23';
DECLARE @viejaContra VARCHAR(255) = '12345';
DECLARE @id_usuario INT = NULL;

-- Limpiar registros del test
SELECT @id_usuario = [id_usuario] FROM [datos].[usuarios] WHERE [contraseña] = @nuevaContra;
IF @id_usuario IS NOT NULL
    EXEC [datos].[borrarUsuario] @id = @id_usuario;

-- Crear usuario
EXEC [datos].[insertarUsuario] @contraseña = @viejaContra;
SELECT * FROM [datos].[usuarios] WHERE [contraseña] = @viejaContra;

-- Actualizar contraseña del usuario
SELECT @id_usuario = [id_usuario] FROM [datos].[usuarios] WHERE [contraseña] = @viejaContra;
EXEC [datos].[actualizarUsuario] @idUsuario = @id_usuario, @contraseña = @nuevaContra;
SELECT * FROM [datos].[usuarios] WHERE [id_usuario] = @id_usuario;