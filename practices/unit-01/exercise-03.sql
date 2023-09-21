-- Creación de la tabla "registro"
CREATE TABLE
	ddbba.registros (
		id INT PRIMARY KEY IDENTITY (1, 1) NOT NULL,
		fecha_hora DATETIME DEFAULT GETDATE (),
		texto CHAR(50),
		modulo CHAR(10),
	);
