USE [CURESA];
GO


/* ----------------- Procedimientos Almacenados - Pacientes ----------------- */

-- Insertar paciente
CREATE OR ALTER PROCEDURE [data].[insertarPaciente]  
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
    DECLARE @fechaActual DATE = GETDATE()
    DECLARE @idDireccion INT, @idTipoDocumento INT, @idNacionalidad INT, @sexoChar CHAR(1), @idGenero INT

    EXEC [utilities].[obtenerOInsertarIdDireccion] @calleYNro, @localidad, @provincia, @idDireccion OUT
	EXEC [utilities].[obtenerOIsertarIdTipoDocumento] @tipoDocumento, @idTipoDocumento OUT
	EXEC [utilities].[obtenerOInsertarIdNacionalidad] @nacionalidad, @idNacionalidad OUT
	SET @sexoChar = [utilities].[obtenerCharSexo] (@sexo) 
	EXEC [utilities].[obtenerOInsertarIdGenero] @genero, @idGenero OUT

    INSERT INTO [data].[Patients]
        (
            [apellido],
            [apellido_materno],
            [email],
            [fecha_actualizacion],
            [fecha_nacimiento],
            [foto_perfil],
            [id_cobertura],
            [id_direccion],
            [id_genero],
            [id_tipo_documento],
            [nacionalidad],
            [nombre],
            [nro_documento],
            [sexo_biologico],
            [tel_alternativo],
            [tel_fijo],
            [tel_laboral],
            [valido]
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

-- Actualizar paciente
CREATE OR ALTER PROCEDURE [data].[actualizarPaciente]
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
		SET @idGenero = [utilities].[obtenerIdGenero] (@genero)

    IF @nacionalidad IS NOT NULL
        SET @idNacionalidad = [utilities].[obtenerIdNacionalidad] (@nacionalidad)

    UPDATE [data].[Patients] SET
        [id_cobertura] = ISNULL(@cobertura, [id_cobertura]),
        [id_direccion] = ISNULL(@idDireccion, [id_direccion]),
        [id_tipo_documento] = ISNULL(@tipoDocumento, [id_tipo_documento]),
        [nro_documento] = ISNULL(@nroDocumento, [nro_documento]),
        [nombre] = ISNULL(@nombre, [nombre]),
        [apellido] = ISNULL(@apellido, [apellido]),
        [apellido_materno] = ISNULL(@apellidoMaterno, [apellido_materno]),
        [fecha_nacimiento] = ISNULL(@fechaNacimiento, [fecha_nacimiento]),
        [sexo_biologico] = UPPER(ISNULL(@sexoBiologico, [sexo_biologico])), 
        [id_genero] = ISNULL(@idGenero, [id_genero]),
        [nacionalidad] = ISNULL(@idNacionalidad, [nacionalidad]),
		[foto_perfil] = ISNULL(@fotoPerfil, [foto_perfil]),
        [email] = ISNULL(@email, [email]),
        [tel_fijo] = ISNULL(@telefonoFijo, [tel_fijo]),
        [tel_alternativo] = ISNULL(@telefonoAlternativo, [tel_alternativo]),
        [tel_laboral] = ISNULL(@telefonoLaboral, [tel_laboral])
    WHERE
        [id_paciente] = @idPaciente
END;
GO

-- Borrar paciente
CREATE OR ALTER PROCEDURE [data].[borrarPaciente]
    @id INT
AS
    UPDATE [data].[Patients] SET [valido] = 0 WHERE [id_paciente] = @id;
GO

-- Verificar si existe el paciente
GO
CREATE OR ALTER FUNCTION [data].[existePaciente]
    ( 
        @email VARCHAR(255)
    )
    RETURNS INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM [data].[Patients] WHERE [email] = @email)
        RETURN 1
    RETURN 0
END