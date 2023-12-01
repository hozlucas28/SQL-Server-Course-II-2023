USE [CURESA];
GO


/* ----------------------------- Eliminar Roles ----------------------------- */

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Medic' AND type_desc = 'DATABASE_ROLE')
BEGIN
    DROP ROLE [Medic];
END;

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Patient' AND type_desc = 'DATABASE_ROLE')
BEGIN
    DROP ROLE [Patient];
END;

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'General administrator' AND type_desc = 'DATABASE_ROLE')
BEGIN
    DROP ROLE [General administrator];
END;

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Administrative staff' AND type_desc = 'DATABASE_ROLE')
BEGIN
    DROP ROLE [Administrative staff];
END;

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Clinical technical staff' AND type_desc = 'DATABASE_ROLE')
BEGIN
    DROP ROLE [Clinical technical staff];
END;
GO


/* ------------------------------- Crear Roles ------------------------------ */

CREATE ROLE [Medic];
CREATE ROLE [Patient];
CREATE ROLE [General administrator];
CREATE ROLE [Administrative staff];
CREATE ROLE [Clinical technical staff];
GO


/* ---------------------------- ASIGNAR PERMISOS ---------------------------- */

-- Personal Administrativo
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdNacionalidad] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarNacionalidad] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdLocalidad] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[referencias].[insertarLocalidad] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdProvincia] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarProvincias] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdDireccion] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarDireccion] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utils].[obtenerCharSexo] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdGenero] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarGenero] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOIsertarIdTipoDocumento] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[referencias].[insertarTipoDocumento] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[datos].[insertarPaciente] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[datos].[actualizarPaciente] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[datos].[borrarPaciente] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[datos].[existePaciente] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[datos].[obtenerIdEspecialidad] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[datos].[registrarCobertura] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[datos].[actualizarCobertura] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[datos].[eliminarCobertura] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[datos].[registrarPrestador] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[datos].[actualizarPrestador] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[datos].[eliminarPrestador] TO [Administrative staff];

-- Administrador General
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdNacionalidad] TO [General administrator];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarNacionalidad] TO [General administrator];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdLocalidad] TO [General administrator];
GRANT EXECUTE ON OBJECT::[referencias].[insertarLocalidad] TO [General administrator];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdProvincia] TO [General administrator];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarProvincias] TO [General administrator];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdDireccion] TO [General administrator];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarDireccion] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utils].[obtenerCharSexo] TO [General administrator];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdGenero] TO [General administrator];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarGenero] TO [General administrator];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOIsertarIdTipoDocumento] TO [General administrator];
GRANT EXECUTE ON OBJECT::[referencias].[insertarTipoDocumento] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[insertarPaciente] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[actualizarPaciente] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[borrarPaciente] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[existePaciente] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[obtenerIdEspecialidad] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[insertarUsuario] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[actualizarUsuario] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[borrarUsuario] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[insertarMedico] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[eliminarMedico] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[obtenerIdEspecialidad] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[guardarEspecialidad] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[registrarCobertura] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[actualizarCobertura] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[eliminarCobertura] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[registrarPrestador] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[actualizarPrestador] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[eliminarPrestador] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[insertarDiasXSede] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[actualizarDiasXSede] TO [General administrator];
GRANT EXECUTE ON OBJECT::[datos].[eliminarDiasXSede] TO [General administrator];

-- Personal técnico clínico
GRANT EXECUTE ON OBJECT::[archivos].[importarDatosCSV] TO [Clinical technical staff];
GRANT EXECUTE ON OBJECT::[archivos].[importarMedicosCSV] TO [Clinical technical staff];
GRANT EXECUTE ON OBJECT::[archivos].[importarPrestadoresCSV] TO [Clinical technical staff];
GRANT EXECUTE ON OBJECT::[archivos].[importarPacientesCSV] TO [Clinical technical staff];
GRANT EXECUTE ON OBJECT::[archivos].[importarSedesCSV] TO [Clinical technical staff];
GRANT EXECUTE ON OBJECT::[archivos].[exportarTurnosAtendidosXML] TO [Clinical technical staff];
GRANT EXECUTE ON OBJECT::[archivos].[importarEstudiosJSON] TO [Clinical technical staff];

-- Paciente
GRANT EXECUTE ON OBJECT::[datos].[registrarTurnoMedico] TO [Patient];
GRANT EXECUTE ON OBJECT::[datos].[actualizarTurnoMedico] TO [Patient];
GRANT EXECUTE ON OBJECT::[datos].[cancelarTurnoMedico] TO [Patient];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdNacionalidad] TO [Patient];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarNacionalidad] TO [Patient];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdLocalidad] TO [Patient];
GRANT EXECUTE ON OBJECT::[referencias].[insertarLocalidad] TO [Patient];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdProvincia] TO [Patient];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarProvincias] TO [Patient];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdDireccion] TO [Patient];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarDireccion] TO [Patient];
GRANT EXECUTE ON OBJECT::[utils].[obtenerCharSexo] TO [Patient];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOInsertarIdGenero] TO [Patient];
GRANT EXECUTE ON OBJECT::[referencias].[actualizarGenero] TO [Patient];
GRANT EXECUTE ON OBJECT::[referencias].[obtenerOIsertarIdTipoDocumento] TO [Patient];
GRANT EXECUTE ON OBJECT::[referencias].[insertarTipoDocumento] TO [Patient];
GRANT EXECUTE ON OBJECT::[datos].[insertarPaciente] TO [Patient];
GRANT EXECUTE ON OBJECT::[datos].[actualizarPaciente] TO [Patient];

-- Médico
GRANT EXECUTE ON OBJECT::[datos].[registrarEstudio] TO [Medic];
GRANT EXECUTE ON OBJECT::[datos].[actualizarEstudio] TO [Medic];
GRANT EXECUTE ON OBJECT::[datos].[eliminarEstudio] TO [Medic];