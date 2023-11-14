USE [CURESA];
GO


/* -------------------------- Eliminar Inserciones -------------------------- */

DELETE FROM [datos].[tipos_turnos];
DELETE FROM [datos].[estados_turnos];
GO


/* ---------------------------- Crear Inserciones ---------------------------- */

INSERT INTO [datos].[tipos_turnos] ([nombre_tipo]) VALUES ('PRESENCIAL'), ('VIRTUAL');

INSERT INTO [datos].[estados_turnos] ([nombre]) VALUES ('ATENDIDO'), ('AUSENTE'), ('CANCELADO'),('PENDIENTE');
