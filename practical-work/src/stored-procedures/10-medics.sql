USE [CURESA];
GO


/* ------------------ Procedimientos Almacenados - Médicos ------------------ */

-- Insertar médico
CREATE OR ALTER PROCEDURE [data].[insertarMedico]
    @nombre VARCHAR(50),
    @apellido VARCHAR(50),
    @especialidad VARCHAR(50),
    @matricula INT
AS
BEGIN
    DECLARE @idEspecialidad INT

    SET @idEspecialidad = [data].[obtenerIdEspecialidad](@especialidad)

    INSERT INTO [data].[medicos]
        ([nombre], [apellido], [nro_matricula], [id_especialidad])
    VALUES
        (@nombre, @apellido, @matricula, @idEspecialidad)
END;
GO

-- Eliminar médico
CREATE OR ALTER PROCEDURE [data].[eliminarMedico]
    @id INT
AS
    UPDATE [data].[medicos] SET [alta] = 0 WHERE [id_medico] = @id;