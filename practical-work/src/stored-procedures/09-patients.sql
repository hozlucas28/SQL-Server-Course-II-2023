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
	EXEC [utilities].[getOrInsertNationalityId] @nacionalidad, @idNacionalidad OUT
	SET @sexoChar = [utilities].[obtenerCharSexo] (@sexo) 
	EXEC [utilities].[obtenerOInsertarIdGenero] @genero, @idGenero OUT

    INSERT INTO [data].[Patients]
        (
            [lastName],
            [maternalLastName],
            [email],
            [updateDate],
            [birthdate],
            [photo],
            [coverageId],
            [addressId],
            [genderId],
            [documentId],
            [nationalityId],
            [name],
            [documentNumber],
            [biologicalSex],
            [alternativePhone],
            [phone],
            [profesionalPhone],
            [valid]
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
        [coverageId] = ISNULL(@cobertura, [coverageId]),
        [addressId] = ISNULL(@idDireccion, [addressId]),
        [documentId] = ISNULL(@tipoDocumento, [documentId]),
        [documentNumber] = ISNULL(@nroDocumento, [documentNumber]),
        [name] = ISNULL(@nombre, [name]),
        [lastName] = ISNULL(@apellido, [lastName]),
        [maternalLastName] = ISNULL(@apellidoMaterno, [maternalLastName]),
        [birthdate] = ISNULL(@fechaNacimiento, [birthdate]),
        [biologicalSex] = UPPER(ISNULL(@sexoBiologico, [biologicalSex])), 
        [genderId] = ISNULL(@idGenero, [genderId]),
        [nationalityId] = ISNULL(@idNacionalidad, [nationalityId]),
		[photo] = ISNULL(@fotoPerfil, [photo]),
        [email] = ISNULL(@email, [email]),
        [phone] = ISNULL(@telefonoFijo, [phone]),
        [alternativePhone] = ISNULL(@telefonoAlternativo, [alternativePhone]),
        [profesionalPhone] = ISNULL(@telefonoLaboral, [profesionalPhone])
    WHERE
        [id] = @idPaciente
END;
GO

-- Borrar paciente
CREATE OR ALTER PROCEDURE [data].[borrarPaciente]
    @id INT
AS
    UPDATE [data].[Patients] SET [valid] = 0 WHERE [id] = @id;
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