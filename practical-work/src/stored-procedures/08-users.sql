USE [CURESA];
GO


/* ------------------ Procedimientos Almacenados - Usuarios ----------------- */

-- Insertar usuario
CREATE OR ALTER PROCEDURE [datos].[insertarUsuario]
	@contraseña VARCHAR(256),
    @idPaciente INT = NULL
AS
BEGIN
    INSERT INTO [datos].[usuarios] ([contraseña], [id_paciente]) VALUES (@contraseña, @idPaciente)
END;
GO

-- Actualizar usuario
CREATE OR ALTER PROCEDURE [datos].[actualizarUsuario]
    @contraseña VARCHAR(256) = NULL,
    @idPaciente INT = NULL,
    @idUsuario INT
AS
BEGIN
    UPDATE [datos].[usuarios] SET
        [contraseña] = ISNULL(@contraseña, [contraseña]),
        [id_paciente] = ISNULL(@idPaciente, [id_paciente])
    WHERE
        [id_usuario] = @idUsuario
END;
GO

-- Borrar usuario
CREATE OR ALTER PROCEDURE [datos].[borrarUsuario]
    @id INT
AS
    DELETE FROM [datos].[usuarios] WHERE [id_usuario] = @id