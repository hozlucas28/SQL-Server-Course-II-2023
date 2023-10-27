USE [cure_sa]
GO

IF EXISTS (
SELECT *
    FROM sys.views
    JOIN sys.schemas
    ON sys.views.schema_id = sys.schemas.schema_id
    WHERE sys.schemas.name = N'vistasMedicos'
    AND sys.views.name = N'datosMedicos'
)
DROP VIEW vistasMedicos.datosMedicos
GO

CREATE VIEW vistasMedicos.datosMedicos
AS    
    SELECT 
        m.nro_matricula AS [Matricula],
        m.apellido AS [Apellido], 
        m.nombre AS [Nombre],
        e.nombre AS [Especialidad],        
        m.alta AS [Alta]
    FROM [datos].[medicos] m
    LEFT JOIN [datos].[especialidad] e ON e.id_especialidad = m.id_especialidad
GO

-- primero buscar si el apellido tiene un punto

-- despues split por punto 

-- tomar el valor ordinal igual a 2 

/*
    SELECT 
        m.nombre AS [Nombre],
        LEFT(LTRIM([value]), 1) + LOWER(SUBSTRING(LTRIM([value]), 2, LEN(LTRIM([value])))) AS [Apellido],
        m.nro_matricula AS [Matricula],
        e.nombre AS [Especialidad],        
        m.alta AS [Alta]
    FROM [datos].[medicos] m
    LEFT JOIN [datos].[especialidad] e ON e.id_especialidad = m.id_especialidad
    CROSS APPLY string_split(apellido, '.', 1)
    WHERE CHARINDEX('.', apellido) = 0 OR ordinal = 2

*/

/*
    SELECT 
        m.nombre AS [Nombre],
        (
            CASE 
                WHEN CHARINDEX('.', m.apellido) = 0 
                    THEN m.apellido 
                ELSE 
                    (SELECT LTRIM([value])
                    FROM string_split(m.apellido, '.', 1)
                    WHERE ordinal = 2)
            END
        )AS [Apellido], 
        m.nro_matricula AS [Matricula],
        e.nombre AS [Especialidad],        
        m.alta AS [Alta]
    FROM [datos].[medicos] m
    LEFT JOIN [datos].[especialidad] e ON e.id_especialidad = m.id_especialidad

*/

SELECT 
    Ap.[Matricula],
    [Honorifico],
    [Apellido],
    [Nombre],
    [Especialidad],        
    [Alta]
FROM(
    SELECT 
        [Nombre],
        LTRIM([value]) AS [Apellido],
        [Matricula],
        [Especialidad],        
        [Alta]
    FROM vistasMedicos.datosMedicos
    CROSS APPLY string_split(Apellido, '.', 1)
    WHERE CHARINDEX('.', Apellido) = 0 OR ordinal = 2
)AS Ap
LEFT JOIN (
    SELECT 
        [value] AS [Honorifico],
        [Matricula]
    FROM vistasMedicos.datosMedicos
    CROSS APPLY string_split(Apellido, '.', 1)
    WHERE CHARINDEX('.', Apellido) <> 0 AND ordinal = 1
)Hco
ON Ap.[Matricula] = Hco.[Matricula]
