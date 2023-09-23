DROP PROCEDURE ddbba.insertarLog;

DROP TRIGGER ddbba.crearRegistroMaterias;

DROP TRIGGER ddbba.crearRegistroCursos;

DROP TRIGGER ddbba.crearRegistroPersonas;

DROP TRIGGER ddbba.crearRegistroCursa;

go
-- Creación del procedimiento de inserción de registros
CREATE PROCEDURE
    ddbba.insertarLog @modulo char(10) = 'N/A',
    @texto char(50)
AS
BEGIN
    INSERT INTO ddbba.registros (texto, modulo)
        VALUES (@texto, @modulo)
END;

go
-- Crear registro de la tabla "materias"
CREATE TRIGGER ddbba.crearRegistroMaterias ON ddbba.materias
    AFTER INSERT, UPDATE, DELETE
        AS
        BEGIN
            DECLARE @insertados int = (SELECT count(*) FROM inserted)
            DECLARE @eliminados int = (SELECT count(*) FROM deleted)
            DECLARE @texto char (50)
            DECLARE @modulo char (10)

            IF @insertados > 0 AND @eliminados > 0
                BEGIN
                    SET @texto = 'UPDATE ddbba.materias'
                    SET @modulo = CAST(@insertados AS CHAR(10))
                END
                ELSE IF @insertados > 0
                    BEGIN
                        SET @texto = 'INSERT INTO ddbba.materias'
                        SET @modulo = CAST(@insertados AS CHAR(10))
                    END
                    ELSE IF @eliminados > 0
                    BEGIN
                        SET @texto = 'DELETE FROM ddbba.materias'
                        SET @modulo = CAST(@eliminados AS CHAR(10))
                    END

            EXECUTE ddbba.insertarLog @modulo, @texto
        END;

go
-- Crear registro de la tabla "cursos"
CREATE TRIGGER ddbba.crearRegistroCursos ON ddbba.cursos
    AFTER INSERT, UPDATE, DELETE
        AS
        BEGIN
            DECLARE @insertados int = (SELECT count(*) FROM inserted)
            DECLARE @eliminados int = (SELECT count(*) FROM deleted)
            DECLARE @texto char (50)
            DECLARE @modulo char (10)

            IF @insertados > 0 AND @eliminados > 0
                BEGIN
                    SET @texto = 'UPDATE ddbba.cursos'
                    SET @modulo = CAST(@insertados AS CHAR(10))
                END
                ELSE IF @insertados > 0
                    BEGIN
                        SET @texto = 'INSERT INTO ddbba.cursos'
                        SET @modulo = CAST(@insertados AS CHAR(10))
                    END
                    ELSE IF @eliminados > 0
                    BEGIN
                        SET @texto = 'DELETE FROM ddbba.cursos'
                        SET @modulo = CAST(@eliminados AS CHAR(10))
                    END

            EXECUTE ddbba.insertarLog @modulo, @texto
        END;

go
-- Crear registro de la tabla "personas"
CREATE TRIGGER ddbba.crearRegistroPersonas ON ddbba.personas
    AFTER INSERT, UPDATE, DELETE
        AS
        BEGIN
            DECLARE @insertados int = (SELECT count(*) FROM inserted)
            DECLARE @eliminados int = (SELECT count(*) FROM deleted)
            DECLARE @texto char (50)
            DECLARE @modulo char (10)

            IF @insertados > 0 AND @eliminados > 0
                BEGIN
                    SET @texto = 'UPDATE ddbba.personas'
                    SET @modulo = CAST(@insertados AS CHAR(10))
                END
                ELSE IF @insertados > 0
                    BEGIN
                        SET @texto = 'INSERT INTO ddbba.personas'
                        SET @modulo = CAST(@insertados AS CHAR(10))
                    END
                    ELSE IF @eliminados > 0
                    BEGIN
                        SET @texto = 'DELETE FROM ddbba.personas'
                        SET @modulo = CAST(@eliminados AS CHAR(10))
                    END

            EXECUTE ddbba.insertarLog @modulo, @texto
        END;

go
-- Crear registro de la tabla "cursa"
CREATE TRIGGER ddbba.crearRegistroCursa ON ddbba.cursa
    AFTER INSERT, UPDATE, DELETE
        AS
        BEGIN
            DECLARE @insertados int = (SELECT count(*) FROM inserted)
            DECLARE @eliminados int = (SELECT count(*) FROM deleted)
            DECLARE @texto char (50)
            DECLARE @modulo char (10)

            IF @insertados > 0 AND @eliminados > 0
                BEGIN
                    SET @texto = 'UPDATE ddbba.cursa'
                    SET @modulo = CAST(@insertados AS CHAR(10))
                END
                ELSE IF @insertados > 0
                    BEGIN
                        SET @texto = 'INSERT INTO ddbba.cursa'
                        SET @modulo = CAST(@insertados AS CHAR(10))
                    END
                    ELSE IF @eliminados > 0
                    BEGIN
                        SET @texto = 'DELETE FROM ddbba.cursa'
                        SET @modulo = CAST(@eliminados AS CHAR(10))
                    END

            EXECUTE ddbba.insertarLog @modulo, @texto
        END;