-- Creación de la tabla "materias"
CREATE TABLE
	ddbba.materias (
		id INT IDENTITY (1, 1) NOT NULL,
		nombre CHAR(64) NOT NULL,
		CONSTRAINT pk_materia_id PRIMARY KEY (id)
	);

-- Creación de la tabla "cursos"
CREATE TABLE
	ddbba.cursos (
		id INT IDENTITY (1, 1) NOT NULL,
		comision TINYINT NOT NULL,
		materia INT NOT NULL,
		CONSTRAINT pk_curso_id PRIMARY KEY (id),
		CONSTRAINT fk_materia_id FOREIGN KEY (materia) REFERENCES ddbba.materias (id)
	);

-- Creación de la tabla "personas"
CREATE TABLE
	ddbba.personas (
		dni INT IDENTITY (1, 1) NOT NULL,
		patente CHAR(8) CHECK (patente LIKE '^([a-zA-Z]|[0-9])*$') NULL,
		telefono CHAR(16) CHECK (telefono LIKE '^[0-9]*$') NULL,
		localidad CHAR(64) CHECK (localidad LIKE '^[a-zA-Z]*$') NULL,
		fecha_nacimiento DATETIME NOT NULL,
		primer_nombre CHAR(32) CHECK (primer_nombre LIKE '^[a-zA-Z]*$') NOT NULL,
		segundo_nombre CHAR(32) CHECK (segundo_nombre LIKE '^[a-zA-Z]*$') NULL,
		curso INT NOT NULL,
		apellido CHAR(32) CHECK (apellido LIKE '^[a-zA-Z]*$') NOT NULL,
		CONSTRAINT pk_persona_dni PRIMARY KEY (dni),
		CONSTRAINT fk_curso_id FOREIGN KEY (curso) REFERENCES ddbba.cursos (id)
	);

-- Creación de la tabla "cursa"
CREATE TABLE
	ddbba.cursa (
		id_persona INT NOT NULL,
		id_materia INT NOT NULL,
		rol CHAR(8) CHECK (rol IN ('ALUMNO', 'DOCENTE')) NOT NULL,
		CONSTRAINT pk_persona_id PRIMARY KEY (id_persona),
		CONSTRAINT fk_persona_id FOREIGN KEY (id_persona) REFERENCES ddbba.personas (dni),
		CONSTRAINT fk_materia FOREIGN KEY (id_materia) REFERENCES ddbba.cursos (id),
	);

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
