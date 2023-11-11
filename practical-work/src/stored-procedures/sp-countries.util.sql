GO
USE [cure_sa];

-- Obtener el ID de una nacionalidad
GO
CREATE OR ALTER PROCEDURE [referencias].[obtenerOInsertarIdNacionalidad]
    @nacionalidad VARCHAR(50) = NULL,
    @id INT OUTPUT
AS
BEGIN
    SET @nacionalidad = UPPER(TRIM(@nacionalidad));

    IF NULLIF(@nacionalidad, '') IS NULL
        SET @id = -1;
    ELSE
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM [referencias].[nacionalidades] WHERE UPPER(TRIM(nombre)) = @nacionalidad) 
            INSERT INTO [referencias].[nacionalidades] (nombre) VALUES (@nacionalidad);

        SELECT @id = id_nacionalidad FROM [referencias].[nacionalidades] WHERE UPPER(TRIM(nombre)) = @nacionalidad;
    END
END;

-- Actualizar/Insertar una nacionalidad
GO
CREATE OR ALTER PROCEDURE [referencias].[actualizarNacionalidad]
    @pais VARCHAR(50) = NULL,
    @nacionalidad VARCHAR(50) = NULL,
    @outGentilicio VARCHAR(50) OUTPUT,
    @outIdpais INT OUTPUT,
    @outNombre VARCHAR(50) OUTPUT
AS
BEGIN
    IF NULLIF(@nacionalidad, '') IS NULL
        RETURN

    IF NOT EXISTS (SELECT 1 FROM [referencias].[paises] WHERE gentilicio = @nacionalidad) 
        IF NULLIF(@pais, '') IS NULL
            RETURN
        ELSE
            INSERT INTO [referencias].[paises] (nombre, gentilicio) VALUES (@pais, @nacionalidad)
    ELSE
        UPDATE [referencias].[paises] SET gentilicio = @nacionalidad WHERE gentilicio = @nacionalidad

    SELECT @outGentilicio = gentilicio, @outIdpais = id_pais, @outNombre = nombre FROM [referencias].[paises] WHERE gentilicio = @nacionalidad
    RETURN
END;