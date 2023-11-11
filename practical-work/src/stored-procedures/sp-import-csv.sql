USE [cure_sa];
GO

-- Importar médicos desde un archivo CSV
CREATE OR ALTER PROCEDURE [archivos].[importarMedicosCSV]
	@rutaArchivo VARCHAR(255),
	@separador VARCHAR(4) = ';'
AS
BEGIN
	IF OBJECT_ID('tempdb..#MedicosImportados') IS NOT NULL
		DROP TABLE [#MedicosImportados]
	
	CREATE TABLE [#MedicosImportados] (
		apellido VARCHAR(255),
		nombre VARCHAR(255),
		especialidad VARCHAR(255),
		nroMatricula INT PRIMARY KEY
	)

	EXEC [archivos].[importarDatosCSV] 
		@tablaDestino = '#MedicosImportados', 
		@rutaArchivo = @rutaArchivo, 
		@delimitadorCampos = @separador

	DECLARE	@nombre VARCHAR(255)
	DECLARE @apellido VARCHAR(255)
	DECLARE	@especialidad VARCHAR(255)
	DECLARE @idEspecialidad INT
	DECLARE @nroMatricula INT
	DECLARE @count INT;

	DELETE FROM [#MedicosImportados] 
	WHERE #MedicosImportados.nroMatricula IN (SELECT nro_matricula FROM [datos].[medicos]);

	SELECT @count = count(*) FROM #MedicosImportados;

	SET NOCOUNT ON;
	WHILE @count > 0
	BEGIN
		SELECT TOP(1) 
			@nombre = nombre,
			@apellido = apellido,
			@especialidad = especialidad,
			@nroMatricula = NroMatricula
		FROM [#MedicosImportados]

		EXEC [datos].[guardarEspecialidad] 
			@especialidad, 
			@idEspecialidad OUTPUT;

		EXEC [datos].[insertarMedico] 
			@nombre, 
			@apellido, 
			@idEspecialidad, 
			@nroMatricula;

		DELETE TOP(1) FROM [#MedicosImportados]
		SET @count = @count - 1
	END
	SET NOCOUNT 0;

	DROP TABLE [#MedicosImportados];
END;

-- Importar prestadores desde un archivo CSV
GO
CREATE OR ALTER PROCEDURE [archivos].[importarPrestadoresCSV]
	@rutaArchivo VARCHAR(255),
	@separador VARCHAR(4) = ';'
AS
BEGIN
	IF OBJECT_ID('tempdb..#PrestadoresImportados') IS NOT NULL
		DROP TABLE [#PrestadoresImportados]
	
	CREATE TABLE [#PrestadoresImportados] (
		nombre VARCHAR(255), 
		planPrestador VARCHAR(255),
		campoVacio CHAR,
	)

	EXEC [archivos].[importarDatosCSV] 
		@tablaDestino = '#PrestadoresImportados', 
		@rutaArchivo = @rutaArchivo, 
		@delimitadorCampos = @separador

	DELETE FROM [#PrestadoresImportados]
	WHERE EXISTS (
    	SELECT 1
  		FROM [datos].[prestadores] AS p
  	  	WHERE 
			[#PrestadoresImportados].nombre = p.nombre AND 
			[#PrestadoresImportados].planPrestador = p.plan_prestador
	);

	INSERT INTO [datos].[prestadores] (nombre, plan_prestador) 
	SELECT nombre, planPrestador FROM [#PrestadoresImportados]
	
	DROP TABLE [#PrestadoresImportados]
END;

-- Importar pacientes desde un archivo CSV
GO
CREATE OR ALTER PROCEDURE [archivos].[importarPacientesCSV]
	@rutaArchivo VARCHAR(255),
	@separador VARCHAR(4) = ';'
AS
BEGIN
	IF OBJECT_ID('tempdb..#PacientesImportados') IS NOT NULL
		DROP TABLE [#PacientesImportados]

    CREATE TABLE [#PacientesImportados] (
		nombre VARCHAR(255),
		apellido VARCHAR(255),
		fechaNacimiento VARCHAR(20),
		tipoDocumento VARCHAR(20),
		nroDocumento INT PRIMARY KEY,
		sexo VARCHAR(20),
		genero VARCHAR(20),
		telefono VARCHAR(40),
		nacionalidad VARCHAR(50),
		email VARCHAR(100),
		calleYNro VARCHAR(255),
		localidad VARCHAR(255),
		provincia VARCHAR(255)
	)
	
	IF OBJECT_ID('tempdb..#PacientesImportadosFormateados') IS NOT NULL
		DROP TABLE [#PacientesImportadosFormateados]
	
	CREATE TABLE [#PacientesImportadosFormateados] (
		nombre VARCHAR(255),
		apellido VARCHAR(255),
		fechaNacimiento DATE,
		tipoDocumento VARCHAR(20),
		nroDocumento INT PRIMARY KEY,
		sexo VARCHAR(20),
		genero VARCHAR(20),
		telefono VARCHAR(40),
		nacionalidad VARCHAR(50),
		email VARCHAR(100),
		calleYNro VARCHAR(255),
		localidad VARCHAR(255),
		provincia VARCHAR(255)
	)
	
	IF OBJECT_ID('tempdb..#RegistrosInvalidos') IS NOT NULL
		DROP TABLE [#RegistrosInvalidos]
	
	CREATE TABLE [#RegistrosInvalidos] (
		nombre VARCHAR(255),
		apellido VARCHAR(255),
		fechaNacimiento DATE,
		tipoDocumento VARCHAR(20),
		nroDocumento INT,
		sexo VARCHAR(20),
		genero VARCHAR(20),
		telefono VARCHAR(40),
		nacionalidad VARCHAR(50),
		email VARCHAR(100),
		calleYNro VARCHAR(255),
		localidad VARCHAR(255),
		provincia VARCHAR(255),
		error_desc VARCHAR(255)
	)

	EXEC [archivos].[importarDatosCSV] 
		@tablaDestino = '#PacientesImportados', 
		@rutaArchivo = @rutaArchivo, 
		@delimitadorCampos = @separador;
	
	SET NOCOUNT ON

	INSERT INTO [#PacientesImportadosFormateados]
	SELECT
		nombre,
		apellido,
		CONVERT(DATE, fechaNacimiento, 103) AS fechaNacimiento,
		tipoDocumento,
		nroDocumento,
		sexo,
		genero,
		telefono,
		nacionalidad,
		email,
		calleYNro,
		localidad,
		provincia
	FROM [#PacientesImportados]
	
	DROP TABLE [#PacientesImportados];

	-- Validaciones

	INSERT INTO [#RegistrosInvalidos]
	SELECT 
		nombre,
		apellido,
		fechaNacimiento,
		tipoDocumento,
		nroDocumento,
		sexo,
		genero,
		telefono,
		nacionalidad,
		email,
		calleYNro,
		localidad,
		provincia, 
		'Registros duplicados'
	FROM [#PacientesImportadosFormateados] GROUP BY
		nombre,
		apellido,
		fechaNacimiento,
		tipoDocumento,
		nroDocumento,
		sexo,
		genero,
		telefono,
		nacionalidad,
		email,
		calleYNro,
		localidad,
		provincia	
	HAVING COUNT(*) > 1

	INSERT INTO [#RegistrosInvalidos] SELECT *, 'Documento no numérico' FROM [#PacientesImportadosFormateados]
        WHERE ISNUMERIC(nroDocumento) = 0

    INSERT INTO [#RegistrosInvalidos] SELECT *, 'Mayor a 120 años' FROM [#PacientesImportadosFormateados]
        WHERE DATEDIFF(YEAR, fechaNacimiento, GETDATE()) NOT BETWEEN 0 AND 120

    INSERT INTO [#RegistrosInvalidos] SELECT *, 'Email inválido' FROM [#PacientesImportadosFormateados]
	    WHERE email NOT LIKE '%_@_%.%'

	INSERT INTO #RegistrosInvalidos 
	SELECT *, 'Email repetido' FROM #PacientesImportadosFormateados AS pif
	WHERE EXISTS (
		SELECT 1 FROM #PacientesImportadosFormateados
		WHERE email = pif.email
		HAVING COUNT(nroDocumento) > 1
	)
	AND nroDocumento NOT IN (
		SELECT MAX(nroDocumento) FROM #PacientesImportadosFormateados
		WHERE email = pif.email
		GROUP BY email
		HAVING COUNT(nroDocumento) > 1
	);

	-- Borrar registros invalidos de pacientes importados formateados

	DELETE FROM #PacientesImportadosFormateados
	WHERE EXISTS (
    SELECT 1
    FROM #RegistrosInvalidos ri
    WHERE 
        ri.tipoDocumento = #PacientesImportadosFormateados.tipoDocumento AND
        ri.nroDocumento = #PacientesImportadosFormateados.nroDocumento 
	);

	-- Agregar información a los registros de pacientes
	
	BEGIN TRY
		DECLARE 
			@nombre VARCHAR(255), @apellido VARCHAR(255), @fechaNacimiento DATE,
			@tipoDocumento VARCHAR(20), @nroDocumento INT, 
			@sexo VARCHAR(20), @genero VARCHAR(20),
			@telefono VARCHAR(40), @nacionalidad VARCHAR(50), @email VARCHAR(40), 
			@calleYNro VARCHAR(255), @localidad VARCHAR(255), @provincia VARCHAR(255); 
		DECLARE 
			@idDireccion INT, @idTipoDocumento INT, @idNacionalidad INT, @sexoChar CHAR(1), @idGenero INT;
		DECLARE 
			@count INT = (SELECT count(1) from [#PacientesImportadosFormateados]);

		

		WHILE @count > 0
		BEGIN 
			SELECT TOP(1)
				@nombre = nombre,
				@apellido = apellido,
				@fechaNacimiento = fechaNacimiento,
				@tipoDocumento = tipoDocumento,
				@nroDocumento = nroDocumento,
				@sexo = sexo,
				@genero = genero,
				@telefono = telefono,
				@nacionalidad = nacionalidad,
				@email = email,
				@calleYNro = calleYNro,
				@localidad = localidad,
				@provincia = provincia
			FROM [#PacientesImportadosFormateados];

			EXEC [datos].[insertarPaciente] 
				@nombre, 
				@apellido, 
				@fechaNacimiento, 
				@tipoDocumento, 
				@nroDocumento,
				@sexo, 
				@genero, 
				@telefono, 
				@nacionalidad, 
				@email, 
				@calleYNro, 
				@localidad, 
				@provincia;
			
			DELETE TOP (1) FROM [#PacientesImportadosFormateados]
			SET @count = @count - 1 
		END
	END TRY
	BEGIN CATCH
		DECLARE @errorMessage NVARCHAR(1000)
		SET @errorMessage = 'Error durante la inserción de pacientes: ' + ERROR_MESSAGE();
		THROW 51004, @errorMessage, 1;
	END CATCH
	
	DECLARE @cantTotalRI INT = (SELECT count(1) FROM [#RegistrosInvalidos]);
	
	IF @cantTotalRI > 0
	BEGIN
		PRINT 'Cantidad total de registros inválidos: ' + CAST(@cantTotalRI AS VARCHAR);
		SELECT error_desc, count(1) AS Cant FROM [#RegistrosInvalidos]
		GROUP BY error_desc
	END
	ELSE PRINT 'Registros sin errores.'
	
	SET NOCOUNT OFF

    DROP TABLE [#PacientesImportadosFormateados];
	DROP TABLE [#RegistrosInvalidos];
END;

-- Importar sedes desde un archivo CSV
GO
CREATE OR ALTER PROCEDURE [archivos].[importarSedesCSV]
	@rutaArchivo VARCHAR(255),
	@separador VARCHAR(4) = ';'
AS
BEGIN
	IF OBJECT_ID('tempdb..#SedesImportadas') IS NOT NULL
		DROP TABLE [#SedesImportadas]

	CREATE TABLE [#SedesImportadas] (
		nombreSede VARCHAR(255),
		calleYNro VARCHAR (255),
		localidad VARCHAR (255),
		provincia VARCHAR (255)
	)

	EXEC [archivos].[importarDatosCSV] 
		@tablaDestino = '#SedesImportadas', 
		@rutaArchivo = @rutaArchivo, 
		@delimitadorCampos = @separador

	DECLARE @count INT = (SELECT count(1) FROM [#SedesImportadas])

	DECLARE @nombreSede VARCHAR(255)
	DECLARE @calleYNro VARCHAR(255)
	DECLARE @localidad VARCHAR(255)
	DECLARE @provincia VARCHAR(255)
	DECLARE @idDireccion VARCHAR(255)

	SET NOCOUNT ON;

	WHILE @count > 0
	BEGIN
		SELECT TOP(1)
			@nombreSede = nombreSede,
			@calleYNro = calleYNro,
			@localidad = localidad,
			@provincia = provincia
		FROM [#SedesImportadas]

		EXEC [referencias].[obtenerOInsertarIdDireccion] 
			@calleYNro, 
			@localidad, 
			@provincia, 
			@idDireccion OUTPUT;

		INSERT INTO [datos].[sede_de_atencion] (nombre, direccion) 
		VALUES (@nombreSede, @idDireccion)
	
		DELETE TOP(1) FROM [#SedesImportadas]
		SET @count = @count - 1
	END

	SET NOCOUNT OFF;

	DROP TABLE [#SedesImportadas]
END;