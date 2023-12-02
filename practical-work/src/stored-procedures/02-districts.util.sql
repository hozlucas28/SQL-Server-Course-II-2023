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
    IF NOT EXISTS (SELECT 1 FROM [utilities].[Localities] WHERE [provinceId] = @IdProvincia AND [name] = @Localidad)
        INSERT INTO [utilities].[Localities] ([name],[provinceId]) VALUES (@Localidad,@IdProvincia)

	SELECT @IdLocalididad = [id] FROM [utilities].[Localities] WHERE [provinceId] = @IdProvincia AND [name] = @Localidad
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
        
    IF NOT EXISTS (SELECT 1 FROM [utilities].[Localities] WHERE [name] = @localidad) 
        INSERT INTO [utilities].[Localities] ([name]) VALUES (@localidad)
    ELSE
        UPDATE [utilities].[Localities] SET [name] = @localidad WHERE [name] = @localidad

    SELECT @outIdLocalidad = [id], @outNombre = [name] FROM [utilities].[Localities] WHERE [name] = @localidad
END;