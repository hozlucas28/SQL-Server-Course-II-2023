GO
USE [cure_sa];

-- Insertar/Actualizar paciente
GO
CREATE OR ALTER PROCEDURE [datos].[actualizarPaciente]
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
    @telAlternativo VARCHAR(20) = NULL,
    @telFijo VARCHAR(20),
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
END

-- GO
-- EXECUTE [datos].[actualizarPaciente]
--     @apellido = 'Hoz',
--     @apellidoMaterno = 'Gonzalez',
--     @email = 'hozlucas28@gmail.com',
--     @fechaNacimiento = '2002-02-20',
--     @fotoPerfil = NULL,
--     @idCobertura = 1,
--     @idDireccion = 12345,
--     @idGenero = 1,
--     @idTipoDocumento = 1,
--     @nacionalidad = 1,
--     @nombre = 'Lucas',
--     @nroDocumento = '43950154',
--     @sexoBiologico = 'M',
--     @telAlternativo = NULL,
--     @telFijo = '1134465827',
--     @telLaboral = NULL;