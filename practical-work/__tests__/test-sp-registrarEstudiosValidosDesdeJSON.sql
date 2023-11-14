USE [CURESA]
GO

EXEC [datos].[registrarEstudiosValidosDesdeJSON] 
    "..\dataset\Centro_Autorizaciones_Estudios_clinicos.json"

SELECT * FROM [datos].[estudiosValidos]
