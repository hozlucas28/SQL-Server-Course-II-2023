USE [CURESA];
GO


/* ---------------- Procedimientos Almacenados - Direcciones ---------------- */

-- Obtener o insertar una dirección
CREATE OR ALTER PROCEDURE [utilities].[getOrInsertAddressId]
    @addressStreet VARCHAR(50),
    @localityName VARCHAR(255),
    @outAddressId INT OUTPUT,
    @provinceName VARCHAR(255)
AS
BEGIN
    DECLARE @localityId INT
    DECLARE @provinceId INT

	EXECUTE [utilities].[getOrInsertProvinceId] @provinceName = @provinceName, @outProvinceId = @provinceId OUT
	EXECUTE [utilities].[getOrInsertLocalityId] @localityName = @localityName, @provinceId = @provinceId, @outLocalityId = @localityId OUT

	IF NOT EXISTS (SELECT 1 FROM [utilities].[Addresses] WHERE [street] = @addressStreet AND [localityId] = @localityId AND [provinceId] = @provinceId)
        INSERT INTO [utilities].[Addresses] ([street], [localityId], [provinceId]) VALUES (@addressStreet, @localityId, @provinceId)

	SELECT @outAddressId = [id] FROM [utilities].[Addresses] 
	    WHERE [street] = @addressStreet AND [localityId] = @localityId AND [provinceId] = @provinceId
END;
GO

-- Actualizar o insertar una dirección
CREATE OR ALTER PROCEDURE [utilities].[updateOrInsertAddress]
    @addressStreet VARCHAR(50) = 'null',
    @countryId INT = NULL,
    @department SMALLINT = NULL,
    @floor SMALLINT = NULL,
    @localityId INT,
    @addressId INT = NULL,
    @outAddressId INT OUTPUT,
    @postalCode SMALLINT = NULL,
    @provinceId INT
AS
BEGIN
    SET @addressStreet = UPPER(TRIM(@addressStreet))

    IF NULLIF(@addressStreet, '') IS NULL OR @localityId IS NULL OR @provinceId IS NULL
        RETURN

    IF NOT EXISTS (SELECT 1 FROM [utilities].[Addresses] WHERE UPPER(TRIM([street])) = @addressStreet AND [localityId] = @localityId AND [provinceId] = @provinceId)
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
            @addressStreet,
            @postalCode,
            @department,
            @addressId,
            @localityId,
            @countryId,
            @provinceId,
            @floor
        )
    ELSE
        UPDATE [utilities].[Addresses] SET
            [street] = @addressStreet,
            [postalCode] = @postalCode,
            [department] = @department,
            [localityId] = @localityId,
            [countryId] = @countryId,
            [provinceId] = @provinceId,
            [floor] = @floor
        WHERE
            UPPER(TRIM([street])) = @addressStreet AND
            [localityId] = @localityId AND
            [provinceId] = @provinceId

    SELECT
         @outAddressId = [id]
    FROM [utilities].[Addresses]
        WHERE
            UPPER(TRIM([street])) = @addressStreet AND
            [postalCode] = @postalCode AND
            [department] = @department AND
            [id] = @addressId AND
            [localityId] = @localityId AND
            [countryId] = @countryId AND
            [provinceId] = @provinceId AND
            [floor] = @floor
END;