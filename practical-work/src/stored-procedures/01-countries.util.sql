USE [CURESA];
GO


/* ------------------- Procedimientos Almacenados - Países ------------------ */

-- Obtener el ID de una nacionalidad
CREATE OR ALTER PROCEDURE [utilities].[obtenerOInsertarIdNacionalidad]
    @nacionalidad VARCHAR(50) = NULL,
    @id INT OUTPUT
AS
BEGIN
    SET @nacionalidad = UPPER(TRIM(@nacionalidad));

    IF NULLIF(@nacionalidad, '') IS NULL
        SET @id = -1;
    ELSE
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM [utilities].[nacionalidades] WHERE UPPER(TRIM([nombre])) = @nacionalidad) 
            INSERT INTO [utilities].[nacionalidades] ([nombre]) VALUES (@nacionalidad);

        SELECT @id = [id_nacionalidad] FROM [utilities].[nacionalidades] WHERE UPPER(TRIM([nombre])) = @nacionalidad;
    END
END;
GO

-- Actualizar/Insertar una nacionalidad
CREATE OR ALTER PROCEDURE [utilities].[actualizarNacionalidad]
    @pais VARCHAR(50) = NULL,
    @nacionalidad VARCHAR(50) = NULL,
    @outGentilicio VARCHAR(50) OUTPUT,
    @outIdpais INT OUTPUT,
    @outNombre VARCHAR(50) OUTPUT
AS
BEGIN
    IF NULLIF(@nacionalidad, '') IS NULL
        RETURN

    IF NOT EXISTS (SELECT 1 FROM [utilities].[paises] WHERE [gentilicio] = @nacionalidad) 
        IF NULLIF(@pais, '') IS NULL
            RETURN
        ELSE
            INSERT INTO [utilities].[paises] ([nombre], [gentilicio]) VALUES (@pais, @nacionalidad)
    ELSE
        UPDATE [utilities].[paises] SET [gentilicio] = @nacionalidad WHERE [gentilicio] = @nacionalidad

    SELECT @outGentilicio = [gentilicio], @outIdpais = [id_pais], @outNombre = [nombre] FROM [utilities].[paises] WHERE [gentilicio] = @nacionalidad
END;