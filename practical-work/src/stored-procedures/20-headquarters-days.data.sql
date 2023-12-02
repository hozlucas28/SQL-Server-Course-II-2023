USE [CURESA];
GO


/* ---------------- Procedimientos Almacenados - Días X Sede ---------------- */

-- Registrar días x sede
CREATE OR ALTER PROCEDURE [data].[insertDayXHeadquarter]
	@date DATE,
    @careHeadquarterId INT,
    @endTime TIME,
    @medicId INT,
    @startTime TIME
AS
BEGIN
    INSERT INTO [data].[Days_X_Headquarter] ([day], [startTime], [endTime], [medicId], [careHeadquarterId])
        VALUES (@date, @startTime, @endTime, @medicId, @careHeadquarterId);
END;
GO

-- Actualizar días x sede
CREATE OR ALTER PROCEDURE [data].[updateDayXHeadquarter]
	@dayXHeadquarterId INT,
    @careHeadquarterId INT = NULL,
    @date DATE = NULL,
    @endTime TIME = NULL,
    @medicId INT = NULL,
    @startTime TIME = NULL
AS
BEGIN
    BEGIN TRY
        UPDATE [data].[Days_X_Headquarter]
        SET [day] = ISNULL(@date, [day]),
            [startTime] = ISNULL(@startTime, [startTime]),
            [endTime] = ISNULL(@endTime, [endTime]),
            [medicId] = ISNULL(@medicId, [medicId]),
            [careHeadquarterId] = ISNULL(@careHeadquarterId, [careHeadquarterId])
        WHERE [id] = @dayXHeadquarterId
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error during day x headquarter update: ' + @errorMessage;
        THROW
    END CATCH
END;
GO

-- Borrar días x sede (forma lógica)
CREATE OR ALTER PROCEDURE [data].[deleteDayXHeadquarter]
    @careHeadquarterId INT
AS
BEGIN
    BEGIN TRY
        UPDATE [data].[Days_X_Headquarter] SET [enabled] = 0 WHERE [careHeadquarterId] = @careHeadquarterId
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
        SET @errorMessage = ERROR_MESSAGE()
        PRINT 'Error during day x headquarter logical delete: ' + @errorMessage;
        THROW
    END CATCH
END;