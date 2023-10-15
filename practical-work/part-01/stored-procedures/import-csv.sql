GO
USE [cure_sa];

-- Importar médicos desde un archivo CSV
GO
CREATE OR ALTER PROCEDURE [archivos].[importarMedicosCSV]
	@rutaArchivo NVARCHAR(255),
	@separador NCHAR(4) = ';',
	@rutaArchivoError NVARCHAR(255)
AS
BEGIN
	CREATE TABLE [#medicos_importados] (
		apellido VARCHAR(255),
		nombre VARCHAR(255),
		especialidad VARCHAR(255),
		nroMatricula INT
	)

	EXEC [archivos].[importarDatosCSV] @tablaDestino = '[#medicos_importados]', @rutaArchivo = @rutaArchivo, @delimitadorCampos = @separador

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

		SET @idEspecialidad = [utils].[obtenerIdEspecialidad](@especialidad)

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
	@rutaArchivo NVARCHAR(255),
	@separador NCHAR(4) = ';',
	@rutaArchivoError NVARCHAR(255)
AS
BEGIN
	CREATE TABLE [#prestadores_importados] (
		nombre VARCHAR(255),
		planPrestador VARCHAR(255),
		relleno CHAR
	)

	EXEC [archivos].[importarDatosCSV] @tablaDestino = '[#prestadores_importados]', @rutaArchivo = @rutaArchivo, @delimitadorCampos = @separador

	INSERT INTO [datos].[prestadores] (nombre, plan_prestador) SELECT nombre, planPrestador FROM [#prestadores_importados]
	DROP TABLE [#prestadores_importados]
END;
GO


-- Importar pacientes desde un archivo CSV
CREATE OR ALTER PROCEDURE [archivos].[importarPacientesCSV]
	@rutaArchivo NVARCHAR(255),
	@separador CHAR(1) = ';',
	@rutaArchivoError NVARCHAR(255)
AS
BEGIN
	EXEC [archivos].[importarDatosCSV] 
		@tablaDestino = '#pacientes_importados',
		@delimitadorCampos = @separador,
		@rutaArchivo = @rutaArchivo;

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

	---- Validaciones ----

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
		INSERT INTO [datos].[pacientes]
			(nombre, apellido, email,
			fecha_nacimiento/*, id_direccion*/, id_tipo_documento,
			nro_documento, nacionalidad, sexo_biologico,
			id_genero, tel_fijo, fecha_actualizacion)
		SELECT 
			nombre,
			apellido,
			mail,
			fechaNacimiento,
			/*1,*/
			[referencias].[obtenerIdTipoDocumento](tipoDocumento),
			nroDocumento,
			[referencias].[obtenerIdNacionalidad](nacionalidad),
			[utils].[obtenerCharSexo](sexo),
			[referencias].[obtenerIdGenero](genero),
			telefono,
			GETDATE()
		FROM [#pacientes_importados_formateados]; 
	END TRY
	BEGIN CATCH
		DECLARE @errorMessage NVARCHAR(1000)
		SET @errorMessage = ERROR_MESSAGE()
		PRINT 'Error durante la inserción: ' + @errorMessage;
		THROW;
	END CATCH

	-- Exportar archivo con registros invalidos

	DECLARE @registrosFallidos INT

    SET @registrosFallidos = (SELECT COUNT(*) FROM [#registros_invalidos])

    DECLARE @archivoRegistrosInvalidos NVARCHAR(MAX)
    SET @archivoRegistrosInvalidos = @rutaArchivoError + '\registros-invalidos.csv'

	/*Crear archivo de registros inválidos*/


	DROP TABLE [#pacientes_importados];
    DROP TABLE [#pacientes_importados_formateados];
    DROP TABLE [#registros_invalidos];
END;

-- Importar sedes desde un archivo CSV
GO
CREATE OR ALTER PROCEDURE [archivos].[importarSedesCSV]
	@rutaArchivo NVARCHAR(255),
	@separador NCHAR(4) = ';',
	@rutaArchivoError NVARCHAR(255)
AS
BEGIN
	CREATE TABLE [#sedes_importadas] (
		nombreSede VARCHAR(255),
		calleYNro VARCHAR (255),
		localidad VARCHAR (255),
		provincia VARCHAR (255)
	)

	EXEC [archivos].[importarDatosCSV] @tablaDestino = '[#sedes_importadas]', @rutaArchivo = @rutaArchivo, @delimitadorCampos = @separador

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

		SET @idDireccion = [utils].[obtenerIdDireccion] (@calleYNro, @localidad, @provincia)

		INSERT INTO [datos].[sede_de_atencion] (nombre, direccion) VALUES (@nombreSede, @idDireccion)
	
		DELETE TOP(1) FROM [#sedes_importadas]
		SET @count = @count - 1
	END

	DROP TABLE [#sedes_importadas]
END;