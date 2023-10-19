GO
USE [cure_sa];

/* ----------------------------- Eliminar Roles ----------------------------- */

GO
IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Médico' AND type_desc = 'DATABASE_ROLE')
BEGIN
    DROP ROLE [Médico];
END;

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Paciente' AND type_desc = 'DATABASE_ROLE')
BEGIN
    DROP ROLE [Paciente];
END;

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Administrador General' AND type_desc = 'DATABASE_ROLE')
BEGIN
    DROP ROLE [Administrador General];
END;

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Personal Administrativo' AND type_desc = 'DATABASE_ROLE')
BEGIN
    DROP ROLE [Personal Administrativo];
END;

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Personal Técnico Clínico' AND type_desc = 'DATABASE_ROLE')
BEGIN
    DROP ROLE [Personal Técnico Clínico];
END;

/* ------------------------------- Crear Roles ------------------------------ */

GO
CREATE ROLE [Médico];
CREATE ROLE [Paciente];
CREATE ROLE [Administrador General];
CREATE ROLE [Personal Administrativo];
CREATE ROLE [Personal Técnico Clínico];

/* ---------------------------- ASIGNAR PERMISOS ---------------------------- */

-- Médico
GRANT SELECT ON [datos].[dias_x_sede] TO [Médico];
GRANT SELECT ON [datos].[medicos] TO [Médico]; -- Limitar el accionar a sus datos a través de SP.
GRANT SELECT ON [datos].[pacientes] TO [Médico]; -- Limitar el accionar a sus pacientes a través de SP.
GRANT SELECT ON [datos].[reservas_turnos_medicos] TO [Médico];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[estudios] TO [Médico]; -- Limitar el accionar a sus pacientes a través de SP.

-- Paciente
GRANT SELECT ON [datos].[reservas_turnos_medicos] TO [Paciente]; -- Limitar el accionar a sus datos a través de SP.
GRANT SELECT, UPDATE ON [datos].[pacientes] TO [Paciente]; -- Limitar el accionar a sus datos a través de SP.
GRANT SELECT, UPDATE ON [datos].[usuarios] TO [Paciente]; -- Limitar el accionar a sus datos a través de SP.

-- Administrador General
GRANT SELECT, INSERT, UPDATE, DELETE ON [referencias].[generos] TO [Administrador General];
GRANT SELECT, INSERT, UPDATE, DELETE ON [referencias].[paises] TO [Administrador General];
GRANT SELECT, INSERT, UPDATE, DELETE ON [referencias].[nombres_provincias] TO [Administrador General];
GRANT SELECT, INSERT, UPDATE, DELETE ON [referencias].[nombres_localidades] TO [Administrador General];
GRANT SELECT, INSERT, UPDATE, DELETE ON [referencias].[direcciones] TO [Administrador General];
GRANT SELECT, INSERT, UPDATE, DELETE ON [referencias].[tipos_documentos] TO [Administrador General];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[pacientes] TO [Administrador General];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[estudios] TO [Administrador General];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[usuarios] TO [Administrador General];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[coberturas] TO [Administrador General];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[prestadores] TO [Administrador General];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[reservas_turnos_medicos] TO [Administrador General];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[estados_turnos] TO [Administrador General];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[tipos_turnos] TO [Administrador General];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[dias_x_sede] TO [Administrador General];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[sede_de_atencion] TO [Administrador General];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[medicos] TO [Administrador General];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[especialidad] TO [Administrador General];

-- Personal Administrativo
GRANT SELECT ON [datos].[coberturas] TO [Personal Administrativo];
GRANT SELECT ON [datos].[estudios] TO [Personal Administrativo];
GRANT SELECT ON [datos].[prestadores] TO [Personal Administrativo];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[dias_x_sede] TO [Personal Administrativo];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[especialidad] TO [Personal Administrativo];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[estados_turnos] TO [Personal Administrativo];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[medicos] TO [Personal Administrativo];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[reservas_turnos_medicos] TO [Personal Administrativo];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[sede_de_atencion] TO [Personal Administrativo];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[tipos_turnos] TO [Personal Administrativo];
GRANT SELECT, INSERT, UPDATE, DELETE ON [referencias].[direcciones] TO [Personal Administrativo];

-- Personal Técnico Clínico
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[estudios] TO [Personal Técnico Clínico];
GRANT SELECT, INSERT, UPDATE, DELETE ON [datos].[estudiosValidos] TO [Personal Técnico Clínico];

-- GRANT EXECUTE ON [Nombre del SP] TO [Nombre del rol];