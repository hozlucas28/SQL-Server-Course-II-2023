DROP TABLE ddbba.nombres;

DROP TABLE ddbba.apellidos;

DROP TABLE ddbba.localidades;

go
CREATE TABLE
	ddbba.nombres (
		nombre CHAR(32) NOT NULL,
		CONSTRAINT pk_nombre PRIMARY KEY (nombre),
		CONSTRAINT nombre_unique UNIQUE (nombre),
	);

go
CREATE TABLE
	ddbba.apellidos (
		apellido CHAR(32) NOT NULL,
		CONSTRAINT pk_apellido PRIMARY KEY (apellido),
		CONSTRAINT apellido_unique UNIQUE (apellido),
	);

go
CREATE TABLE
	ddbba.localidades (
		localidad CHAR(64) NOT NULL,
		CONSTRAINT pk_localidad PRIMARY KEY (localidad),
		CONSTRAINT localidad_unique UNIQUE (localidad),
	);

go
INSERT INTO
	ddbba.nombres (nombre)
VALUES
	('Sophia'),
	('Jackson'),
	('Olivia'),
	('Liam'),
	('Emma'),
	('Noah'),
	('Ava'),
	('Elijah'),
	('Charlotte'),
	('William'),
	('Amelia'),
	('James'),
	('Mia'),
	('Benjamin'),
	('Harper'),
	('Lucas'),
	('Evelyn'),
	('Mason'),
	('Abigail'),
	('Ethan'),
	('Emily'),
	('Alexander'),
	('Ella'),
	('Henry'),
	('Avery'),
	('Jacob'),
	('Sofia'),
	('Michael'),
	('Camila'),
	('Daniel'),
	('Aria'),
	('Matthew'),
	('Scarlett'),
	('Luke'),
	('Victoria'),
	('Jonathan'),
	('Madison'),
	('Owen'),
	('Luna'),
	('Carter'),
	('Chloe'),
	('Sebastian'),
	('Lily'),
	('Jayden'),
	('Grace'),
	('Gabriel'),
	('Zoey'),
	('Julian'),
	('Penelope'),
	('Wyatt');

go
INSERT INTO
	ddbba.apellidos (apellido)
VALUES
	('Johnson'),
	('Jones'),
	('Brown'),
	('Davis'),
	('Miller'),
	('Wilson'),
	('Moore'),
	('Taylor'),
	('Anderson'),
	('Thomas'),
	('Jackson'),
	('White'),
	('Harris'),
	('Martin'),
	('Thompson'),
	('Garcia'),
	('Martinez'),
	('Robinson'),
	('Clark'),
	('Rodriguez'),
	('Lewis'),
	('Lee'),
	('Walker'),
	('Hall'),
	('Allen'),
	('Young'),
	('King'),
	('Wright'),
	('Scott'),
	('Green'),
	('Baker'),
	('Adams'),
	('Nelson'),
	('Carter'),
	('Mitchell'),
	('Perez'),
	('Roberts'),
	('Turner'),
	('Phillips'),
	('Campbell'),
	('Parker'),
	('Evans'),
	('Edwards'),
	('Collins'),
	('Stewart'),
	('Sanchez'),
	('Morris'),
	('Rogers'),
	('Reed'),
	('Cook');

go
INSERT INTO ddbba.localidades (localidad)
VALUES
    ('New York'),
    ('Los Angeles'),
    ('Chicago'),
    ('Houston'),
    ('Phoenix');

go
CREATE OR ALTER PROCEDURE ddbba.crearRegistrosAleatorios
    @cantidad INT = 0
AS 
BEGIN
    DECLARE @dni INT
    DECLARE @patente CHAR(8)
    DECLARE @telefono CHAR(16)
    DECLARE @localidad CHAR(64)
    DECLARE @fecha_nacimiento DATETIME
    DECLARE @primer_nombre CHAR(32)
    DECLARE @segundo_nombre CHAR(32)
    DECLARE @apellido CHAR(32)

    WHILE @cantidad > 0
    BEGIN
        SET @dni = (SELECT CAST(RAND()*(100000000) AS INT))
        SET @telefono = (SELECT  CAST(RAND()*(10000000) AS INT))
        SET @localidad = (SELECT TOP 1 localidad FROM ddbba.localidades ORDER BY NEWID())
        SET @fecha_nacimiento = (SELECT DATEADD(DAY, CONVERT(INT, CRYPT_GEN_RANDOM(2)), '1900-01-01T00:00:00'))
        SET @primer_nombre = (SELECT TOP 1 nombre FROM ddbba.nombres ORDER BY NEWID())
        SET @segundo_nombre = (SELECT TOP 1 nombre FROM ddbba.nombres ORDER BY NEWID())
        SET @apellido = (SELECT TOP 1 apellido FROM ddbba.apellidos ORDER BY NEWID())
        SET @patente = (SELECT CHAR(ASCII('A') + CAST(RAND() * 26 AS INT)) + 
                        CHAR(ASCII('A') + CAST(RAND() * 26 AS INT)) + 
                        CAST(CAST(RAND()*(898)+100 AS INT) AS CHAR(3)) +
                        CHAR(ASCII('A') + CAST(RAND() * 26 AS INT)) + 
                        CHAR(ASCII('A') + CAST(RAND() * 26 AS INT)))

        INSERT INTO ddbba.personas (dni, telefono, localidad, fecha_nacimiento, primer_nombre, segundo_nombre, apellido, patente)
            VALUES (@dni, @telefono, @localidad, @fecha_nacimiento, @primer_nombre, @segundo_nombre, @apellido, @patente)
        SET @cantidad = (@cantidad - 1)
    END
END;

