USE [CURESA];
GO

/*
    Se requiere la ejecución previa de la semilla: < seed.sql >
*/


/* -------------------------- Actualizar Contraseña ------------------------- */

DECLARE @nuevaContra VARCHAR(255) = 'LaYutaExistePorUstedes62-23';
DECLARE @viejaContra VARCHAR(255) = '12345';
DECLARE @idUsuario INT = NULL;

-- Limpiar registros del test
SELECT @idUsuario = [id_usuario] FROM [datos].[usuarios] WHERE [contraseña] = @nuevaContra;
IF @idUsuario IS NOT NULL
    EXEC [datos].[borrarUsuario] @id = @idUsuario;

-- Crear usuario
EXEC [datos].[insertarUsuario] @contraseña = @viejaContra;
SELECT * FROM [datos].[usuarios] WHERE [contraseña] = @viejaContra;

-- Actualizar contraseña del usuario
SELECT @idUsuario = [id_usuario] FROM [datos].[usuarios] WHERE [contraseña] = @viejaContra;
EXEC [datos].[actualizarUsuario] @idUsuario = @idUsuario, @contraseña = @nuevaContra;
SELECT * FROM [datos].[usuarios] WHERE [id_usuario] = @idUsuario;