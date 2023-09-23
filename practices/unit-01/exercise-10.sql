DELETE FROM ddbba.materias;
DELETE FROM ddbba.cursos;

go
INSERT INTO
	ddbba.materias (id, nombre)
VALUES
	(1, 'Bases de Datos Aplicada'),
	(2, 'Diseño de Software'),
	(3, 'Practica Profesional Supervisada'),
	(4, 'Matemática Discreta'),
	(5, 'Análisis Matemático I'),
	(6, 'Programación Inicial'),
	(7, 'Sistemas de Numeración'),
	(8, 'Matemática Aplicada'),
	(9, 'Física I'),
	(10, 'Tópicos de Programación');

go
CREATE OR ALTER PROCEDURE ddbba.generarCursos
AS
BEGIN
    DECLARE @cantidad INT = 1
	DECLARE @cantidad_comisiones INT
	DECLARE @cantidad_materias INT = (SELECT COUNT(*) FROM ddbba.materias)
    DECLARE @cantidad_comisiones_actual INT
    DECLARE @comision INT
    DECLARE @materias INT = (SELECT id FROM ddbba.materias)
	
	WHILE @cantidad <= @cantidad_materias
	BEGIN
		SET @cantidad_comisiones = (SELECT CAST(RAND() * 5  AS INT) + 1)
		SET @cantidad_comisiones_actual = (SELECT COUNT(*) FROM ddbba.cursos WHERE materia = @materias)
        SET @materia = (SELECT id FROM (SELECT id, ROW_NUMBER() OVER (ORDER BY id) num FROM ddbba.materia) AS materia_con_num WHERE num = @contador)

		IF (@cantidad_comisiones + @cantidad_comisiones_actual < 5)
		BEGIN
            WHILE @cantidad_comisiones > 0 
            BEGIN
                SET @comision = CAST(RAND() * 8999 + 1000 AS INT)
                INSERT INTO	ddbba.cursos (materia, comision) VALUES (@materia, @comision)
                SET @cantidad_comisiones = @cantidad_comisiones - 1
            END
        END
		SET @cantidad = @cantidad + 1
	END
END
