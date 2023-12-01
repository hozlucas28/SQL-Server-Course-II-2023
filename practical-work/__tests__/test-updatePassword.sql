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
SELECT @idUsuario = [id_usuario] FROM [data].[Users] WHERE [contraseña] = @nuevaContra;
IF @idUsuario IS NOT NULL
    EXEC [data].[borrarUsuario] @id = @idUsuario;

-- Crear usuario
EXEC [data].[insertarUsuario] @contraseña = @viejaContra;
SELECT * FROM [data].[Users] WHERE [contraseña] = @viejaContra;

-- Actualizar contraseña del usuario
SELECT @idUsuario = [id_usuario] FROM [data].[Users] WHERE [contraseña] = @viejaContra;
EXEC [data].[actualizarUsuario] @idUsuario = @idUsuario, @contraseña = @nuevaContra;
SELECT * FROM [data].[Users] WHERE [id_usuario] = @idUsuario;