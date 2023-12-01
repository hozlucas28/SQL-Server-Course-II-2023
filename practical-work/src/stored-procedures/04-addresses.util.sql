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
					WHERE [calle_y_nro] = @calleYNro
                    AND [id_localidad] = @IdLocalidad 
                    AND [id_provincia] = @IdProvincia)

        INSERT INTO [utilities].[Addresses] ([calle_y_nro],[id_localidad],[id_provincia]) 
		VALUES (@calleYNro,@IdLocalidad,@IdProvincia)

	SELECT @idDireccion = [id_direccion] FROM [utilities].[Addresses] 
	WHERE [calle_y_nro] = @calleYNro AND [id_localidad] = @IdLocalidad AND [id_provincia] = @IdProvincia
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

    IF NOT EXISTS (SELECT 1 FROM [utilities].[Addresses] WHERE [calle_y_nro] = @calleYNro AND [id_localidad] = @idLocalidad AND [id_provincia] = @idProvincia)
        INSERT INTO [utilities].[Addresses] (
            [calle_y_nro],
            [cod_postal],
            [departamento],
            [id_direccion],
            [id_localidad],
            [id_pais],
            [id_provincia],
            [piso]
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
            [calle_y_nro] = @calleYNro,
            [cod_postal] = @codPostal,
            [departamento] = @departamento,
            [id_localidad] = @idLocalidad,
            [id_pais] = @idPais,
            [id_provincia] = @idProvincia,
            [piso] = @piso
        WHERE
            [calle_y_nro] = @calleYNro AND
            [id_localidad] = @idLocalidad AND
            [id_provincia] = @idProvincia

    SELECT
        @calleYNro = [calle_y_nro],
        @codPostal = [cod_postal],
        @departamento = [departamento],
        @idDireccion = [id_direccion],
        @idLocalidad = [id_localidad],
        @idPais = [id_pais],
        @idProvincia = [id_provincia],
        @piso = [piso]
    FROM [utilities].[Addresses]
    WHERE
        [calle_y_nro] = @calleYNro AND
        [id_localidad] = @idLocalidad AND
        [id_provincia] = @idProvincia
END;