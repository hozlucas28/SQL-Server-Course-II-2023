DELETE FROM ddbba.registros;

DELETE FROM ddbba.cursa;

DELETE FROM ddbba.personas;

DELETE FROM ddbba.cursos;

DELETE FROM ddbba.materias;

go;

-- Error: materias duplicadas
INSERT INTO
	ddbba.materias (id, nombre)
VALUES
	(3641, 'Bases de Datos Aplicada'),
	(3648, 'Diseño de Software'),
	(3675, 'Practica Profesional Supervisada'),
	(3621, 'Matemática Discreta'),
	(3622, 'Análisis Matemático I'),
	(3623, 'Programación Inicial'),
	(3625, 'Sistemas de Numeración'),
	(3621, 'Matemática Aplicada'),
	(3628, 'Física I'),
	(3635, 'Tópicos de Programación');

go
-- Error: cursos duplicados (número de materia)
INSERT INTO
	ddbba.cursos (materia, comision)
VALUES
	(3641, 2900),
	(3641, 3900),
	(3648, 1900),
	(3675, 5900);

go
-- Error: cursos duplicados (número de comision)
INSERT INTO
	ddbba.cursos (materia, comision)
VALUES
	(3641, 2900),
	(3622, 3900),
	(3648, 1900),
	(3675, 3900);

go
-- Error: cursos duplicados (número de materia inexistente)
INSERT INTO
	ddbba.cursos (materia, comision)
VALUES
	(3333, 2900),
	(3622, 3900),
	(3648, 1900),
	(3675, 3900);

go
-- Error: patente incorrecta
INSERT INTO
	ddbba.personas (
		dni,
		patente,
		telefono,
		localidad,
		fecha_nacimiento,
		primer_nombre,
		segundo_nombre,
		apellido
	)
VALUES
	(
		43820123,
		'4AAY26?3',
		'1128376425',
		'Ramos Mejía',
		'2004-05-23T14:25:10',
		'Lucas',
		'Martin',
		'Hoz'
	);

-- Error: alumno y docente simultaneamente
INSERT INTO
	ddbba.cursa (id_persona, id_materia, id_comision, rol)
VALUES
	(43820123, 3641, 2900, 'alUmNO'),
	(43820123, 3641, 2900, 'DocEnTe');

-- Error: rol inexistente
INSERT INTO
	ddbba.cursa
VALUES
	(43820123, 3641, 2900, 'ReCtoR');
