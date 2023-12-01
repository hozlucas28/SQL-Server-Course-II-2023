USE [CURESA];
GO


/* -------------------------- Eliminar Inserciones -------------------------- */

DELETE FROM [data].[Shifts];
DELETE FROM [data].[Shift_Status];
GO


/* ---------------------------- Crear Inserciones ---------------------------- */

INSERT INTO [data].[Shifts] ([nombre_tipo]) VALUES ('PRESENCIAL'), ('VIRTUAL');

INSERT INTO [data].[Shift_Status] ([nombre]) VALUES ('ATENDIDO'), ('AUSENTE'), ('CANCELADO'),('PENDIENTE');
