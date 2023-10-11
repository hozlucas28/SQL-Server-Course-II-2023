GO
USE [cure_sa];

-- Insertar médico
GO
CREATE OR ALTER PROCEDURE [datos].[insertarMedico]
    @nombre VARCHAR(50) NOT NULL,
    @apellido VARCHAR(50) NOT NULL,
    @especialidad VARCHAR(50) NOT NULL,
    @matricula INT NOT NULL
AS
BEGIN
    DECLARE @idEspecialidad INT

    SET @idEspecialidad = [datos].[obtenerIdEspecialidad](@especialidad)

    INSERT INTO [datos].[medicos]
        (nombre, apellido, nro_matricula, id_especialidad)
    VALUES
        (@nombre, @apellido, @matricula, @idEspecialidad)
END;

-- Eliminar médico
GO
CREATE OR ALTER PROCEDURE [datos].[eliminarMedico]
    @id INT
AS
    UPDATE [datos].[medicos] SET valido = 0 WHERE id_medico = @id;