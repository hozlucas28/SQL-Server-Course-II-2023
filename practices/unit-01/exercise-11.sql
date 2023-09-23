CREATE OR ALTER FUNCTION ddbba.obtenerPersonaN (
    @n INT
) RETURNS TABLE
AS RETURN (SELECT * FROM ddbba.personas ORDER BY dni ASC OFFSET (@n - 1) ROW FETCH NEXT 1 ROW ONLY);

go
DELETE FROM ddbba.cursa;

go
CREATE OR ALTER PROCEDURE ddbba.generarInscripciones
AS
BEGIN
    DECLARE @cantidad_personas INT = (SELECT COUNT(*) FROM ddbba.personas)
    DECLARE @id_persona INT
	DECLARE @id_materia INT
	DECLARE @id_comision SMALLINT

	WHILE @cantidad_personas > 0
	BEGIN
		SELECT @id_persona = dni FROM ddbba.obtenerPersonaN(@cantidad_personas)
		SELECT TOP(1) @id_materia =  materia FROM ddbba.cursos ORDER BY NEWID()
		SELECT @id_comision = comision FROM ddbba.cursos WHERE materia = @id_materia

		INSERT INTO ddbba.cursa (id_persona, id_materia, id_comision, rol)
			VALUES (@id_persona, @id_materia, @id_comision, 'ALUMNO')
		
		SET @cantidad_personas = @cantidad_personas - 1
	END
END;

go
EXECUTE ddbba.generarInscripciones

