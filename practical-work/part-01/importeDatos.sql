USE cure_sa;

EXEC [archivos].[importarMedicosCSV]
	@rutaArchivo  = 'C:\Users\ariel\Documents\Dataset\Medicos.csv',
	@separador = ';';

EXEC [archivos].[importarPrestadoresCSV]
	@rutaArchivo  = 'C:\Users\ariel\Documents\Dataset\Prestador.csv',
	@separador = ';'

EXEC [archivos].[importarPacientesCSV]
	@rutaArchivo = 'C:\Users\ariel\Documents\Dataset\Pacientes.csv',
	@separador = ';'


EXEC [archivos].[importarSedesCSV]
	@rutaArchivo = 'C:\Users\ariel\Documents\Dataset\Sedes.csv',
	@separador = ';';

--------------------- TESTS ------------------------
/*
SELECT id_medico,apellido, m.nombre, e.nombre AS especialidad , nro_matricula 
FROM datos.medicos AS m
JOIN datos.especialidad AS e ON m.id_especialidad = e.id_especialidad ;

SELECT * FROM datos.prestadores;

SELECT TOP(20) * FROM datos.sede_de_atencion;

SELECT TOP(20) p.nombre , p.apellido, p.email, g.nombre as genero, p.tel_fijo as telefono, n.nombre as nacionalidad
FROM datos.pacientes as p
JOIN referencias.generos as g ON p.id_genero = g.id_genero
JOIN referencias.nacionalidades as n on n.id_nacionalidad = p.nacionalidad;

select  * from datos.pacientes;

SELECT * FROM referencias.direcciones;

*/