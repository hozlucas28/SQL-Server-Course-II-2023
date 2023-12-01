USE [CURESA];
GO


/* -------------------------- Eliminar Inserciones -------------------------- */

DELETE FROM [data].[tipos_turnos];
DELETE FROM [data].[estados_turnos];
GO


/* ---------------------------- Crear Inserciones ---------------------------- */

INSERT INTO [data].[tipos_turnos] ([nombre_tipo]) VALUES ('PRESENCIAL'), ('VIRTUAL');

INSERT INTO [data].[estados_turnos] ([nombre]) VALUES ('ATENDIDO'), ('AUSENTE'), ('CANCELADO'),('PENDIENTE');
