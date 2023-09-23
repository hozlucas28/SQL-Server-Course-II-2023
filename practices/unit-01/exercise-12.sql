CREATE
OR
ALTER VIEW ddbba.mostrarCursos AS (
	SELECT
		cursa.id_comision AS 'Número de comisión',
		cursa.id_materia AS 'Código de materia',
		materia.nombre AS 'Nombre de la materia',
		FORMATMESSAGE (
			'%s, %s',
			TRIM(persona.apellido),
			TRIM(persona.primer_nombre),
			TRIM(persona.segundo_nombre)
		) AS 'Apellido y nombre'
	FROM
		ddbba.cursa AS cursa
		INNER JOIN ddbba.materias AS materia ON cursa.id_materia = materia.id
		INNER JOIN ddbba.personas AS persona ON cursa.id_persona = persona.dni
);
