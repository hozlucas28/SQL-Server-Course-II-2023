USE [CURESA];
GO

/* --------------------------- Ver check constraints --------------------------- */

/*
SELECT
name, definition 
FROM
    sys.check_constraints
*/


/* --------------------------- Ver foreign keys --------------------------- */

/*
use curesa

SELECT 
   OBJECT_NAME(f.parent_object_id) AS 'Table name',
   COL_NAME(fc.parent_object_id,fc.parent_column_id) AS 'Field name',
   delete_referential_action_desc AS 'On Delete'
FROM sys.foreign_keys AS f,
     sys.foreign_key_columns AS fc,
     sys.tables t 
WHERE f.OBJECT_ID = fc.constraint_object_id
AND t.OBJECT_ID = fc.referenced_object_id
ORDER BY 1
*/


/* --------------------------- Crear Restricciones --------------------------- */


-- Géneros
ALTER TABLE [utilities].[Genders] ADD CONSTRAINT [PRIMARY_KEY_GENDER_ID] PRIMARY KEY ([id]);

-- Países
ALTER TABLE [utilities].[Countries] ADD CONSTRAINT [PRIMARY_KEY_COUNTRY_ID] PRIMARY KEY ([id]);

ALTER TABLE [utilities].[Nationalities] ADD CONSTRAINT [PRIMARY_KEY_NATIONALITY_ID] PRIMARY KEY ([id]);

-- Tipos de documentos
ALTER TABLE [utilities].[Documents] ADD CONSTRAINT [PRIMARY_KEY_DOCUMENT_ID] PRIMARY KEY ([id]);

-- Especialidad
ALTER TABLE [data].[Specialties] ADD CONSTRAINT [PRIMARY_KEY_SPECIALTY_ID] PRIMARY KEY ([id]);

-- Nombres de provincias
ALTER TABLE [utilities].[Provinces] ADD CONSTRAINT [PRIMARY_KEY_PROVINCE_ID] PRIMARY KEY ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_PROVINCE_TO_COUNTRY_ID] FOREIGN KEY ([countryId]) REFERENCES [utilities].[Countries] ([id]);

-- Nombres de localidades
ALTER TABLE [utilities].[Localities] ADD CONSTRAINT [PRIMARY_KEY_LOCALITY_ID] PRIMARY KEY ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_LOCALITY_TO_PROVINCE_ID] FOREIGN KEY ([provinceId]) REFERENCES [utilities].[Provinces] ([id]);

-- Direcciones
ALTER TABLE [utilities].[Addresses] ADD CONSTRAINT [PRIMARY_KEY_ADDRESS_ID] PRIMARY KEY ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_ADDRESS_TO_COUNTRY_ID] FOREIGN KEY ([countryId]) REFERENCES [utilities].[Countries] ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_ADDRESS_TO_PROVINCE_ID] FOREIGN KEY ([provinceId]) REFERENCES [utilities].[Provinces] ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_ADDRESS_TO_LOCALITY_ID] FOREIGN KEY ([localityId]) REFERENCES [utilities].[Localities] ([id]);

-- Prestadores
ALTER TABLE [data].[Providers] ADD CONSTRAINT [PRIMARY_KEY_PROVIDER_ID] PRIMARY KEY ([id]);

-- Coberturas
ALTER TABLE [data].[Coverages] ADD CONSTRAINT [PRIMARY_KEY_COVERAGE_ID] PRIMARY KEY ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_COVERAGE_TO_PROVIDER_ID] FOREIGN KEY ([providerId]) REFERENCES [data].[Providers] ([id]);

-- Pacientes
ALTER TABLE [data].[Patients] ADD CONSTRAINT [PRIMARY_KEY_PATIENT_ID] PRIMARY KEY ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_PATIENT_TO_COVERAGE_ID] FOREIGN KEY ([coverageId]) REFERENCES [data].[Coverages] ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_PATIENT_TO_ADDRESS_ID] FOREIGN KEY ([addressId]) REFERENCES [utilities].[Addresses] ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_PATIENT_TO_DOCUMENT_ID] FOREIGN KEY ([documentId]) REFERENCES [utilities].[Documents] ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_PATIENT_TO_GENDER_ID] FOREIGN KEY ([genderId]) REFERENCES [utilities].[Genders] ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_PATIENT_TO_NATIONALITY_ID] FOREIGN KEY ([nationalityId]) REFERENCES [utilities].[Nationalities] ([id]);

