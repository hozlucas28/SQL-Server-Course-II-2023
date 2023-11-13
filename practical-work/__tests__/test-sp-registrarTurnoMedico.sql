USE [CURESA];

--- caso 1: reservo un turno normal
--- caso 2: reservo un turno solo 5min despues del primero por lo que no podria.
DECLARE @idPaciente INT,
        @idMedico INT, @nombreMedico VARCHAR(255), @apellidoMedico VARCHAR(255), @especialidad VARCHAR(255) = NULL,
        @nombreSede VARCHAR(255),@idSede INT,
        @idTurno INT,
        @fecha DATE = '2022-12-18',
        @horaTurno TIME = '12:00:00',
        @horaTurno2 TIME = '12:05:00',
        @tipoTurno VARCHAR(255) = 'PRESENCIAL';

SELECT TOP(1) @idPaciente = id_paciente FROM datos.pacientes;
SELECT TOP(1) @idMedico = id_medico, 
              @nombreMedico = nombre, 
              @apellidoMedico = apellido FROM datos.medicos;
SELECT TOP(1) @nombreSede = nombre,@idSede = id_sede FROM datos.sede_de_atencion;

INSERT INTO datos.dias_x_sede (dia,hora_inicio,hora_fin,id_medico,id_sede) VALUES (@fecha,'10:00:00','18:00:00',@idMedico,@idSede);

-- Ejecutar el procedimiento almacenado
EXEC [datos].[registrarTurnoMedico] @idPaciente, @fecha, @horaTurno, @nombreMedico, 
                            @apellidoMedico, @especialidad,@nombreSede, @tipoTurno, @idTurno OUTPUT;

-- Verificar si el procedimiento se ejecutó correctamente
IF @idTurno IS NOT NULL
    PRINT '+PASO CASO 1 ID: ' + CAST(@idTurno AS VARCHAR)
ELSE
    PRINT '-NO PASO CASO 1'

EXEC [datos].[registrarTurnoMedico] @idPaciente, @fecha, @horaTurno2, @nombreMedico, 
                            @apellidoMedico, @especialidad,@nombreSede, @tipoTurno, @idTurno OUTPUT;

IF @idTurno = -1
    PRINT '+PASO CASO 2 ID: ' + CAST(@idTurno AS VARCHAR)
ELSE
    PRINT '-NO PASO CASO 2' 


delete from datos.reservas_turnos_medicos;
