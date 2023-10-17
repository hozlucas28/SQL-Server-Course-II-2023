GO
USE [cure_sa];

-- Importar médicos desde un archivo CSV
GO
CREATE OR ALTER PROCEDURE [archivos].[importarMedicosCSV]
	@rutaArchivo VARCHAR(255),
	@separador VARCHAR(4) = ';'
AS
BEGIN
	CREATE TABLE [#medicos_importados] (
		apellido VARCHAR(255),
		nombre VARCHAR(255),
		especialidad VARCHAR(255),
		nroMatricula INT
	)

	EXEC [archivos].[importarDatosCSV] 
		@tablaDestino = '#medicos_importados', 
		@rutaArchivo = @rutaArchivo, 
		@delimitadorCampos = @separador


	DECLARE	@nombre VARCHAR(255)
	DECLARE @apellido VARCHAR(255)
	DECLARE	@especialidad VARCHAR(255)
	DECLARE @idEspecialidad INT
	DECLARE @nroMatricula INT
	DECLARE @count INT;

	DELETE FROM #medicos_importados 
	WHERE #medicos_importados.nroMatricula IN (SELECT nro_matricula FROM datos.medicos);

	SELECT @count = count(*) FROM #medicos_importados;

	WHILE @count > 0
	BEGIN
		SELECT TOP(1) 
			@nombre = nombre,
			@apellido = apellido,
			@especialidad = especialidad,
			@nroMatricula = NroMatricula
		FROM [#medicos_importados]

		EXEC [datos].[guardarEspecialidad] 
			@especialidad, 
			@idEspecialidad OUTPUT;

		EXEC [datos].[insertarMedico] 
			@nombre, 
			@apellido, 
			@idEspecialidad, 
			@nroMatricula;

		DELETE TOP(1) FROM [#medicos_importados]
		SET @count = @count - 1
	END

	DROP TABLE [#medicos_importados];
END;

-- Importar prestadores desde un archivo CSV
GO
CREATE OR ALTER PROCEDURE [archivos].[importarPrestadoresCSV]
	@rutaArchivo VARCHAR(255),
	@separador VARCHAR(4) = ';'
AS
BEGIN
	CREATE TABLE [#prestadores_importados] (
		nombre VARCHAR(255) COLLATE Latin1_General_CS_AS, 
		planPrestador VARCHAR(255) COLLATE Latin1_General_CS_AS,
		campoVacio CHAR,
	)

	EXEC [archivos].[importarDatosCSV] @tablaDestino = '#prestadores_importados', @rutaArchivo = @rutaArchivo, @delimitadorCampos = @separador

	DELETE FROM [#prestadores_importados]
	WHERE EXISTS (
    	SELECT 1
  		FROM [datos].[prestadores] AS p
  	  	WHERE [#prestadores_importados].nombre = p.nombre AND  [#prestadores_importados].planPrestador = p.plan_prestador
	);


	INSERT INTO [datos].[prestadores] (nombre, plan_prestador) SELECT nombre, planPrestador FROM [#prestadores_importados]
	DROP TABLE [#prestadores_importados]
END;

-- Importar pacientes desde un archivo CSV
GO
CREATE OR ALTER PROCEDURE [archivos].[importarPacientesCSV]
	@rutaArchivo VARCHAR(255),
	@separador VARCHAR(4) = ';'
AS
BEGIN
    CREATE TABLE [#pacientes_importados] (
		nombre VARCHAR(255),
		apellido VARCHAR(255),
		fechaNacimiento VARCHAR(20),
		tipoDocumento VARCHAR(20),
		nroDocumento INT,
		sexo VARCHAR(20),
		genero VARCHAR(20),
		telefono VARCHAR(40),
		nacionalidad VARCHAR(50),
		mail VARCHAR(100),
		calleYNro VARCHAR(255),
		localidad VARCHAR(255),
		provincia VARCHAR(255)
	)

	CREATE TABLE [#pacientes_importados_formateados] (
		nombre VARCHAR(255),
		apellido VARCHAR(255),
		fechaNacimiento DATE,
		tipoDocumento VARCHAR(20),
		nroDocumento INT,
		sexo VARCHAR(20),
		genero VARCHAR(20),
		telefono VARCHAR(40),
		nacionalidad VARCHAR(50),
		mail VARCHAR(100),
		calleYNro VARCHAR(255),
		localidad VARCHAR(255),
		provincia VARCHAR(255)
	)
	
	CREATE TABLE [#registros_invalidos] (
		nombre VARCHAR(255),
		apellido VARCHAR(255),
		fechaNacimiento DATE,
		tipoDocumento VARCHAR(20),
		nroDocumento INT,
		sexo VARCHAR(20),
		genero VARCHAR(20),
		telefono VARCHAR(40),
		nacionalidad VARCHAR(50),
		mail VARCHAR(100),
		calleYNro VARCHAR(255),
		localidad VARCHAR(255),
		provincia VARCHAR(255),
		error_desc VARCHAR(255)
	)

	EXEC [archivos].[importarDatosCSV] 
		@tablaDestino = '#pacientes_importados', 
		@rutaArchivo = @rutaArchivo, 
		@delimitadorCampos = @separador;
	
	INSERT INTO [#pacientes_importados_formateados]
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
		mail,
		calleYNro,
		localidad,
		provincia
	FROM [#pacientes_importados]
	
	-- Validaciones

	INSERT INTO [#registros_invalidos]
	SELECT *, 'Registros duplicados'
	FROM [#pacientes_importados_formateados] GROUP BY
		nombre,
		apellido,
		fechaNacimiento,
		tipoDocumento,
		nroDocumento,
		sexo,
		genero,
		telefono,
		nacionalidad,
		mail,
		calleYNro,
		localidad,
		provincia	
	HAVING COUNT(*) > 1

	INSERT INTO [#registros_invalidos] SELECT *, 'Documento no numérico' FROM [#pacientes_importados_formateados]
        WHERE ISNUMERIC(NroDocumento) = 0

    INSERT INTO [#registros_invalidos] SELECT *, 'Mayor a 120 años' FROM [#pacientes_importados_formateados]
        WHERE DATEDIFF(YEAR, fechaNacimiento, GETDATE()) NOT BETWEEN 0 AND 120

    INSERT INTO [#registros_invalidos] SELECT *, 'Mail inválido' FROM [#pacientes_importados_formateados]
	    WHERE mail NOT LIKE '%_@_%.%'

	INSERT INTO #registros_invalidos 
	SELECT *, 'Mail repetido' FROM #pacientes_importados_formateados AS pif
	WHERE EXISTS (
		SELECT 1 FROM #pacientes_importados_formateados
		WHERE mail = pif.mail
		HAVING COUNT(nroDocumento) > 1
	)
	AND nroDocumento NOT IN (
		SELECT MAX(nroDocumento) FROM #pacientes_importados_formateados
		WHERE mail = pif.mail
		GROUP BY mail
		HAVING COUNT(nroDocumento) > 1
	);

	-- Borrar registros invalidos de pacientes importados formateados

	DELETE FROM #pacientes_importados_formateados
	WHERE EXISTS (
    SELECT 1
    FROM #registros_invalidos ri
    WHERE 
        ri.nombre = #pacientes_importados_formateados.nombre AND
        ri.apellido = #pacientes_importados_formateados.apellido AND
        ri.fechaNacimiento = #pacientes_importados_formateados.fechaNacimiento AND
        ri.tipoDocumento = #pacientes_importados_formateados.tipoDocumento AND
        ri.nroDocumento = #pacientes_importados_formateados.nroDocumento AND
        ri.sexo = #pacientes_importados_formateados.sexo AND
        ri.genero = #pacientes_importados_formateados.genero AND
        ri.telefono = #pacientes_importados_formateados.telefono AND
        ri.nacionalidad = #pacientes_importados_formateados.nacionalidad AND
        ri.mail = #pacientes_importados_formateados.mail AND
        ri.calleYNro = #pacientes_importados_formateados.calleYNro AND
        ri.localidad = #pacientes_importados_formateados.localidad AND
        ri.provincia = #pacientes_importados_formateados.provincia
	);
	
	-- Agregar información a los registros de pacientes
	
	BEGIN TRY
		DECLARE 
			@nombre VARCHAR(255), @apellido VARCHAR(255), @fechaNacimiento DATE,
			@tipoDocumento VARCHAR(20), @nroDocumento INT, 
			@sexo VARCHAR(20), @genero VARCHAR(20),
			@telefono VARCHAR(40), @nacionalidad VARCHAR(50), @mail VARCHAR(40), 
			@calleYNro VARCHAR(255), @localidad VARCHAR(255), @provincia VARCHAR(255); 
		DECLARE 
			@idDireccion INT, @idTipoDocumento INT, @idNacionalidad INT, @sexoChar CHAR(1), @idGenero INT;
		DECLARE 
			@count INT = (SELECT count(1) from [#pacientes_importados_formateados]);

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
				@mail = mail,
				@calleYNro = calleYNro,
				@localidad = localidad,
				@provincia = provincia
			FROM [#pacientes_importados_formateados];

			EXEC [referencias].[obtenerOInsertarIdDireccion] @calleYNro, @localidad, @provincia, @idDireccion OUT;
			EXEC [referencias].[obtenerOIsertarIdTipoDocumento] @tipoDocumento, @idTipoDocumento OUT;
			EXEC [referencias].[obtenerOInsertarIdNacionalidad] @nacionalidad, @idNacionalidad OUT;
			SET @sexoChar = [utils].[obtenerCharSexo](@sexo); 
			EXEC [referencias].[obtenerOInsertarIdGenero] @genero, @idGenero OUT;

			EXEC [datos].[insertarPaciente]	
				@apellido,
				NULL,
				@mail,
				@fechaNacimiento,
				NULL,
				NULL,
				@idDireccion,
				@idGenero,
				@idTipoDocumento,
				@idNacionalidad,
				@nombre,
				@nroDocumento,
				@sexoChar,
				@telefono,
				NULL,
				NULL;
			
			DELETE TOP (1) FROM [#pacientes_importados_formateados]
			SET @count = @count - 1 
		END
	END TRY
	BEGIN CATCH
		DECLARE @errorMessage NVARCHAR(1000)
		SET @errorMessage = ERROR_MESSAGE()
		PRINT 'Error durante la inserción: ' + @errorMessage;
		THROW;
	END CATCH
	
	SELECT count(1) AS CantRegistrosInvalidos FROM [#registros_invalidos];

	DROP TABLE [#pacientes_importados];
    DROP TABLE [#pacientes_importados_formateados];
	DROP TABLE [#registros_invalidos];
END;

-- Importar sedes desde un archivo CSV
GO
CREATE OR ALTER PROCEDURE [archivos].[importarSedesCSV]
	@rutaArchivo VARCHAR(255),
	@separador VARCHAR(4) = ';'
AS
BEGIN
	CREATE TABLE [#sedes_importadas] (
		nombreSede VARCHAR(255),
		calleYNro VARCHAR (255),
		localidad VARCHAR (255),
		provincia VARCHAR (255)
	)

	EXEC [archivos].[importarDatosCSV] @tablaDestino = '#sedes_importadas', @rutaArchivo = @rutaArchivo, @delimitadorCampos = @separador

	DECLARE @count INT = @@ROWCOUNT

	DECLARE @nombreSede VARCHAR(255)
	DECLARE @calleYNro VARCHAR(255)
	DECLARE @localidad VARCHAR(255)
	DECLARE @provincia VARCHAR(255)
	DECLARE @idDireccion VARCHAR(255)

	WHILE @count > 0
	BEGIN
		SELECT TOP(1)
			@nombreSede = nombreSede,
			@calleYNro = calleYNro,
			@localidad = localidad,
			@provincia = provincia
		FROM [#sedes_importadas]

		EXEC [referencias].[obtenerOInsertarIdDireccion] @CalleYNro, @Localidad, @Provincia, @idDireccion OUTPUT;

		INSERT INTO [datos].[sede_de_atencion] (nombre, direccion) VALUES (@nombreSede, @idDireccion)
	
		DELETE TOP(1) FROM [#sedes_importadas]
		SET @count = @count - 1
	END

	DROP TABLE [#sedes_importadas]
END;