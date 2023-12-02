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
        IF NOT EXISTS (SELECT 1 FROM [utilities].[Nationalities] WHERE UPPER(TRIM([name])) = @nacionalidad) 
            INSERT INTO [utilities].[Nationalities] ([name]) VALUES (@nacionalidad);

        SELECT @id = [id] FROM [utilities].[Nationalities] WHERE UPPER(TRIM([name])) = @nacionalidad;
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

    IF NOT EXISTS (SELECT 1 FROM [utilities].[Countries] WHERE [demonym] = @nacionalidad) 
        IF NULLIF(@pais, '') IS NULL
            RETURN
        ELSE
            INSERT INTO [utilities].[Countries] ([name], [demonym]) VALUES (@pais, @nacionalidad)
    ELSE
        UPDATE [utilities].[Countries] SET [demonym] = @nacionalidad WHERE [demonym] = @nacionalidad

    SELECT @outGentilicio = [demonym], @outIdpais = [id], @outNombre = [name] FROM [utilities].[Countries] WHERE [demonym] = @nacionalidad
END;