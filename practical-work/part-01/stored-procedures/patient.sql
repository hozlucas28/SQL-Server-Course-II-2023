GO
USE [cure_sa];

-- Insertar paciente
GO
CREATE OR ALTER PROCEDURE [datos].[insertarPaciente]
    @apellido VARCHAR (50),
    @apellidoMaterno VARCHAR (50) = NULL,
    @email VARCHAR (70),
    @fechaNacimiento DATE,
    @fotoPerfil VARCHAR(128) = NULL,
    @idCobertura INT,
    @idDireccion INT,
    @idGenero INT,
    @idTipoDocumento INT,
    @nacionalidad INT,
    @nombre VARCHAR (50),
    @nroDocumento VARCHAR(50),
    @sexoBiologico CHAR(1),
    @telFijo VARCHAR(20),
    @telAlternativo VARCHAR(20) = NULL,
    @telLaboral VARCHAR(20) = NULL
AS
BEGIN
    DECLARE @fechaActual DATE = GETDATE();

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
            tel_laboral
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
            @nacionalidad,
            @nombre,
            @nroDocumento,
            @sexoBiologico,
            @telAlternativo,
            @telFijo,
            @telLaboral
	)
END;

-- Actualizar paciente
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

-- Borrar paciente
GO
CREATE PROCEDURE [datos].[borrarPaciente]
    @id INT
AS
    UPDATE [datos].[pacientes] SET valido = 0 WHERE id_paciente = @id;

-- existe paciente por mail
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