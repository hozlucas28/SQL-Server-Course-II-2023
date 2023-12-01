USE [CURESA];
GO

/*
    Se requiere la ejecución previa de los siguientes tests:
        - < test-importData.sql >
*/


/* ----------------------------- Insertar Turnos ---------------------------- */

/*
    - Caso 1 = Reserva de un turno.
    - Caso 2 = Reserva de un turno 5 minutos despues del primero, por lo que será denegado.
*/

DECLARE @idPaciente INT;
DECLARE @idMedico INT;
DECLARE @nombreMedico VARCHAR(255);
DECLARE @apellidoMedico VARCHAR(255);
DECLARE @especialidad VARCHAR(255) = NULL;
DECLARE @nombreSede VARCHAR(255);
DECLARE @idSede INT;
DECLARE @idTurno INT;
DECLARE @fecha DATE = '2022-12-18';
DECLARE @horaTurno TIME = '12:00:00';
DECLARE @horaTurno2 TIME = '12:05:00';
DECLARE @tipoTurno VARCHAR(255) = 'PRESENCIAL';

SELECT TOP(1) @idPaciente = [id_paciente] FROM [data].[Patients];
SELECT TOP(1) @idMedico = [id_medico], @nombreMedico = [nombre], @apellidoMedico = [apellido] FROM [data].[Medics];
SELECT TOP(1) @nombreSede = [nombre], @idSede = [id_sede] FROM [data].[Care_Headquarters];

-- Registrar Días x Sede
EXEC [data].[insertarDiasXSede]
    @dia = @fecha,
    @horaInicio = '10:00:00',
    @horaFin = '18:00:00',
    @idMedico = @idMedico,
    @idSede = @idSede;

-- Insertar turnos y verificar casos
EXEC [data].[registrarTurnoMedico]
    @idPaciente,
    @fecha,
    @horaTurno,
    @nombreMedico,
    @apellidoMedico,
    @especialidad,
    @nombreSede,
    @tipoTurno,
    @idTurno OUTPUT;

IF @idTurno IS NOT NULL
    PRINT '=> [ / ] El caso 1 se completo con éxito (ID: ' + CAST(@idTurno AS VARCHAR) + ').'
ELSE
    PRINT '=> [ X ] El caso 1 no se completo con éxito.';
SELECT * FROM [data].[Medical_Appointment_Reservations] WHERE [id_turno] = @idTurno;

EXEC [data].[registrarTurnoMedico]
    @idPaciente,
    @fecha,
    @horaTurno2,
    @nombreMedico,
    @apellidoMedico,
    @especialidad,@nombreSede,
    @tipoTurno,
    @idTurno OUTPUT;

IF @idTurno = -1
    PRINT '=> [ / ] El caso 2 se completo con éxito (ID: ' + CAST(@idTurno AS VARCHAR) + ').'
ELSE
    PRINT '=> [ X ] El caso 2 no se completo con éxito.';
SELECT * FROM [data].[Medical_Appointment_Reservations] WHERE [id_turno] = @idTurno;