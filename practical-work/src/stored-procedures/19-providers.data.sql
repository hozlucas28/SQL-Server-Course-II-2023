USE [CURESA];
GO


/* ---------------- Procedimientos Almacenados - Prestadores ---------------- */

-- Registrar un prestador
CREATE OR ALTER PROCEDURE [data].[insertProvider]
    @providerName VARCHAR(50),
    @providerPlan VARCHAR(30)
AS
BEGIN
    SET @providerName = UPPER(TRIM(@providerName))
    SET @providerPlan = UPPER(TRIM(@providerPlan))

    BEGIN TRY
        INSERT INTO [data].[Providers] ([name], [plan]) VALUES (@providerName, @providerPlan)
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error during provider insertion: ' + @errorMessage;
        THROW
    END CATCH
END;
GO

-- Actualizar un prestador
CREATE OR ALTER PROCEDURE [data].[updateProvider]
    @providerId INT,
    @providerName VARCHAR(50) = NULL,
    @providerPlan VARCHAR(30) = NULL
AS
BEGIN
    SET @providerName = UPPER(TRIM(@providerName))
    SET @providerPlan = UPPER(TRIM(@providerPlan))

    BEGIN TRY
        UPDATE [data].[Providers]
        SET [name] = ISNULL(@providerName, UPPER(TRIM([name]))),
            [plan] = ISNULL(@providerPlan, UPPER(TRIM([plan])))
        WHERE [id] = @providerId
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error during provider update: ' + @errorMessage;
        THROW
    END CATCH
END;
GO

-- Borrar un prestador (forma lógica)
CREATE OR ALTER PROCEDURE [data].[deleteProvider]
    @providerId INT
AS
BEGIN
    BEGIN TRY
        DELETE FROM [data].[Providers] WHERE [id] = @providerId
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error during provider logical delete: ' + @errorMessage;
        THROW
    END CATCH
END;