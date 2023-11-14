USE [CURESA];
GO

-- Actualizar contraseña del usuario
DECLARE @contraseñaOriginal VARCHAR(255) = '12345';
DECLARE @contraseñaCambiada VARCHAR(255) = 'LaYutaExistePorUstedes62-23';
DECLARE @idUsuario INT;

INSERT INTO [datos].[usuarios] ([contraseña]) values (@contraseñaOriginal);
SELECT @idUsuario = [id_usuario] FROM [datos].[usuarios] WHERE [contraseña] = @contraseñaOriginal;
EXEC [datos].[actualizarContraseña] @idUsuario, @contraseñaCambiada;

-- Mostrar usuario actualizado
SELECT * FROM [datos].[usuarios] WHERE [id_usuario] = @idUsuario;