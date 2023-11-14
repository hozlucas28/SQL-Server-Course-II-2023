USE [CURESA]
GO

EXEC [archivos].[importarEstudiosJSON] 
    "..\dataset\Centro_Autorizaciones_Estudios_clinicos.json"

SELECT * FROM [datos].[estudiosValidos]
