USE [CURESA];
GO


/* ------------------ Procedimientos Almacenados - Usuarios ----------------- */

-- Insertar usuario
CREATE OR ALTER PROCEDURE [data].[insertarUsuario]
	@contraseña VARCHAR(256),
    @idPaciente INT = NULL
AS
BEGIN
    INSERT INTO [data].[Users] ([password], [patientId]) VALUES (@contraseña, @idPaciente)
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
        [password] = ISNULL(@contraseña, [password]),
        [patientId] = ISNULL(@idPaciente, [patientId])
    WHERE
        [id] = @idUsuario
END;
GO

-- Borrar usuario
CREATE OR ALTER PROCEDURE [data].[borrarUsuario]
    @id INT
AS
    DELETE FROM [data].[Users] WHERE [id] = @id