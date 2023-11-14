USE [CURESA];
GO


/* ----------------------------- Eliminar Roles ----------------------------- */

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
GO

/* ------------------------------- Crear Roles ------------------------------ */

CREATE ROLE [Médico];
CREATE ROLE [Paciente];
CREATE ROLE [Administrador General];
CREATE ROLE [Personal Administrativo];
CREATE ROLE [Personal Técnico Clínico];
GO


/* ---------------------------- ASIGNAR PERMISOS ---------------------------- */

-- Personal Administrativo
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdNacionalidad] TO [Personal Administrativo];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarNacionalidad] TO [Personal Administrativo];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdLocalidad] TO [Personal Administrativo];
GRANT EXECUTE ON OBJECT::[referencias].[insertarLocalidad] TO [Personal Administrativo];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdProvincia] TO [Personal Administrativo];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarProvincias] TO [Personal Administrativo];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdDireccion] TO [Personal Administrativo];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarDireccion] TO [Personal Administrativo];
GRANT EXECUTE ON OBJECT::[utils].[obtenerCharSexo] TO [Personal Administrativo];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdGenero] TO [Personal Administrativo];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarGenero] TO [Personal Administrativo];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOIsertarIdTipoDocumento] TO [Personal Administrativo];
GRANT EXECUTE ON OBJECT::[referencias].[insertarTipoDocumento] TO [Personal Administrativo];
GRANT EXECUTE ON OBJECT::[datos].[insertarPaciente] TO [Personal Administrativo];
GRANT EXECUTE ON OBJECT::[datos].[actualizarPaciente] TO [Personal Administrativo];
GRANT EXECUTE ON OBJECT::[datos].[borrarPaciente] TO [Personal Administrativo];
GRANT EXECUTE ON OBJECT::[datos].[existePaciente] TO [Personal Administrativo];
GRANT EXECUTE ON OBJECT::[datos].[obtenerIdEspecialidad] TO [Personal Administrativo];

-- Administrador General
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdNacionalidad] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarNacionalidad] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdLocalidad] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[referencias].[insertarLocalidad] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdProvincia] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarProvincias] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdDireccion] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarDireccion] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[utils].[obtenerCharSexo] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdGenero] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarGenero] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOIsertarIdTipoDocumento] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[referencias].[insertarTipoDocumento] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[datos].[insertarPaciente] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[datos].[actualizarPaciente] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[datos].[borrarPaciente] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[datos].[existePaciente] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[datos].[obtenerIdEspecialidad] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[datos].[actualizarContraseña] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[datos].[insertarMedico] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[datos].[eliminarMedico] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[datos].[obtenerIdEspecialidad] TO [Administrador General];
GRANT EXECUTE ON OBJECT::[datos].[guardarEspecialidad] TO [Administrador General];

-- Personal técnico clínico
GRANT EXECUTE ON OBJECT::[archivos].[importarDatosCSV] TO [Personal Técnico Clínico];
GRANT EXECUTE ON OBJECT::[archivos].[importarMedicosCSV] TO [Personal Técnico Clínico];
GRANT EXECUTE ON OBJECT::[archivos].[importarPrestadoresCSV] TO [Personal Técnico Clínico];
GRANT EXECUTE ON OBJECT::[archivos].[archivos].[importarPacientesCSV] TO [Personal Técnico Clínico];
GRANT EXECUTE ON OBJECT::[archivos].[importarSedesCSV] TO [Personal Técnico Clínico];
GRANT EXECUTE ON OBJECT::[archivos].[exportarTurnosAtendidosXML] TO [Personal Técnico Clínico];
GRANT EXECUTE ON OBJECT::[archivos].[importarEstudiosJSON] TO [Personal Técnico Clínico];

-- Paciente
GRANT EXECUTE ON OBJECT::[datos].[registrarTurnoMedico] TO [Paciente];
GRANT EXECUTE ON OBJECT::[datos].[actualizarTurnoMedico] TO [Paciente];
GRANT EXECUTE ON OBJECT::[datos].[cancelarTurnoMedico] TO [Paciente];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdNacionalidad] TO [Paciente];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarNacionalidad] TO [Paciente];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdLocalidad] TO [Paciente];
GRANT EXECUTE ON OBJECT::[referencias].[insertarLocalidad] TO [Paciente];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdProvincia] TO [Paciente];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarProvincias] TO [Paciente];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdDireccion] TO [Paciente];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarDireccion] TO [Paciente];
GRANT EXECUTE ON OBJECT::[utils].[obtenerCharSexo] TO [Paciente];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdGenero] TO [Paciente];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarGenero] TO [Paciente];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOIsertarIdTipoDocumento] TO [Paciente];
GRANT EXECUTE ON OBJECT::[referencias].[insertarTipoDocumento] TO [Paciente];
GRANT EXECUTE ON OBJECT::[datos].[insertarPaciente] TO [Paciente];
GRANT EXECUTE ON OBJECT::[datos].[actualizarPaciente] TO [Paciente];

-- Médico
GRANT EXECUTE ON OBJECT::[datos].[registrarEstudio] TO [Médico];
GRANT EXECUTE ON OBJECT::[datos].[actualizarEstudio] TO [Médico];
GRANT EXECUTE ON OBJECT::[datos].[eliminarEstudio] TO [Médico];