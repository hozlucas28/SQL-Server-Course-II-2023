USE [CURESA];
GO

/*
    Se requiere la ejecución previa de la semilla: < seed.sql >
*/


/* -------------------------- Actualizar Contraseña ------------------------- */

DECLARE @userId INT = NULL;
DECLARE @newPassword VARCHAR(255) = 'LaYutaExistePorUstedes62-23';
DECLARE @oldPassword VARCHAR(255) = '12345';

-- Limpiar registros del test
SELECT @userId = [id] FROM [data].[Users] WHERE [password] = @newPassword;
IF @userId IS NOT NULL
    EXECUTE [data].[deleteUser] @userId = @userId;

-- Crear usuario
EXECUTE [data].[insertUser] @userPassword = @oldPassword;
SELECT * FROM [data].[Users] WHERE [password] = @oldPassword;

-- Actualizar contraseña del usuario
SELECT @userId = [id] FROM [data].[Users] WHERE [password] = @oldPassword;
EXECUTE [data].[updateUser] @userId = @userId, @userPassword = @newPassword;
SELECT * FROM [data].[Users] WHERE [id] = @userId;