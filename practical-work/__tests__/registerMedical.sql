USE [CURESA]
GO

EXEC [datos].[registrarEstudiosValidosDesdeJSON] 
    "C:\Users\Gonza\Desktop\TP-BBDDA\Dataset\Centro_Autorizaciones_Estudios_clinicos.json"

SELECT * FROM [datos].[estudiosValidos]

DELETE FROM [datos].[estudiosValidos]