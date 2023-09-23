-- Common Table Expression
WITH
	personas_duplicadas (dni, primer_nombre, apellido, cant) AS (
		SELECT
			dni,
			primer_nombre,
			apellido,
			ROW_NUMBER() OVER (
				PARTITION BY
					primer_nombre,
					apellido
				ORDER BY
					primer_nombre,
					apellido
			) cant
		FROM
			ddbba.personas
	);

go
-- Eliminar personas duplicadas
DELETE FROM personas_duplicadas
WHERE
	personas_duplicadas.cant > 1
