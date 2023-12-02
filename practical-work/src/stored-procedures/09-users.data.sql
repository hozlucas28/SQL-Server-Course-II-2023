USE [CURESA];
GO


/* ------------------ Procedimientos Almacenados - Usuarios ----------------- */

-- Insertar un usuario
CREATE OR ALTER PROCEDURE [data].[insertUser]
	@userPassword VARCHAR(256),
    @patientId INT = NULL
AS
BEGIN
    INSERT INTO [data].[Users] ([password], [patientId]) VALUES (@userPassword, @patientId)
END;
GO

-- Actualizar un usuario
CREATE OR ALTER PROCEDURE [data].[updateUser]
    @patientId INT = NULL,
    @userId INT,
    @userPassword VARCHAR(256) = NULL
AS
BEGIN
    UPDATE [data].[Users] SET
        [password] = ISNULL(@userPassword, [password]),
        [patientId] = ISNULL(@patientId, [patientId])
    WHERE
        [id] = @userId
END;
GO

-- Borrar un usuario
CREATE OR ALTER PROCEDURE [data].[deleteUser]
    @userId INT
AS
    DELETE FROM [data].[Users] WHERE [id] = @userId