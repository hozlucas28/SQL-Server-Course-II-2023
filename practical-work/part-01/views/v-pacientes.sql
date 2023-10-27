USE [cure_sa]
GO

-- Drop the view if it already exists
IF EXISTS (
SELECT *
    FROM sys.views
    JOIN sys.schemas
    ON sys.views.schema_id = sys.schemas.schema_id
    WHERE sys.schemas.name = N'vistasPacientes'
    AND sys.views.name = N'datosPacientes'
)
DROP VIEW vistasPacientes.datosPacientes
GO

CREATE VIEW vistasPacientes.datosPacientes
AS
    SELECT 
        p.nombre AS Nombre, 
        p.apellido AS Apellido, 
        p.apellido_materno AS [Apellido materno],
        pr.nombre AS Prestador,
        pr.plan_prestador AS [Plan],
        [utils].[obtenerSexoConChar](sexo_biologico) AS Sexo,
        g.nombre AS Genero,
        p.fecha_nacimiento AS [Fecha de nacimiento AA/MM/DD],
        td.id_tipo_documento AS [Tipo de documento],
        p.nro_documento AS [Documento], 
        p.email AS [Email],
        p.tel_fijo AS [Telefono],
        p.tel_alternativo AS [Telefono alternativo],
        p.tel_laboral AS [Telefono laboral]
    FROM [datos].[pacientes] p
    INNER JOIN [referencias].tipos_documentos td ON td.id_tipo_documento = p.id_tipo_documento
    INNER JOIN [referencias].[generos] g ON g.id_genero = p.id_genero
    LEFT JOIN [datos].[coberturas] c ON c.id_cobertura = p.id_cobertura
    LEFT JOIN [datos].[prestadores] pr ON pr.id_prestador = c.id_prestador
GO

select * from vistasPacientes.datosPacientes