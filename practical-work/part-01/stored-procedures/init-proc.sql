USE [cure_sa]

-- user.sql --
GO
CREATE OR ALTER PROCEDURE [datos].[actualizarContraseña]
    @idUsuario INT,
    @contraseña VARCHAR(256)
AS
BEGIN
    UPDATE [datos].[usuarios] SET contraseña = @contraseña WHERE id_usuario = @idUsuario;
END;


-- states.util.sql --
GO
CREATE OR ALTER PROCEDURE [referencias].[obtenerOInsertarIdProvincia]
    @Provincia VARCHAR(255),
	@IdProvincia INT OUTPUT
AS
BEGIN
    SET @provincia  = UPPER (@Provincia)
    IF NOT EXISTS (SELECT 1 FROM referencias.nombres_provincias WHERE nombre = @Provincia)
        INSERT INTO referencias.nombres_provincias (nombre) VALUES (@Provincia);

	SELECT @IdProvincia = id_provincia FROM referencias.nombres_provincias WHERE nombre = @Provincia;
END;


GO
CREATE OR ALTER PROCEDURE [referencias].[actualizarProvincias]
    @provincia VARCHAR(50),
    @outIdPais INT OUTPUT,
    @outIdProvincia INT OUTPUT,
    @outNombre VARCHAR(50) OUTPUT
AS
BEGIN
    IF NULLIF(@provincia, '') IS NULL
        RETURN

    IF NOT EXISTS (SELECT 1 FROM [referencias].[nombres_provincias] WHERE nombre = UPPER(@provincia) COLLATE Latin1_General_CS_AS) 
        INSERT INTO [referencias].[nombres_provincias] (nombre) VALUES (UPPER(@provincia))

    SELECT @outIdPais = id_pais, @outIdProvincia = id_provincia, @outNombre = nombre FROM [referencias].[nombres_provincias] WHERE nombre = UPPER(@provincia) COLLATE Latin1_General_CS_AS
    RETURN
END;


-- specialties.sql --
GO
CREATE OR ALTER FUNCTION [datos].[obtenerIdEspecialidad]
    (
        @nombre VARCHAR(50)
    ) RETURNS INT
AS
BEGIN
    DECLARE @id INT = -1
    SET @nombre = UPPER(TRIM(@nombre))

    IF NULLIF(@nombre, '') IS NULL
        RETURN @id

    IF NOT EXISTS (SELECT 1 FROM [datos].[especialidad] WHERE UPPER(TRIM(nombre)) = @nombre COLLATE Latin1_General_CS_AS) 
        RETURN @id

    SELECT @id = id_especialidad FROM [datos].[especialidad] WHERE UPPER(TRIM(nombre)) = @nombre
    RETURN @id
END;

GO
CREATE OR ALTER PROCEDURE [datos].[guardarEspecialidad]
    @nombre VARCHAR(50) = 'null',
    @outIdEspecialidad INT OUTPUT
AS
BEGIN
    IF NULLIF(@nombre, '') IS NULL
            RETURN
        SET @nombre = UPPER(@nombre);
        IF NOT EXISTS (SELECT 1 FROM [datos].[especialidad] WHERE nombre = @nombre COLLATE Latin1_General_CS_AS) 
            INSERT INTO [datos].[especialidad] (nombre) VALUES (@nombre)

        SELECT @outIdEspecialidad = id_especialidad FROM [datos].[especialidad] WHERE nombre = @nombre COLLATE Latin1_General_CS_AS
        RETURN
END;


-- reserve-medical-appointment.sql --
GO
CREATE OR ALTER PROCEDURE [datos].[registrarTurnoMedico]
    @idPaciente INT,
    @fecha DATE,
    @hora TIME,
    @nombreMedico VARCHAR(255),
    @apellidoMedico VARCHAR(255),
    @especialidad VARCHAR(255) = NULL,
    @nombreSede VARCHAR(255),
    @tipoTurno VARCHAR(255),
    @idTurno INT = NULL OUTPUT
