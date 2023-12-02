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
GRANT EXECUTE ON OBJECT::[utilities].[getOrInsertNationalityId] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[updateOrInsertNationality] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[getOrInsertLocalityId] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[updateOrInsertLocality] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[getOrInsertProvinceId] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[updateOrInsertProvinces] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[getOrInsertAddressId] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[updateOrInsertAddress] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[getSexChar] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[getOrInsertGenderId] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[getOrInsertDocumentId] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[utilities].[updateOrInsertDocument] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[insertPatient] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[updatePatient] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[deletePatient] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[patientExists] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[getSpecialtyId] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[insertCoverage] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[updateCoverage] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[insertProvider] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[insertProvider] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[updateProvider] TO [Administrative staff];
GRANT EXECUTE ON OBJECT::[data].[deleteProvider] TO [Administrative staff];

-- Administrador General
GRANT EXECUTE ON OBJECT::[utilities].[getOrInsertNationalityId] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[updateOrInsertNationality] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[getOrInsertLocalityId] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[updateOrInsertLocality] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[getOrInsertProvinceId] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[updateOrInsertProvinces] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[getOrInsertAddressId] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[updateOrInsertAddress] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[getSexChar] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[getOrInsertGenderId] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[getOrInsertDocumentId] TO [General administrator];
GRANT EXECUTE ON OBJECT::[utilities].[updateOrInsertDocument] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[insertPatient] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[updatePatient] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[deletePatient] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[patientExists] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[insertUser] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[updateUser] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[deleteUser] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[insertMedic] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[deleteMedic] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[getSpecialtyId] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[updateOrInsertSpecialty] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[insertCoverage] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[updateCoverage] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[insertProvider] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[insertProvider] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[updateProvider] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[deleteProvider] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[insertDayXHeadquarter] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[updateDayXHeadquarter] TO [General administrator];
GRANT EXECUTE ON OBJECT::[data].[deleteDayXHeadquarter] TO [General administrator];

-- Personal técnico clínico
GRANT EXECUTE ON OBJECT::[files].[importDataCSV] TO [Clinical technical staff];
GRANT EXECUTE ON OBJECT::[files].[importMedicsCSV] TO [Clinical technical staff];
GRANT EXECUTE ON OBJECT::[files].[importProvidersCSV] TO [Clinical technical staff];
GRANT EXECUTE ON OBJECT::[files].[importPatientsCSV] TO [Clinical technical staff];
GRANT EXECUTE ON OBJECT::[files].[importHeadquartersCSV] TO [Clinical technical staff];
GRANT EXECUTE ON OBJECT::[files].[showShiftsAttendedAsXML] TO [Clinical technical staff];
GRANT EXECUTE ON OBJECT::[files].[importResearchesJSON] TO [Clinical technical staff];

-- Paciente
GRANT EXECUTE ON OBJECT::[data].[insertMedicalAppointmentReservation] TO [Patient];
GRANT EXECUTE ON OBJECT::[data].[updateMedicalAppointmentReservation] TO [Patient];
GRANT EXECUTE ON OBJECT::[data].[deleteMedicalAppointmentReservation] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[getOrInsertNationalityId] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[updateOrInsertNationality] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[getOrInsertLocalityId] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[updateOrInsertLocality] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[getOrInsertProvinceId] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[updateOrInsertProvinces] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[getOrInsertAddressId] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[updateOrInsertAddress] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[getSexChar] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[getOrInsertGenderId] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[getOrInsertDocumentId] TO [Patient];
GRANT EXECUTE ON OBJECT::[utilities].[updateOrInsertDocument] TO [Patient];
GRANT EXECUTE ON OBJECT::[data].[insertPatient] TO [Patient];
GRANT EXECUTE ON OBJECT::[data].[updatePatient] TO [Patient];

-- Médico
GRANT EXECUTE ON OBJECT::[data].[insertResearch] TO [Medic];
GRANT EXECUTE ON OBJECT::[data].[updateResearch] TO [Medic];
GRANT EXECUTE ON OBJECT::[data].[deleteResearch] TO [Medic];