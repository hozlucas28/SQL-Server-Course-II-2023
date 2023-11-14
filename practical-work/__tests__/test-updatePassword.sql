USE [CURESA];

DECLARE @contraseñaOriginal VARCHAR(255) = 'hola', 
        @contraseñaCambiada VARCHAR(255) = 'clave secreta mega segura',
        @idUsuario INT;

INSERT INTO datos.usuarios (contraseña) values (@contraseñaOriginal);

SELECT @idUsuario = id_usuario FROM datos.usuarios WHERE contraseña = @contraseñaOriginal;

EXEC [datos].[actualizarContraseña] @idUsuario, @contraseñaCambiada;

SELECT * FROM datos.usuarios WHERE id_usuario = @idUsuario; 