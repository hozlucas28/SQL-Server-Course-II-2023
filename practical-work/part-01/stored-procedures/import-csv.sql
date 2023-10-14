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

	EXEC [archivos].[importarDatosCSV] @tablaDestino = '#medicos_importados', @rutaArchivo = @rutaArchivo, @delimitadorCampos = @separador

	DECLARE @count INT = @@ROWCOUNT
 
	DECLARE	@nombre VARCHAR(255)
	DECLARE @apellido VARCHAR(255)
	DECLARE	@especialidad VARCHAR(255)
	DECLARE @idEspecialidad INT
	DECLARE @nroMatricula INT

	WHILE @count > 0
	BEGIN
		SELECT TOP(1) 
			@nombre = nombre,
			@apellido = apellido,
			@especialidad = especialidad,
			@nroMatricula = NroMatricula
		FROM [#medicos_importados]

		EXEC [datos].[guardarEspecialidad] @especialidad, @idEspecialidad OUTPUT;

		INSERT INTO [datos].[medicos] (
            nombre,
            apellido,
            id_especialidad,
            nro_matricula
        ) VALUES (
            @nombre,
            @apellido,
            @idEspecialidad,
            @nroMatricula
        )

		DELETE TOP(1) FROM [#medicos_importados]
		SET @count = @count - 1
	END

	DROP TABLE [#medicos_importados]
END;

-- Importar prestadores desde un archivo CSV
GO
CREATE OR ALTER PROCEDURE [archivos].[importarPrestadoresCSV]
	@rutaArchivo VARCHAR(255),
	@separador VARCHAR(4) = ';'
AS
BEGIN
	CREATE TABLE [#prestadores_importados] (
		nombre VARCHAR(255),
		planPrestador VARCHAR(255),
		campoVacio CHAR,
	)

	EXEC [archivos].[importarDatosCSV] @tablaDestino = '#prestadores_importados', @rutaArchivo = @rutaArchivo, @delimitadorCampos = @separador

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
		tipoDocumento VARCHAR(255),
		nroDocumento INT,
		sexo VARCHAR(20),
		genero VARCHAR(20),
		telefono VARCHAR(40),
		nacionalidad VARCHAR(255),
		mail VARCHAR(100),
		calleYNro VARCHAR(255),
		localidad VARCHAR(255),
		provincia VARCHAR(255)
	)

	CREATE TABLE [#pacientes_importados_formateados] (
		nombre VARCHAR(255),
		apellido VARCHAR(255),
		fechaNacimiento DATE,
		tipoDocumento VARCHAR(255),
		nroDocumento INT,
		sexo VARCHAR(20),
		genero VARCHAR(20),
		telefono VARCHAR(40),
		nacionalidad VARCHAR(255),
		mail VARCHAR(100),
		calleYNro VARCHAR(255),
		localidad VARCHAR(255),
		provincia VARCHAR(255)
	)

	EXEC [archivos].[importarDatosCSV] @tablaDestino = '#pacientes_importados', @rutaArchivo = @rutaArchivo, @delimitadorCampos = @separador
	
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
	
	DECLARE @count INT = @@ROWCOUNT
	DECLARE @nombre VARCHAR(255)
	DECLARE @apellido VARCHAR(255)
	DECLARE @fechaNacimiento DATE
	DECLARE @tipoDocumento VARCHAR(50)
	DECLARE @idTipoDoc INT
	DECLARE @nroDocumento VARCHAR(255)
	DECLARE @sexo VARCHAR(20)
	DECLARE @sexoChar CHAR;
	DECLARE @genero VARCHAR(50)
	DECLARE @idGenero INT
	DECLARE @telefono VARCHAR(40)
	DECLARE @nacionalidad VARCHAR(50)
	DECLARE @idNacionalidad INT
	DECLARE @mail VARCHAR(100)
	DECLARE @calleYNro VARCHAR(50)
	DECLARE @localidad VARCHAR(255)
	DECLARE @provincia VARCHAR(50)
	DECLARE @idDireccion INT
	
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

		-- validaciones, se pueden poner mas
		IF(DATEDIFF(YEAR, @fechaNacimiento, GETDATE()) BETWEEN 0 AND 120 
			AND @mail LIKE '%@%.%' AND @mail NOT LIKE '%@%.%@%'
			AND [datos].[existePacientePorEmail](@mail) = 0)
		BEGIN
			EXEC [referencias].[obtenerOInsertarIdNacionalidad] @Nacionalidad, @IdNacionalidad OUTPUT;
			EXEC [referencias].[obtenerOIsertarIdTipoDocumento] @TipoDocumento, @IdTipoDoc OUTPUT; 
			EXEC [referencias].[obtenerOInsertarIdGenero] @Genero, @IdGenero OUTPUT;
			SET @SexoChar = [utils].[obtenerCharSexo](@Sexo); 
			EXEC [referencias].[obtenerOInsertarIdDireccion] @CalleYNro, @Localidad, @Provincia, @IdDireccion OUTPUT;

			INSERT INTO [datos].[pacientes] (
				nombre,
				apellido,
				email,
				fecha_nacimiento,
				id_direccion,
				id_tipo_documento,
				nro_documento,
				nacionalidad,
				sexo_biologico,
				id_genero,
				tel_fijo,
				fecha_actualizacion
			) VALUES (
				@nombre,
				@apellido,
				@mail,
				@fechaNacimiento,
				@idDireccion,
				@idTipoDoc,
				@nroDocumento,
				@idNacionalidad,
				@sexoChar,
				@idGenero,
				@telefono,
				GETDATE()
			)
		END
		DELETE TOP (1) FROM [#pacientes_importados_formateados]
		SET @count = @count - 1
	END

	DROP TABLE [#pacientes_importados]
    DROP TABLE [#pacientes_importados_formateados]
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