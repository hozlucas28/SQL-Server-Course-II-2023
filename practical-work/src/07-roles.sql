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
GRANT EXECUTE ON OBJECT::[utilities].[obtenerOInsertarIdNacionalidad] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[actualizarNacionalidad] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[obtenerOInsertarIdLocalidad] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[insertarLocalidad] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[obtenerOInsertarIdProvincia] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[actualizarProvincias] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[obtenerOInsertarIdDireccion] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[actualizarDireccion] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[obtenerCharSexo] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[obtenerOInsertarIdGenero] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[actualizarGenero] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[obtenerOIsertarIdTipoDocumento] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[insertarTipoDocumento] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[insertarPaciente] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[actualizarPaciente] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[borrarPaciente] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[existePaciente] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[obtenerIdEspecialidad] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[registrarCobertura] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[actualizarCobertura] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[eliminarCobertura] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[registrarPrestador] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[actualizarPrestador] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[eliminarPrestador] TO [Administrative staff];

-- Administrador General
GRANT EXECUTE ON OBJECT::[utilities].[obtenerOInsertarIdNacionalidad] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[actualizarNacionalidad] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[obtenerOInsertarIdLocalidad] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[insertarLocalidad] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[obtenerOInsertarIdProvincia] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[actualizarProvincias] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[obtenerOInsertarIdDireccion] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[actualizarDireccion] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[obtenerCharSexo] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[obtenerOInsertarIdGenero] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[actualizarGenero] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[obtenerOIsertarIdTipoDocumento] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[insertarTipoDocumento] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[insertarPaciente] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[actualizarPaciente] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[borrarPaciente] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[existePaciente] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[obtenerIdEspecialidad] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[insertarUsuario] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[actualizarUsuario] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[borrarUsuario] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[insertarMedico] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[eliminarMedico] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[obtenerIdEspecialidad] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[guardarEspecialidad] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[registrarCobertura] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[actualizarCobertura] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[eliminarCobertura] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[registrarPrestador] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[actualizarPrestador] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[eliminarPrestador] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[insertarDiasXSede] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[actualizarDiasXSede] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[eliminarDiasXSede] TO [General administrator];

-- Personal técnico clínico
GRANT EXECUTE ON OBJECT::[files].[importarDatosCSV] TO [Clinical technical staff];
GRANT EXECUTE ON OBJECT::[files].[importarMedicosCSV] TO [Clinical technical staff];
GRANT EXECUTE ON OBJECT::[files].[importarPrestadoresCSV] TO [Clinical technical staff];
GRANT EXECUTE ON OBJECT::[files].[importarPacientesCSV] TO [Clinical technical staff];
GRANT EXECUTE ON OBJECT::[files].[importarSedesCSV] TO [Clinical technical staff];
GRANT EXECUTE ON OBJECT::[files].[exportarTurnosAtendidosXML] TO [Clinical technical staff];
GRANT EXECUTE ON OBJECT::[files].[importarEstudiosJSON] TO [Clinical technical staff];

-- Paciente
GRANT EXECUTE ON OBJECT::[data].[registrarTurnoMedico] TO [Patient];
GRANT EXECUTE ON OBJECT::[data].[actualizarTurnoMedico] TO [Patient];
GRANT EXECUTE ON OBJECT::[data].[cancelarTurnoMedico] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[obtenerOInsertarIdNacionalidad] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[actualizarNacionalidad] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[obtenerOInsertarIdLocalidad] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[insertarLocalidad] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[obtenerOInsertarIdProvincia] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[actualizarProvincias] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[obtenerOInsertarIdDireccion] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[actualizarDireccion] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[obtenerCharSexo] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[obtenerOInsertarIdGenero] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[actualizarGenero] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[obtenerOIsertarIdTipoDocumento] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[insertarTipoDocumento] TO [Patient];
GRANT EXECUTE ON OBJECT::[data].[insertarPaciente] TO [Patient];
GRANT EXECUTE ON OBJECT::[data].[actualizarPaciente] TO [Patient];

-- Médico
GRANT EXECUTE ON OBJECT::[data].[registrarEstudio] TO [Medic];
GRANT EXECUTE ON OBJECT::[data].[actualizarEstudio] TO [Medic];
GRANT EXECUTE ON OBJECT::[data].[eliminarEstudio] TO [Medic];