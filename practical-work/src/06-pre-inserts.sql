USE [CURESA];
GO


/* -------------------------- Eliminar Inserciones -------------------------- */

DELETE FROM [data].[Shifts];
DELETE FROM [data].[Shift_Status];
GO


/* ---------------------------- Crear Inserciones ---------------------------- */

-- Registrar modalidades de los turnos
INSERT INTO [data].[Shifts] ([modality]) VALUES ('PRESENCIAL'), ('VIRTUAL');

-- Registrar nombres de los estados de los turnos
INSERT INTO [data].[Shift_Status] ([name]) VALUES ('ATENDIDO'), ('AUSENTE'), ('CANCELADO'),('PENDIENTE');
