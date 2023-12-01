USE [CURESA];
GO


/* ---------------- Procedimientos Almacenados - Localidades ---------------- */

-- Obtener el ID de una localidad
CREATE OR ALTER PROCEDURE [utilities].[obtenerOInsertarIdLocalidad]
    @Localidad VARCHAR(255),
	@IdProvincia INT,
	@IdLocalididad INT OUTPUT
AS
BEGIN
    SET @Localidad = UPPER(@Localidad)
    IF NOT EXISTS (SELECT 1 FROM [utilities].[nombres_localidades] WHERE [id_provincia] = @IdProvincia AND [nombre] = @Localidad)
        INSERT INTO [utilities].[nombres_localidades] ([nombre],[id_provincia]) VALUES (@Localidad,@IdProvincia)

	SELECT @IdLocalididad = [id_localidad] FROM [utilities].[nombres_localidades] WHERE [id_provincia] = @IdProvincia AND [nombre] = @Localidad
END;
GO

-- Actualizar/Insertar una localidad
CREATE OR ALTER PROCEDURE [utilities].[insertarLocalidad]
    @localidad VARCHAR(50) = 'null',
    @outIdLocalidad INT OUTPUT,
    @outNombre VARCHAR(50) OUTPUT
AS
BEGIN
    IF NULLIF(@localidad, 'null') IS NULL
        RETURN
        
    IF NOT EXISTS (SELECT 1 FROM [utilities].[nombres_localidades] WHERE [nombre] = @localidad) 
        INSERT INTO [utilities].[nombres_localidades] ([nombre]) VALUES (@localidad)
    ELSE
        UPDATE [utilities].[nombres_localidades] SET [nombre] = @localidad WHERE [nombre] = @localidad

    SELECT @outIdLocalidad = [id_localidad], @outNombre = [nombre] FROM [utilities].[nombres_localidades] WHERE [nombre] = @localidad
END;