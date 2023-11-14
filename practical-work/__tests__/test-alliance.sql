use CURESA;

/*
exec [archivos].importarPrestadoresCSV
    @rutaArchivo = "C:\Users\gonza\Desktop\SQL-Server-Course-II-2023\practical-work\dataset\Prestador.csv"

exec archivos.importarMedicosCSV
    @rutaArchivo = 
    "C:\Users\gonza\Desktop\SQL-Server-Course-II-2023\practical-work\dataset\Medicos.csv"

exec archivos.importarSedesCSV
    @rutaArchivo = 
    "C:\Users\gonza\Desktop\SQL-Server-Course-II-2023\practical-work\dataset\Sedes.csv"

exec archivos.importarPacientesCSV
    @rutaArchivo = 
    "C:\Users\gonza\Desktop\SQL-Server-Course-II-2023\practical-work\dataset\Pacientes.csv"
*/

insert into datos.coberturas
(id_prestador, imagen_credencial, nro_socio)
VALUES(1, null, 137)

select * from 
datos.pacientes
where id_paciente = 137

update datos.pacientes 
set id_cobertura = 1
where id_paciente = 137

select * from datos.reservas_turnos_medicos;

delete from datos.prestadores
where id_prestador = 1