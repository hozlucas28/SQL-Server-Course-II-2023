DELETE FROM ddbba.registros;

DROP TRIGGER ddbba.normalizarRol;

DROP TABLE ddbba.cursa;

DROP TABLE ddbba.personas;

DROP TABLE ddbba.cursos;

DROP TABLE ddbba.materias;

go
-- Creación de la tabla "materias"
CREATE TABLE
	ddbba.materias (
		id INT NOT NULL,
		nombre CHAR(64) NOT NULL,
		CONSTRAINT pk_materia PRIMARY KEY (id),
		CONSTRAINT pk_materia_unique UNIQUE (id),
	);

go
-- Creación de la tabla "cursos"
CREATE TABLE
	ddbba.cursos (
		materia INT NOT NULL,
		comision SMALLINT NOT NULL,
		CONSTRAINT pk_curso PRIMARY KEY (materia, comision),
		CONSTRAINT pk_curso_unique UNIQUE (materia, comision),
		CONSTRAINT fk_materia_id FOREIGN KEY (materia) REFERENCES ddbba.materias (id)
	);

go
-- Creación de la tabla "personas"
CREATE TABLE
	ddbba.personas (
		dni INT NOT NULL,
		patente CHAR(8) NULL,
		telefono CHAR(16) NULL,
		localidad CHAR(64) NULL,
		fecha_nacimiento DATETIME NOT NULL,
		primer_nombre CHAR(32) NOT NULL,
		segundo_nombre CHAR(32) NULL,
		apellido CHAR(32) NOT NULL,
		CONSTRAINT pk_persona PRIMARY KEY (dni),
		CONSTRAINT patente_check CHECK (
			patente LIKE '[a-zA-Z][a-zA-Z][0-9][0-9][0-9][a-zA-Z][a-zA-Z]'
		),
		CONSTRAINT pk_persona_unique UNIQUE (dni),
	);

go
-- Creación de la tabla "cursa"
CREATE TABLE
	ddbba.cursa (
		id_persona INT NOT NULL,
		id_materia INT NOT NULL,
		id_comision SMALLINT NOT NULL,
		rol CHAR(8) NOT NULL,
		CONSTRAINT pk_cursa PRIMARY KEY (id_persona, id_materia, id_comision),
		CONSTRAINT rol_check CHECK (rol IN ('ALUMNO', 'DOCENTE')),
		CONSTRAINT fk_persona_id FOREIGN KEY (id_persona) REFERENCES ddbba.personas (dni),
		CONSTRAINT fk_materia FOREIGN KEY (id_materia, id_comision) REFERENCES ddbba.cursos (materia, comision),
	);

go
-- Creación del disparador para normalizar la inserción del rol en la tabla "cursa"
CREATE TRIGGER ddbba.normalizarRol ON ddbba.cursa AFTER INSERT,
UPDATE AS BEGIN
UPDATE ddbba.cursa
SET
	rol = UPPER(rol)
WHERE
	id_persona IN (
		SELECT
			id_persona
		FROM
			inserted
	) END;