AS
BEGIN
	DECLARE @horaTurnoAnterior TIME = NULL
	DECLARE @idDiasXSede INT
	DECLARE @idDireccionAtencion INT
	DECLARE @idEspecialidad INT
	DECLARE @idMedico INT
	DECLARE @idSede INT
	DECLARE @idTipoTurno INT
	DECLARE @idTurnoPendiente INT = 1;

	IF UPPER(@tipoTurno) = 'PRESENCIAL' SET @idTipoTurno = 1
	ELSE IF UPPER(@tipoTurno) = 'VIRTUAL' SET @idTipoTurno = 2
	ELSE return

	SELECT
        [m].[id_medico], 
		[m].[id_especialidad], 
	    [s].[id_sede], 
		[s].[direccion],
		[dxs].[id_dias_x_sede],
		[t].[hora] as [horaTurno],
		[t].[id_tipo_turno] AS [idTipoTurno],
		[t].[id_estado_turno] as [idEstadoTurno]
    INTO [#disponibilidad]
    FROM [datos].[dias_x_sede] AS [dxs]
	JOIN [datos].[medicos] AS [m] ON [m].[id_medico] = [dxs].[id_medico]
    JOIN [datos].[sede_de_atencion] AS [s] ON [s].[id_sede] = [dxs].[id_sede]
    LEFT JOIN [datos].[reservas_turnos_medicos] AS [t] ON [dxs].[id_dias_x_sede] = [t].[id_dias_x_sede]
    WHERE
        [m].[nombre] = @nombreMedico AND
        [m].[apellido] = @apellidoMedico AND
        [s].[nombre] = @nombreSede AND
        [dxs].[dia] = @fecha AND
        [dxs].[hora_inicio] < @hora AND
        [dxs].[hora_fin] > DATEADD(MINUTE, 15, @hora)
	
	IF @@ROWCOUNT > 0
	BEGIN
		IF EXISTS (SELECT 1 FROM [#disponibilidad] WHERE horaTurno IS NOT NULL AND idTipoTurno = @idTipoTurno AND idEstadoTurno = 1)
			SELECT @horaTurnoAnterior = max(horaTurno) 
			FROM [#disponibilidad] 
			WHERE horaTurno < @hora AND idTipoTurno = @idTipoTurno AND idEstadoTurno = @idTurnoPendiente

		IF @horaTurnoAnterior IS NULL OR DATEADD(MINUTE, 15, @horaTurnoAnterior) <= @hora
		BEGIN
			SELECT TOP 1 @idMedico = id_medico, 
				@idSede = id_sede, 
				@idEspecialidad = id_especialidad, 
				@idDireccionAtencion = direccion,
				@idDiasXSede = id_dias_x_sede
			FROM [#disponibilidad]

			INSERT INTO [datos].[reservas_turnos_medicos] (
                fecha,
                hora,
                id_medico,
                id_especialidad,
                id_direccion_atencion,
                id_paciente,
                id_dias_x_sede,
                id_tipo_turno,
                id_estado_turno
            ) VALUES (
                @fecha,
                @hora,
                @idMedico,
                @idEspecialidad,
                @idDireccionAtencion,
                @idPaciente,
                @idDiasXSede,
                @idTipoTurno,
                @idTurnoPendiente
            )
		END
		ELSE
			PRINT '- No se pudo registrar el turno ( sin disponibilidad )';
	END

	DROP TABLE [#disponibilidad]
END;

GO
CREATE OR ALTER PROCEDURE [datos].[actualizarTurnoMedico]
    @idTurno INT,
    @estado VARCHAR(255)
AS
BEGIN
    DECLARE @idEstado INT = NULL

    IF @estado = 'CANCELADO'
		RETURN

    SELECT @idEstado = id_estado 
	FROM [datos].[estados_turnos] 
	WHERE nombre = @estado

    IF @idEstado IS NOT NULL
        UPDATE [datos].[reservas_turnos_medicos] 
		SET id_estado_turno = @idEstado 
		WHERE id_turno = @idTurno
END;

GO
CREATE OR ALTER PROCEDURE [datos].[cancelarTurnoMedico]
    @idTurno INT
AS
BEGIN
    DECLARE @idEstado INT

    SELECT @idEstado = id_estado 
	FROM [datos].[estados_turnos] 
	WHERE nombre = 'CANCELADO';

    UPDATE [datos].[reservas_turnos_medicos] 
	SET id_estado_turno = @idEstado 
	WHERE id_turno = @idTurno;
END;

-- register-medical-study.sql.sql --
GO
CREATE OR ALTER PROCEDURE [datos].[registrarEstudiosValidosDesdeJSON]
    @rutaArchivo NVARCHAR(MAX)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @json NVARCHAR(MAX);
    DECLARE @paramDef NVARCHAR(100);
    
    SET @sql = N'
        SET @json_string = (SELECT * FROM OPENROWSET (BULK ''' + @rutaArchivo + ''', SINGLE_CLOB) as JsonFile)
    '
    SET @paramDef = N'
        @json_string NVARCHAR(MAX) OUTPUT';  
    
    EXEC sp_executesql @sql, @paramDef, @json_string = @json OUTPUT;

    SELECT * INTO #EstudiosMedicos FROM
    OPENJSON(@json) 
    WITH (
        [id] NVARCHAR(255) '$._id."$oid"',
        [area] NVARCHAR(255) '$.Area',
        [estudio] NVARCHAR(255) '$.Estudio',
        [prestador] NVARCHAR(255) '$.Prestador',
        [plan] NVARCHAR(255) '$.Plan',
        [porcentajeCobertura] INT '$."Porcentaje Cobertura"',
        [costo] DECIMAL(18, 2) '$.Costo',
        [requiereAutorizacion] BIT '$."Requiere autorizacion"'
    )

    BEGIN TRY
        INSERT INTO [datos].[estudiosValidos]
        SELECT  
            em.id,
            em.area,
            em.estudio,
            p.id_prestador,
            em.[plan],
            em.porcentajeCobertura,
            em.costo,
            em.requiereAutorizacion
        FROM #EstudiosMedicos em
        INNER JOIN [datos].[prestadores] p ON em.prestador = p.nombre COLLATE Latin1_General_CS_AS
        WHERE 
            em.area IS NOT NULL AND
            em.estudio IS NOT NULL AND
            em.prestador IS NOT NULL AND
            em.[plan] IS NOT NULL AND p.plan_prestador = em.[plan] COLLATE Latin1_General_CS_AS AND
            em.porcentajeCobertura IS NOT NULL AND
            em.costo IS NOT NULL 

        DROP TABLE #EstudiosMedicos;
    END TRY
    BEGIN CATCH
        DECLARE @errorMessage NVARCHAR(1000)
		SET @errorMessage = ERROR_MESSAGE()
		PRINT 'Error durante la inserción: ' + @errorMessage;
        THROW;
    END CATCH
END;



-- patient.sql --
GO
CREATE OR ALTER PROCEDURE [datos].[insertarPaciente]  
	@nombre VARCHAR(255), 
    @apellido VARCHAR(255), 
    @fechaNacimiento DATE,
	@tipoDocumento VARCHAR(20), 
    @nroDocumento INT,
    @sexo VARCHAR(20), 
    @genero VARCHAR(20),
	@telefono VARCHAR(40), 
    @nacionalidad VARCHAR(50), 
    @email VARCHAR(40), 
	@calleYNro VARCHAR(255), 
    @localidad VARCHAR(255), 
    @provincia VARCHAR(255),
    @apellidoMaterno VARCHAR (50) = NULL,
    @fotoPerfil VARCHAR(128) = NULL,
    @telAlternativo VARCHAR(20) = NULL,
    @telLaboral VARCHAR(20) = NULL,
    @idCobertura INT = NULL
AS
BEGIN
    DECLARE @fechaActual DATE = GETDATE();
    DECLARE @idDireccion INT, @idTipoDocumento INT, @idNacionalidad INT, @sexoChar CHAR(1), @idGenero INT;

    EXEC [referencias].[obtenerOInsertarIdDireccion] @calleYNro, @localidad, @provincia, @idDireccion OUT;
	EXEC [referencias].[obtenerOIsertarIdTipoDocumento] @tipoDocumento, @idTipoDocumento OUT;
	EXEC [referencias].[obtenerOInsertarIdNacionalidad] @nacionalidad, @idNacionalidad OUT;
	SET @sexoChar = [utils].[obtenerCharSexo](@sexo); 
	EXEC [referencias].[obtenerOInsertarIdGenero] @genero, @idGenero OUT;

    INSERT INTO [datos].[pacientes]
        (
            apellido,
            apellido_materno,
            email,
            fecha_actualizacion,
            fecha_nacimiento,
            foto_perfil,
            id_cobertura,
            id_direccion,
            id_genero,
            id_tipo_documento,
            nacionalidad,
            nombre,
            nro_documento,
            sexo_biologico,
            tel_alternativo,
            tel_fijo,
            tel_laboral,
            valido
        ) VALUES (
            @apellido,
            @apellidoMaterno,
            @email,
            @fechaActual,
            @fechaNacimiento,
            @fotoPerfil,
            @idCobertura,
            @idDireccion,
            @idGenero,
            @idTipoDocumento,
            @idNacionalidad,
            @nombre,
            @nroDocumento,
            @sexoChar,
            @telAlternativo,
            @telefono,
            @telLaboral,
            1
	)
END;

GO
CREATE OR ALTER PROCEDURE [datos].[actualizarPaciente]
    @idPaciente INT,
    @cobertura INT = NULL,
    @idDireccion INT = NULL,
    @tipoDocumento INT = NULL,
    @nroDocumento VARCHAR(50) = NULL,
    @nombre VARCHAR(30) = NULL,
    @apellido VARCHAR(50) = NULL,
    @apellidoMaterno VARCHAR(30) = NULL,
    @fechaNacimiento DATE = NULL,
    @sexoBiologico CHAR(1) = NULL,
    @genero VARCHAR(255) = NULL,
    @nacionalidad VARCHAR(255) = NULL,
    @fotoPerfil VARCHAR(128) = NULL,
    @email VARCHAR(70) = NULL,
    @telefonoFijo VARCHAR(20) = NULL,
    @telefonoAlternativo VARCHAR(20) = NULL,
    @telefonoLaboral VARCHAR(20) = NULL
AS
BEGIN
    DECLARE @idGenero INT = NULL
    DECLARE @idNacionalidad INT = NULL

    IF @genero IS NOT NULL 
		SET @idGenero = [referencias].[obtenerIdGenero](@genero)

    IF @nacionalidad IS NOT NULL
        SET @idNacionalidad = [referencias].[obtenerIdNacionalidad](@nacionalidad)

    UPDATE datos.pacientes SET
        id_cobertura = ISNULL(@cobertura, id_cobertura),
        id_direccion = ISNULL(@idDireccion, id_direccion),
        id_tipo_documento = ISNULL(@tipoDocumento, id_tipo_documento),
        nro_documento = ISNULL(@nroDocumento, nro_documento),
        nombre = ISNULL(@nombre, nombre),
        apellido = ISNULL(@apellido, apellido),
        apellido_materno = ISNULL(@apellidoMaterno, apellido_materno),
        fecha_nacimiento = ISNULL(@fechaNacimiento, fecha_nacimiento),
        sexo_biologico = UPPER(ISNULL(@sexoBiologico, sexo_biologico)), 
        id_genero = ISNULL(@idGenero, id_genero),
        nacionalidad = ISNULL(@idNacionalidad, nacionalidad),
		foto_perfil = ISNULL(@fotoPerfil, foto_perfil),
        email = ISNULL(@email, email),
        tel_fijo = ISNULL(@telefonoFijo, tel_fijo),
        tel_alternativo = ISNULL(@telefonoAlternativo, tel_alternativo),
        tel_laboral = ISNULL(@telefonoLaboral, tel_laboral)
    WHERE
        id_paciente = @idPaciente
END;

GO
CREATE OR ALTER PROCEDURE [datos].[borrarPaciente]
    @id INT
AS
    UPDATE [datos].[pacientes] SET valido = 0 WHERE id_paciente = @id;

GO
CREATE OR ALTER FUNCTION [datos].[existePacientePorEmail]
    ( 
        @email VARCHAR(255)
    )
    RETURNS INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM [datos].[pacientes] WHERE email = @email)
        RETURN 1;
    RETURN 0;
END

-- others.util.sql --
GO
CREATE OR ALTER FUNCTION [utils].[obtenerCharSexo]
    (
        @sexo VARCHAR(25)
    ) RETURNS CHAR
AS
BEGIN
    DECLARE @char CHAR;
    SET @char = 'N';

    IF UPPER(TRIM(@sexo)) = 'MASCULINO'
        SET @char = 'M';
    ELSE IF UPPER(TRIM(@sexo)) = 'FEMENINO'
        SET @char = 'F';
    
    RETURN @char
END;

-- medical-study.sql --
GO
CREATE OR ALTER PROCEDURE [datos].[registrarEstudio]
    @nombre_estudio VARCHAR(60),
    @id_paciente INT,
    @autorizado BIT = 1,
    @documento_resultado VARCHAR(128) = NULL,
    @fecha DATE,
    @imagen_resultado VARCHAR(128) = NULL
AS
BEGIN
    BEGIN TRY
        INSERT INTO [datos].[estudios] (nombre_estudio, id_paciente, autorizado, documento_resultado, fecha, imagen_resultado)
        VALUES (@nombre_estudio, @id_paciente, @autorizado, @documento_resultado, @fecha, @imagen_resultado);
    END TRY
    BEGIN CATCH
        -- Manejo de errores
        DECLARE @errorMessage NVARCHAR(1000);
        SET @errorMessage = ERROR_MESSAGE();
        PRINT 'Error durante la inserción: ' + @errorMessage;
        THROW;
    END CATCH
END;

GO
CREATE OR ALTER PROCEDURE [datos].[actualizarEstudio]
    @id_estudio INT,
    @nombre_estudio VARCHAR(60),
    @id_paciente INT,
    @autorizado BIT = 1,
    @documento_resultado VARCHAR(128) = NULL,
    @fecha DATE,
    @imagen_resultado VARCHAR(128) = NULL
AS
BEGIN
    BEGIN TRY
        UPDATE [datos].[estudios]
        SET nombre_estudio = @nombre_estudio,
            id_paciente = @id_paciente,
            autorizado = @autorizado,
            documento_resultado = @documento_resultado,
            fecha = @fecha,
            imagen_resultado = @imagen_resultado
        WHERE id_estudio = @id_estudio;
    END TRY
    BEGIN CATCH
        -- Manejo de errores
        DECLARE @errorMessage NVARCHAR(1000);
        SET @errorMessage = ERROR_MESSAGE();
        PRINT 'Error durante la actualización: ' + @errorMessage;
        THROW;
    END CATCH
END;

GO
CREATE OR ALTER PROCEDURE [datos].[eliminarEstudio]
    @id_estudio INT
AS
BEGIN
    BEGIN TRY
        UPDATE [datos].[estudios]
        SET autorizado = 0
        WHERE id_estudio = @id_estudio;
    END TRY
    BEGIN CATCH
        -- Manejo de errores
        DECLARE @errorMessage NVARCHAR(1000);
        SET @errorMessage = ERROR_MESSAGE();
        PRINT 'Error durante la eliminación lógica: ' + @errorMessage;
        THROW;
    END CATCH
END;


-- medic.sql --
GO
CREATE OR ALTER PROCEDURE [datos].[insertarMedico]
    @nombre VARCHAR(50),
    @apellido VARCHAR(50),
    @especialidad VARCHAR(50),
    @matricula INT
AS
BEGIN
    DECLARE @idEspecialidad INT

    SET @idEspecialidad = [datos].[obtenerIdEspecialidad](@especialidad)

    INSERT INTO [datos].[medicos]
        (nombre, apellido, nro_matricula, id_especialidad)
    VALUES
        (@nombre, @apellido, @matricula, @idEspecialidad)
END;

GO
CREATE OR ALTER PROCEDURE [datos].[eliminarMedico]
    @id INT
AS
    UPDATE [datos].[medicos] SET alta = 0 WHERE id_medico = @id;


-- imports.util.sql --
GO
CREATE OR ALTER PROCEDURE [archivos].[importarDatosCSV]
    @tablaDestino VARCHAR(255),
    @delimitadorCampos VARCHAR(4) = ';',
    @delimitadorFilas VARCHAR(4) = '\n',
    @rutaArchivo VARCHAR(255)
AS
BEGIN
    PRINT 'Iniciando la importación del archivo CSV...';
    
    DECLARE @Error NVARCHAR(MAX);
    
    IF LEN(@tablaDestino) = 0
    BEGIN
        SET @Error = 'El nombre de la tabla de destino no puede estar vacío.';
        THROW 51000, @Error, 1;
        RETURN;
    END
    
    IF LEN(@rutaArchivo) = 0
    BEGIN
        SET @Error = 'La ruta del archivo CSV no puede estar vacía.';
        THROW 51001, @Error, 1;
        RETURN;
    END
    
    IF NOT EXISTS (SELECT 1 FROM sys.dm_os_file_exists(@rutaArchivo))
    BEGIN
        SET @Error = 'El archivo ' + @rutaArchivo + ' no existe.';
        THROW 51002, @Error, 1;
        RETURN;
    END
    
    DECLARE @SQL NVARCHAR(MAX)
    SET @SQL = N'
        BEGIN TRY
            BULK INSERT ' + QUOTENAME(@tablaDestino) + '
            FROM ''' + @rutaArchivo + '''
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ''' + @delimitadorCampos + ''',
                ROWTERMINATOR = ''' + @delimitadorFilas + ''', 
                CODEPAGE = ''65001''
            );
        END TRY
        BEGIN CATCH
            DECLARE @err NVARCHAR(255);
            SET @err = ''Error durante la carga de datos: '' + ERROR_MESSAGE();
            THROW 51003, @err, 1;
        END CATCH'

    EXEC sp_executesql @SQL
    
    PRINT 'Se ha finalizado correctamente.';
END;


-- genders.util.sql --
GO
CREATE OR ALTER PROCEDURE [referencias].[obtenerOInsertarIdGenero]
    @nombre VARCHAR(50) = 'null',
    @id INT OUTPUT 
AS
BEGIN
    SET @nombre = UPPER(TRIM(@nombre));

    IF NULLIF(@nombre, '') IS NULL
        SET @id = -1;
    ELSE
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM [referencias].[generos] WHERE UPPER(TRIM(nombre)) = @nombre COLLATE Latin1_General_CS_AS) 
            INSERT INTO [referencias].[generos] (nombre) VALUES (@nombre);

        SELECT @id = id_genero FROM [referencias].[generos] WHERE UPPER(TRIM(nombre)) = @nombre;
    END
END;

GO
CREATE OR ALTER PROCEDURE [referencias].[actualizarGenero]
    @nombre VARCHAR(50) = 'null',
    @outIdGenero INT OUTPUT,
    @outNombre VARCHAR(50) OUTPUT
AS
BEGIN
    IF NULLIF(@nombre, '') IS NULL
        RETURN
        
    IF NOT EXISTS (SELECT 1 FROM [referencias].[generos] WHERE nombre = @nombre COLLATE Latin1_General_CS_AS) 
        INSERT INTO [referencias].[generos] (nombre) VALUES (@nombre)
    ELSE
        UPDATE [referencias].[generos] SET nombre = @nombre WHERE nombre = @nombre COLLATE Latin1_General_CS_AS

    SELECT @outIdGenero = id_genero, @outNombre = nombre FROM [referencias].[generos] WHERE nombre = @nombre COLLATE Latin1_General_CS_AS;
END;


-- export-medical-appointments-attended.sql --
GO
CREATE OR ALTER PROCEDURE [archivos].[exportarTurnosAtendidosXML]
    @obraSocial VARCHAR(50),
	@fechaInicio DATE,
	@fechaFin DATE,
	@rutaArchivoXML NVARCHAR(MAX)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM datos.prestadores pr WHERE pr.nombre = @obraSocial)
		RETURN;

	DECLARE @sql NVARCHAR(MAX);

	SET @sql = N'
		SELECT
			p.apellido AS "Paciente/Apellido",
			p.nombre AS "Paciente/Nombre",
			p.id_tipo_documento AS "Paciente/TipoDocumento",
			p.nro_documento AS "Paciente/NumeroDocumento",
			m.apellido AS "Profesional/Apellido",
			m.nombre AS "Profesional/Nombre",
			m.nro_matricula AS "Profesional/Matricula",
			t.fecha AS "Fecha",
			t.hora AS "Hora",
			e.nombre AS "Especialidad"
		FROM
			datos.reservas_turnos_medicos t
		INNER JOIN
			datos.medicos m ON t.id_medico = m.id_medico
		INNER JOIN
			datos.especialidad e ON t.id_especialidad = e.id_especialidad
		INNER JOIN
			datos.pacientes p ON t.id_paciente = p.id_paciente
		INNER JOIN
			datos.coberturas c ON p.id_cobertura = c.id_cobertura
		INNER JOIN
			datos.prestadores pr ON c.id_prestador = pr.id_prestador
		WHERE
			pr.nombre = @obraSocial AND
			t.fecha BETWEEN @fechaInicio AND @fechaFin
		FOR XML PATH("Turno"), ROOT("Turnos")
	';

	SET @sql = N'bcp "' + @sql + '" queryout "' + @rutaArchivoXML + '" -c -T -S ' + @@SERVERNAME;

	EXEC sp_configure 'show advanced options', 1;
	RECONFIGURE;

	EXEC sp_configure 'xp_cmdshell', 1;
	RECONFIGURE;

	EXEC xp_cmdshell @sql;
	
	EXEC sp_configure 'xp_cmdshell', 0;
	RECONFIGURE;
END


-- document-type.sql --
GO
CREATE OR ALTER PROCEDURE [referencias].[obtenerOIsertarIdTipoDocumento]
    @nombre VARCHAR(50),
    @idTipo INT OUTPUT
AS
BEGIN
    SET @nombre = UPPER(TRIM(@nombre));

    IF NULLIF(@nombre, '') IS NULL
        SET @idTipo = -1;
    ELSE 
    BEGIN

        IF NOT EXISTS (SELECT 1 FROM [referencias].[tipos_documentos] WHERE nombre = @nombre COLLATE Latin1_General_CS_AS) 
            INSERT INTO [referencias].[tipos_documentos] (nombre) VALUES (@nombre);
       
        SELECT @idTipo = id_tipo_documento FROM [referencias].[tipos_documentos] WHERE nombre = @nombre COLLATE Latin1_General_CS_AS;
 
    END
END;

GO
CREATE OR ALTER PROCEDURE [referencias].[insertarTipoDocumento]
    @nombre VARCHAR(50) = 'null',
    @outIdTipoDocumento INT OUTPUT,
    @outNombre VARCHAR(50) OUTPUT
AS
BEGIN
    IF NULLIF(@nombre, '') IS NULL
        RETURN
        
    IF NOT EXISTS (SELECT 1 FROM [referencias].[tipos_documentos] WHERE nombre = @nombre COLLATE Latin1_General_CS_AS) 
        INSERT INTO [referencias].[tipos_documentos] (nombre) VALUES (@nombre)
    ELSE
        UPDATE [referencias].[tipos_documentos] SET nombre = @nombre WHERE nombre = @nombre COLLATE Latin1_General_CS_AS

    SELECT @outIdTipoDocumento = id_tipo_documento, @outNombre = nombre FROM [referencias].[tipos_documentos] WHERE nombre = @nombre COLLATE Latin1_General_CS_AS
    RETURN
END;


-- districts.util.sql --
GO
CREATE OR ALTER PROCEDURE [referencias].[obtenerOInsertarIdLocalidad]
    @Localidad VARCHAR(255),
	@IdProvincia INT,
	@IdLocalididad INT OUTPUT
AS
BEGIN
    SET @Localidad = UPPER(@Localidad);
    IF NOT EXISTS (SELECT 1 FROM referencias.nombres_localidades WHERE id_provincia = @IdProvincia AND nombre = @Localidad)
        INSERT INTO referencias.nombres_localidades (nombre,id_provincia) VALUES (@Localidad,@IdProvincia);

	SELECT @IdLocalididad = id_localidad FROM referencias.nombres_localidades WHERE id_provincia = @IdProvincia AND nombre = @Localidad;
END;

GO
CREATE OR ALTER PROCEDURE [referencias].[insertarLocalidad]
    @localidad VARCHAR(50) = 'null',
    @outIdLocalidad INT OUTPUT,
    @outNombre VARCHAR(50) OUTPUT
AS
BEGIN
    IF NULLIF(@localidad, 'null') IS NULL
        RETURN
        
    IF NOT EXISTS (SELECT 1 FROM [referencias].[nombres_localidades] WHERE nombre = @localidad COLLATE Latin1_General_CS_AS) 
        INSERT INTO [referencias].[nombres_localidades] (nombre) VALUES (@localidad)
    ELSE
        UPDATE [referencias].[nombres_localidades] SET nombre = @localidad WHERE nombre = @localidad COLLATE Latin1_General_CS_AS

    SELECT @outIdLocalidad = id_localidad, @outNombre = nombre FROM [referencias].[nombres_localidades] WHERE nombre = @localidad COLLATE Latin1_General_CS_AS
    RETURN
END;


-- countries.util.sql --
GO
CREATE OR ALTER PROCEDURE [referencias].[obtenerOInsertarIdNacionalidad]
    @nacionalidad VARCHAR(50) = NULL,
    @id INT OUTPUT
AS
BEGIN
    SET @nacionalidad = UPPER(TRIM(@nacionalidad));

    IF NULLIF(@nacionalidad, '') IS NULL
        SET @id = -1;
    ELSE
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM [referencias].[nacionalidades] WHERE UPPER(TRIM(nombre)) = @nacionalidad COLLATE Latin1_General_CS_AS) 
            INSERT INTO [referencias].[nacionalidades] (nombre) VALUES (@nacionalidad);

        SELECT @id = id_nacionalidad FROM [referencias].[nacionalidades] WHERE UPPER(TRIM(nombre)) = @nacionalidad;
    END
END;

GO
CREATE OR ALTER PROCEDURE [referencias].[actualizarNacionalidad]
    @pais VARCHAR(50) = NULL,
    @nacionalidad VARCHAR(50) = NULL,
    @outGentilicio VARCHAR(50) OUTPUT,
    @outIdpais INT OUTPUT,
    @outNombre VARCHAR(50) OUTPUT
AS
BEGIN
    IF NULLIF(@nacionalidad, '') IS NULL
        RETURN

    IF NOT EXISTS (SELECT 1 FROM [referencias].[paises] WHERE gentilicio = @nacionalidad COLLATE Latin1_General_CS_AS) 
        IF NULLIF(@pais, '') IS NULL
            RETURN
        ELSE
            INSERT INTO [referencias].[paises] (nombre, gentilicio) VALUES (@pais, @nacionalidad)
    ELSE
        UPDATE [referencias].[paises] SET gentilicio = @nacionalidad WHERE gentilicio = @nacionalidad COLLATE Latin1_General_CS_AS

    SELECT @outGentilicio = gentilicio, @outIdpais = id_pais, @outNombre = nombre FROM [referencias].[paises] WHERE gentilicio = @nacionalidad COLLATE Latin1_General_CS_AS
    RETURN
END;


-- addressess.util.sql --
GO
CREATE OR ALTER PROCEDURE [referencias].[obtenerOInsertarIdDireccion]
    @calleYNro VARCHAR(50),
    @localidad VARCHAR(255),
    @provincia VARCHAR(255),
    @idDireccion INT OUTPUT
AS
BEGIN
    DECLARE @idProvincia INT;
    DECLARE @idLocalidad INT;

	EXEC referencias.obtenerOInsertarIdProvincia @Provincia, @IdProvincia OUTPUT;
	EXEC referencias.obtenerOInsertarIdLocalidad @Localidad,@IdProvincia, @IdLocalidad OUTPUT;

	IF NOT EXISTS (SELECT 1 FROM referencias.direcciones 
					WHERE calle_y_nro = @calleYNro
                    AND id_localidad = @IdLocalidad 
                    AND id_provincia = @IdProvincia)

        INSERT INTO referencias.direcciones (calle_y_nro,id_localidad,id_provincia) 
		VALUES (@calleYNro,@IdLocalidad,@IdProvincia);

	SELECT @idDireccion = id_direccion FROM referencias.direcciones 
	WHERE calle_y_nro = @calleYNro AND id_localidad = @IdLocalidad AND id_provincia = @IdProvincia;
END;

GO
CREATE OR ALTER PROCEDURE [referencias].[actualizarDireccion]
    @calleYNro VARCHAR(50),
    @codPostal SMALLINT = NULL,
    @departamento SMALLINT = NULL,
    @idDireccion INT = NULL,
    @idLocalidad INT,
    @idPais INT = NULL,
    @idProvincia INT,
    @piso SMALLINT = NULL,
    @outCalle VARCHAR(50),
    @outCodPostal SMALLINT OUTPUT,
    @outDepartamento SMALLINT OUTPUT,
    @outIdDireccion INT OUTPUT,
    @outIdLocalidad INT OUTPUT,
    @outIdPais INT OUTPUT,
    @outIdProvincia INT OUTPUT,
    @outNumero INT OUTPUT,
    @outPiso SMALLINT OUTPUT
AS
BEGIN
    IF NULLIF(@calleYNro, '') IS NULL OR @idLocalidad IS NULL OR @idProvincia IS NULL
        RETURN

    IF NOT EXISTS (SELECT 1 FROM [referencias].[direcciones] WHERE calle_y_nro = @calleYNro AND id_localidad = @idLocalidad AND id_provincia = @idProvincia)
        INSERT INTO [referencias].[direcciones] (
            calle_y_nro,
            cod_postal,
            departamento,
            id_direccion,
            id_localidad,
            id_pais,
            id_provincia,
            piso
        ) VALUES (
            @calleYNro,
            @codPostal,
            @departamento,
            @idDireccion,
            @idLocalidad,
            @idPais,
            @idProvincia,
            @piso
        )
    ELSE
        UPDATE [referencias].[direcciones] SET
            calle_y_nro = @calleYNro,
            cod_postal = @codPostal,
            departamento = @departamento,
            id_localidad = @idLocalidad,
            id_pais = @idPais,
            id_provincia = @idProvincia,
            piso = @piso
        WHERE
            calle_y_nro = @calleYNro COLLATE Latin1_General_CS_AS AND
            id_localidad = @idLocalidad AND
            id_provincia = @idProvincia

    SELECT
        @calleYNro = calle_y_nro,
        @codPostal = cod_postal,
        @departamento = departamento,
        @idDireccion = id_direccion,
        @idLocalidad = id_localidad,
        @idPais = id_pais,
        @idProvincia = id_provincia,
        @piso = piso
    FROM [referencias].[direcciones]
    WHERE
        calle_y_nro = @calleYNro COLLATE Latin1_General_CS_AS AND
        id_localidad = @idLocalidad AND
        id_provincia = @idProvincia
    RETURN
END;

-- import-csv.sql --
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
		email VARCHAR(100),
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
		email VARCHAR(100),
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
		email VARCHAR(100),
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
		email,
		calleYNro,
		localidad,
		provincia
	FROM [#pacientes_importados]

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
		email,
		calleYNro,
		localidad,
		provincia	
	HAVING COUNT(*) > 1

	INSERT INTO [#registros_invalidos] SELECT *, 'Documento no numérico' FROM [#pacientes_importados_formateados]
        WHERE ISNUMERIC(NroDocumento) = 0

    INSERT INTO [#registros_invalidos] SELECT *, 'Mayor a 120 años' FROM [#pacientes_importados_formateados]
        WHERE DATEDIFF(YEAR, fechaNacimiento, GETDATE()) NOT BETWEEN 0 AND 120

    INSERT INTO [#registros_invalidos] SELECT *, 'Mail inválido' FROM [#pacientes_importados_formateados]
	    WHERE email NOT LIKE '%_@_%.%'

	INSERT INTO #registros_invalidos 
	SELECT *, 'Mail repetido' FROM #pacientes_importados_formateados AS pif
	WHERE EXISTS (
		SELECT 1 FROM #pacientes_importados_formateados
		WHERE email = pif.email
		HAVING COUNT(nroDocumento) > 1
	)
	AND nroDocumento NOT IN (
		SELECT MAX(nroDocumento) FROM #pacientes_importados_formateados
		WHERE email = pif.email
		GROUP BY email
		HAVING COUNT(nroDocumento) > 1
	);

	DELETE FROM #pacientes_importados_formateados
	WHERE EXISTS (
    SELECT 1
    FROM #registros_invalidos ri
    WHERE 
        ri.tipoDocumento = #pacientes_importados_formateados.tipoDocumento AND
        ri.nroDocumento = #pacientes_importados_formateados.nroDocumento 
	);

	
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
				@email = email,
				@calleYNro = calleYNro,
				@localidad = localidad,
				@provincia = provincia
			FROM [#pacientes_importados_formateados];

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
