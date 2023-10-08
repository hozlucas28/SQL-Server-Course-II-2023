GO
USE [cure_sa];

-- Obtener el ID de una nacionalidad
GO
CREATE OR ALTER FUNCTION [referencias].[obtenerIdNacionalidad]
    (
        @nacionalidad VARCHAR(50) = NULL
    ) RETURNS INT
AS
BEGIN
    DECLARE @id INT = -1
    SET @nacionalidad = UPPER(TRIM(@nacionalidad))

    IF NULLIF(@nacionalidad, '') IS NULL
        BEGIN
            RETURN @id
        END

    IF NOT EXISTS (SELECT 1 FROM [referencias].[paises] WHERE UPPER(TRIM(nombre)) = @nacionalidad COLLATE Latin1_General_CS_AS) 
        BEGIN
            RETURN @id
        END

    SELECT @id = id_pais FROM [referencias].[paises] WHERE UPPER(TRIM(nombre)) = @nacionalidad
    RETURN @id
END;

-- Actualizar/Insertar una nacionalidad
GO
CREATE OR ALTER FUNCTION [referencias].[actualizarNacionalidad]
    (
        @pais VARCHAR(50) = NULL,
        @nacionalidad VARCHAR(50) = NULL
    ) RETURNS @registro TABLE (
        gentilicio VARCHAR(50) COLLATE Latin1_General_CS_AS NOT NULL,
        id_pais INT,
        nombre VARCHAR(50) COLLATE Latin1_General_CS_AS NOT NULL
    )
AS
BEGIN
    IF NULLIF(@nacionalidad, '') IS NULL
        BEGIN
            RETURN
        END
        
    IF NOT EXISTS (SELECT 1 FROM [referencias].[paises] WHERE gentilicio = @nacionalidad COLLATE Latin1_General_CS_AS) 
        IF NULLIF(@pais, '') IS NULL
            BEGIN
                RETURN
            END
        ELSE
            INSERT INTO [referencias].[paises] (nombre, gentilicio) VALUES (@pais, @nacionalidad)
    ELSE
        UPDATE [referencias].[paises] SET gentilicio = @nacionalidad WHERE gentilicio = @nacionalidad COLLATE Latin1_General_CS_AS
    
    INSERT INTO @registro SELECT gentilicio, id_pais, nombre FROM [referencias].[paises] WHERE gentilicio = @nacionalidad COLLATE Latin1_General_CS_AS
    RETURN
END;