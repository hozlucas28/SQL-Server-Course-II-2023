ALTER TABLE ddbba.cursos ADD dia CHAR(16),
turno CHAR(8);

go CREATE
OR
ALTER TRIGGER ddbba.normalizarDiaYTurno ON ddbba.cursos AFTER INSERT,
UPDATE AS BEGIN
UPDATE ddbba.cursos
SET
	dia = UPPER(dia),
	turno = UPPER(turno)
WHERE
	materia IN (
		SELECT
			materia
		FROM
			inserted
	)
	AND comision = (
		SELECT
			comision
		FROM
			inserted
	) END;
