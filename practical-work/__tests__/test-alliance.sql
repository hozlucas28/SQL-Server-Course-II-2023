USE CURESA;
GO

select * from datos.reservas_turnos_medicos

DECLARE
@idPaciente INT,
@idPrestador INT,
@idCobertura INT;

SET @idPaciente = 137;
SET @idPrestador = 1;

INSERT INTO datos.coberturas
(id_prestador, imagen_credencial, nro_socio)
VALUES(@idPrestador, null, @idPaciente)

SELECT @idCobertura = id_cobertura
FROM datos.coberturas
WHERE id_prestador = @idPrestador

SELECT * FROM 
datos.pacientes
WHERE id_paciente = @idPaciente

UPDATE datos.pacientes 
SET id_cobertura = @idCobertura
WHERE id_paciente = @idPaciente

SELECT * FROM datos.reservas_turnos_medicos
WHERE id_paciente = @idPaciente;

DELETE FROM datos.prestadores
WHERE id_prestador = @idPrestador

SELECT * FROM datos.reservas_turnos_medicos
WHERE id_paciente = @idPaciente;

