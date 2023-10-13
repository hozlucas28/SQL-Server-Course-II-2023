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
        RETURN @id

    IF NOT EXISTS (SELECT 1 FROM [referencias].[paises] WHERE UPPER(TRIM(nombre)) = @nacionalidad COLLATE Latin1_General_CS_AS) 
        RETURN @id

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
    DECLARE @SQL VARCHAR(MAX)

    IF NULLIF(@nacionalidad, '') IS NULL
        RETURN

    IF NOT EXISTS (SELECT 1 FROM [referencias].[paises] WHERE gentilicio = @nacionalidad COLLATE Latin1_General_CS_AS) 
        IF NULLIF(@pais, '') IS NULL
            RETURN
        ELSE
            SELECT @SQL = 'INSERT INTO [referencias].[paises] (nombre, gentilicio) VALUES (' + @pais + ',' + @nacionalidad + ')'
    ELSE
        SELECT @SQL = 'UPDATE [referencias].[paises] SET gentilicio =' + @nacionalidad + 'WHERE gentilicio =' + @nacionalidad + 'COLLATE Latin1_General_CS_AS'

    EXEC sp_executesql @SQL

    INSERT INTO @registro SELECT gentilicio, id_pais, nombre FROM [referencias].[paises] WHERE gentilicio = @nacionalidad COLLATE Latin1_General_CS_AS
    RETURN
END;