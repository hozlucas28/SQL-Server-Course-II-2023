CREATE FUNCTION ddbba.obtenerCursoN (
    @n INT
) RETURNS TABLE
AS RETURN (SELECT * FROM ddbba.cursos ORDER BY materia ASC OFFSET(@n - 1) ROW FETCH NEXT 1 ROW ONLY);

go
CREATE OR ALTER PROCEDURE ddbba.generarDiasYTurnosCursada
AS
BEGIN
    DECLARE @cantidad_cursos INT = (SELECT COUNT(*) FROM ddbba.cursos)
    DECLARE @dia CHAR(16)
    DECLARE @turno CHAR(8)
    DECLARE @curso_materia INT
    DECLARE @curso_comision SMALLINT
    DECLARE @cantidad_comisiones INT

    WHILE @cantidad_cursos > 0
    BEGIN
        SET @dia = CASE CAST((RAND() * 6) + 1  AS INT)
                        WHEN 1 THEN 'Lunes'
                        WHEN 2 THEN 'Martes'
                        WHEN 3 THEN 'Miércoles'
                        WHEN 4 THEN 'Jueves'
                        WHEN 5 THEN 'Viernes'
                        ELSE 'Sábado'
                        END

        SET @turno = CASE CAST((RAND() * 3) + 1  AS INT)
                        WHEN 1 THEN 'Mañana'
                        WHEN 2 THEN 'Tarde'
                        ELSE 'Noche'
                        END
         
        SELECT @curso_materia = materia FROM ddbba.obtenerCursoN(@cantidad_cursos)
        SELECT @curso_comision = comision FROM ddbba.cursos WHERE materia = @curso_materia

        WITH num_rows(materia, comision, dia, turno, cantidad) AS (
			SELECT	*, ROW_NUMBER() OVER (order by comision) cantidad
			FROM	ddbba.cursos
		)

        UPDATE ddbba.cursos
            SET dia = @dia, turno = @turno FROM ddbba.cursos a
		        INNER JOIN num_rows b ON a.materia = b.materia AND a.comision = b.comision
		            WHERE cantidad = @cantidad_cursos

        SET @cantidad_cursos = @cantidad_cursos - 1
    END
END;

go
EXECUTE ddbba.generarDiasYTurnosCursada;