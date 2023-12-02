USE [CURESA];
GO


/* ---------------- Procedimientos Almacenados - Direcciones ---------------- */

-- Obtener el ID de una dirección
CREATE OR ALTER PROCEDURE [utilities].[obtenerOInsertarIdDireccion]
    @calleYNro VARCHAR(50),
    @localidad VARCHAR(255),
    @provincia VARCHAR(255),
    @idDireccion INT OUTPUT
AS
BEGIN
    DECLARE @idProvincia INT
    DECLARE @idLocalidad INT

	EXEC [utilities].[obtenerOInsertarIdProvincia] @Provincia, @IdProvincia OUTPUT
	EXEC [utilities].[obtenerOInsertarIdLocalidad] @Localidad,@IdProvincia, @IdLocalidad OUTPUT

	IF NOT EXISTS (SELECT 1 FROM [utilities].[Addresses]
					WHERE [street] = @calleYNro
                    AND [localityId] = @IdLocalidad
                    AND [provinceId] = @IdProvincia)

        INSERT INTO [utilities].[Addresses] ([street],[localityId],[provinceId]) 
		VALUES (@calleYNro,@IdLocalidad,@IdProvincia)

	SELECT @idDireccion = [id] FROM [utilities].[Addresses] 
	WHERE [street] = @calleYNro AND [localityId] = @IdLocalidad AND [provinceId] = @IdProvincia
END;
GO

-- Actualizar/Insertar una dirección

CREATE OR ALTER PROCEDURE [utilities].[actualizarDireccion]
    @calleYNro VARCHAR(50),
    @codPostal SMALLINT = NULL,
    @departamento SMALLINT = NULL,
    @idDireccion INT = NULL,
    @idLocalidad INT,
    @idPais INT = NULL,
    @idProvincia INT,
    @piso SMALLINT = NULL,
    @outCalle VARCHAR(50),
    @outCodPostal SMALLINT OUTPUT,
    @outDepartamento SMALLINT OUTPUT,
    @outIdDireccion INT OUTPUT,
    @outIdLocalidad INT OUTPUT,
    @outIdPais INT OUTPUT,
    @outIdProvincia INT OUTPUT,
    @outNumero INT OUTPUT,
    @outPiso SMALLINT OUTPUT
AS
BEGIN
    IF NULLIF(@calleYNro, '') IS NULL OR @idLocalidad IS NULL OR @idProvincia IS NULL
        RETURN

    IF NOT EXISTS (SELECT 1 FROM [utilities].[Addresses] WHERE [street] = @calleYNro AND [localityId] = @idLocalidad AND [provinceId] = @idProvincia)
        INSERT INTO [utilities].[Addresses] (
            [street],
            [postalCode],
            [department],
            [id],
            [localityId],
            [countryId],
            [provinceId],
            [floor]
        ) VALUES (
            @calleYNro,
            @codPostal,
            @departamento,
            @idDireccion,
            @idLocalidad,
            @idPais,
            @idProvincia,
            @piso
        )
    ELSE
        UPDATE [utilities].[Addresses] SET
            [street] = @calleYNro,
            [postalCode] = @codPostal,
            [department] = @departamento,
            [localityId] = @idLocalidad,
            [countryId] = @idPais,
            [provinceId] = @idProvincia,
            [floor] = @piso
        WHERE
            [street] = @calleYNro AND
            [localityId] = @idLocalidad AND
            [provinceId] = @idProvincia

    SELECT
        @calleYNro = [street],
        @codPostal = [postalCode],
        @departamento = [department],
        @idDireccion = [id],
        @idLocalidad = [localityId],
        @idPais = [countryId],
        @idProvincia = [provinceId],
        @piso = [floor]
    FROM [utilities].[Addresses]
    WHERE
        [street] = @calleYNro AND
        [localityId] = @idLocalidad AND
        [provinceId] = @idProvincia
END;