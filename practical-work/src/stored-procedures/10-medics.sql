USE [CURESA];
GO


/* ------------------ Procedimientos Almacenados - Médicos ------------------ */

-- Insertar médico
CREATE OR ALTER PROCEDURE [datos].[insertarMedico]
    @nombre VARCHAR(50),
    @apellido VARCHAR(50),
    @especialidad VARCHAR(50),
    @matricula INT
AS
BEGIN
    DECLARE @idEspecialidad INT

    SET @idEspecialidad = [datos].[obtenerIdEspecialidad](@especialidad)

    INSERT INTO [datos].[medicos]
        ([nombre], [apellido], [nro_matricula], [id_especialidad])
    VALUES
        (@nombre, @apellido, @matricula, @idEspecialidad)
END;
GO

-- Eliminar médico
CREATE OR ALTER PROCEDURE [datos].[eliminarMedico]
    @id INT
AS
    UPDATE [datos].[medicos] SET [alta] = 0 WHERE [id_medico] = @id;