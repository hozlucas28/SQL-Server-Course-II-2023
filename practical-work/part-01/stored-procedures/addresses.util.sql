GO
USE [cure_sa];

-- Obtener el ID de una dirección
GO
CREATE OR ALTER FUNCTION [referencias].[obtenerIdDireccion]
    (
        @calle VARCHAR(50),
        @localidad VARCHAR(255),
        @provincia VARCHAR(255)
    ) RETURNS INT
AS
BEGIN
    DECLARE @idProvincia INT
    DECLARE @idLocalidad INT
    DECLARE @idDireccion INT

    SET @idProvincia = [referencias].[obtenerIdProvincia] (@provincia)
    SET @idLocalidad = [referencias].[obtenerIdLocalidad] (@localidad)

    IF NOT EXISTS (SELECT 1 FROM [referencias].[direcciones] WHERE calle = @calle AND id_localidad = @idLocalidad AND id_provincia = @idProvincia)
        INSERT INTO [referencias].[direcciones] (calle, id_localidad, id_provincia) VALUES (@calle, @idLocalidad, @idProvincia)

    SELECT @idDireccion = id_direccion FROM [referencias].[direcciones]
        WHERE calle = @calle AND id_localidad = @idLocalidad AND id_provincia = @idProvincia

    RETURN @idDireccion
END;

-- Actualizar/Insertar una dirección
GO
CREATE OR ALTER PROCEDURE [referencias].[actualizarDireccion]
    @calle VARCHAR(50),
    @codPostal SMALLINT = NULL,
    @departamento SMALLINT = NULL,
    @idDireccion INT = NULL,
    @idLocalidad INT,
    @idPais INT = NULL,
    @idProvincia INT,
    @numero INT,
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
    IF NULLIF(@calle, '') IS NULL OR @idLocalidad IS NULL OR @idProvincia IS NULL OR @numero IS NULL
        RETURN

    IF NOT EXISTS (SELECT 1 FROM [referencias].[direcciones] WHERE calle = @calle AND id_localidad = @idLocalidad AND id_provincia = @idProvincia)
        INSERT INTO [referencias].[direcciones] (
            calle,
            cod_postal,
            departamento,
            id_direccion,
            id_localidad,
            id_pais,
            id_provincia,
            numero,
            piso
        ) VALUES (
            @calle,
            @codPostal,
            @departamento,
            @idDireccion,
            @idLocalidad,
            @idPais,
            @idProvincia,
            @numero,
            @piso
        )
    ELSE
        UPDATE [referencias].[direcciones] SET
            calle = @calle,
            cod_postal = @codPostal,
            departamento = @departamento,
            id_direccion = @idDireccion,
            id_localidad = @idLocalidad,
            id_pais = @idPais,
            id_provincia = @idProvincia,
            numero = @numero,
            piso = @piso
        WHERE
            calle = @calle COLLATE Latin1_General_CS_AS AND
            id_localidad = @idLocalidad AND
            id_provincia = @idProvincia

    SELECT
        @calle = calle,
        @codPostal = cod_postal,
        @departamento = departamento,
        @idDireccion = id_direccion,
        @idLocalidad = id_localidad,
        @idPais = id_pais,
        @idProvincia = id_provincia,
        @numero = numero,
        @pis = piso
    FROM [referencias].[direcciones]
    WHERE
        calle = @calle COLLATE Latin1_General_CS_AS AND
        id_localidad = @idLocalidad AND
        id_provincia = @idProvincia
    RETURN
END;