-- Estudios
ALTER TABLE [data].[Researches] ADD CONSTRAINT [PRIMARY_KEY_RESEARCH_ID] PRIMARY KEY ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_RESEARCH_TO_PATIENT_ID] FOREIGN KEY ([patientId]) REFERENCES [data].[Patients] ([id]);

-- Estudios válidos
ALTER TABLE [data].[Valid_Researches] ADD CONSTRAINT [PRIMARY_KEY_VALID_RESEARCH_ID] PRIMARY KEY ([id]), -- TODO: Cambiar nombre de la tabla.
    CONSTRAINT [FOREIGN_KEY_OF_VALID_RESEARCH_TO_PROVIDER_ID] FOREIGN KEY ([providerId]) REFERENCES [data].[Providers] ([id]);

-- Usuarios
ALTER TABLE [data].[Users] ADD CONSTRAINT [PRIMARY_KEY_USER_ID] PRIMARY KEY ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_USER_TO_PATIENT_ID] FOREIGN KEY ([patientId]) REFERENCES [data].[Patients] ([id]) ON DELETE CASCADE;

-- Sedes de atención
ALTER TABLE [data].[Care_Headquarters] ADD CONSTRAINT [PRIMARY_KEY_CARE_HEADQUARTER_ID] PRIMARY KEY ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_CARE_HEADQUARTER_TO_ADDRESS_ID] FOREIGN KEY ([addressId]) REFERENCES [utilities].[Addresses] ([id]);

-- Médicos
ALTER TABLE [data].[Medics] ADD CONSTRAINT [PRIMARY_KEY_MEDIC_ID] PRIMARY KEY ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_MEDIC_TO_SPECIALTY_ID] FOREIGN KEY ([specialtyId]) REFERENCES [data].[Specialties] ([id]);

-- Días x Sede
ALTER TABLE [data].[Days_X_Headquarter] ADD CONSTRAINT [PRIMARY_KEY_DAY_X_HEADQUARTER_ID] PRIMARY KEY ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_DAY_X_HEADQUARTER_TO_CARE_HEADQUARTER_ID] FOREIGN KEY ([careHeadquarterId]) REFERENCES [data].[Care_Headquarters] ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_DAY_X_HEADQUARTER_TO_MEDIC_ID] FOREIGN KEY ([medicId]) REFERENCES [data].[Medics] ([id]);

-- Estados de los turnos
ALTER TABLE [data].[Shift_Status] ADD CONSTRAINT [PRIMARY_KEY_SHIFT_STATUS_ID] PRIMARY KEY ([id]),
    CONSTRAINT [CHECK_SHIFT_STATUS_NAME] CHECK (UPPER ([name]) IN ('ATENDIDO', 'AUSENTE', 'CANCELADO','PENDIENTE'));

-- Tipos de turnos
ALTER TABLE [data].[Shifts] ADD CONSTRAINT [PRIMARY_KEY_SHIFT_ID] PRIMARY KEY ([id]),
    CONSTRAINT [CHECK_SHIFT_MODALITY] CHECK (UPPER ([modality]) IN ('PRESENCIAL', 'VIRTUAL'));

-- Reservas de turnos médicos
ALTER TABLE [data].[Medical_Appointment_Reservations] ADD CONSTRAINT [PRIMARY_KEY_MEDICAL_APPOINTMENT_RESERVATION_ID] PRIMARY KEY ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_MEDICAL_APPOINTMENT_RESERVATION_TO_SHIFT_ID] FOREIGN KEY ([shiftId]) REFERENCES [data].[Shifts] ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_MEDICAL_APPOINTMENT_RESERVATION_TO_SHIFT_STATUS_ID] FOREIGN KEY ([shiftId]) REFERENCES [data].[Shift_Status] ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_MEDICAL_APPOINTMENT_RESERVATION_TO_PATIENT_ID] FOREIGN KEY ([patientId]) REFERENCES [data].[Patients] ([id]),
    CONSTRAINT [FOREIGN_KEY_OF_MEDICAL_APPOINTMENT_RESERVATION_TO_DAY_X_HEADQUARTER_ID] FOREIGN KEY ([daysXHeadquarterId]) REFERENCES [data].[Days_X_Headquarter] ([id]);