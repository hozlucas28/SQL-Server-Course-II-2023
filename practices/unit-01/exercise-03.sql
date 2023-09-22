DROP TABLE ddbba.registros;

go
-- Creación de la tabla "registro"
CREATE TABLE
	ddbba.registros (
		id INT IDENTITY (1, 1) NOT NULL,
		fecha_hora DATETIME DEFAULT GETDATE (),
		texto CHAR(50),
		modulo CHAR(10),
		CONSTRAINT pk_registro PRIMARY KEY (id),
	);
