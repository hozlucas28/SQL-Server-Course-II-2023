USE [CURESA];
GO


/* ---------------- Procedimientos Almacenados - Localidades ---------------- */

-- Obtener el ID de una localidad
CREATE OR ALTER PROCEDURE [referencias].[obtenerOInsertarIdLocalidad]
    @Localidad VARCHAR(255),
	@IdProvincia INT,
	@IdLocalididad INT OUTPUT
AS
BEGIN
    SET @Localidad = UPPER(@Localidad)
    IF NOT EXISTS (SELECT 1 FROM [referencias].[nombres_localidades] WHERE [id_provincia] = @IdProvincia AND [nombre] = @Localidad)
        INSERT INTO [referencias].[nombres_localidades] ([nombre],[id_provincia]) VALUES (@Localidad,@IdProvincia)

	SELECT @IdLocalididad = [id_localidad] FROM [referencias].[nombres_localidades] WHERE [id_provincia] = @IdProvincia AND [nombre] = @Localidad
END;
GO

-- Actualizar/Insertar una localidad
CREATE OR ALTER PROCEDURE [referencias].[insertarLocalidad]
    @localidad VARCHAR(50) = 'null',
    @outIdLocalidad INT OUTPUT,
    @outNombre VARCHAR(50) OUTPUT
AS
BEGIN
    IF NULLIF(@localidad, 'null') IS NULL
        RETURN
        
    IF NOT EXISTS (SELECT 1 FROM [referencias].[nombres_localidades] WHERE [nombre] = @localidad) 
        INSERT INTO [referencias].[nombres_localidades] ([nombre]) VALUES (@localidad)
    ELSE
        UPDATE [referencias].[nombres_localidades] SET [nombre] = @localidad WHERE [nombre] = @localidad

    SELECT @outIdLocalidad = [id_localidad], @outNombre = [nombre] FROM [referencias].[nombres_localidades] WHERE [nombre] = @localidad
END;