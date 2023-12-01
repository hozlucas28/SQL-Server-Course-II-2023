USE [CURESA];
GO


/* ------------------ Procedimientos Almacenados - Usuarios ----------------- */

-- Insertar usuario
CREATE OR ALTER PROCEDURE [data].[insertarUsuario]
	@contraseña VARCHAR(256),
    @idPaciente INT = NULL
AS
BEGIN
    INSERT INTO [data].[Users] ([contraseña], [id_paciente]) VALUES (@contraseña, @idPaciente)
END;
GO

-- Actualizar usuario
CREATE OR ALTER PROCEDURE [data].[actualizarUsuario]
    @contraseña VARCHAR(256) = NULL,
    @idPaciente INT = NULL,
    @idUsuario INT
AS
BEGIN
    UPDATE [data].[Users] SET
        [contraseña] = ISNULL(@contraseña, [contraseña]),
        [id_paciente] = ISNULL(@idPaciente, [id_paciente])
    WHERE
        [id_usuario] = @idUsuario
END;
GO

-- Borrar usuario
CREATE OR ALTER PROCEDURE [data].[borrarUsuario]
    @id INT
AS
    DELETE FROM [data].[Users] WHERE [id_usuario] = @id