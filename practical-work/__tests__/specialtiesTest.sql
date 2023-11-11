use CURESA;

declare @nombre varchar(50) = 'odontologia   ';
declare @outIdEspecialidad int;
declare @outNombre varchar(50);

exec datos.actualizarEspecialidad @nombre, @outIdEspecialidad out ,@outNombre output
	
PRINT 'id especialidad: ' + ISNULL(CONVERT(VARCHAR, @outIdEspecialidad), 'NULL');
PRINT 'nombre especialidad: ' + ISNULL(@outNombre, 'NULL');

SET @outIdEspecialidad = datos.obtenerIdEspecialidad(@nombre);

PRINT 'id especialidad: ' + ISNULL(CONVERT(VARCHAR, @outIdEspecialidad), 'NULL');


use master;


/*
use CURESA;
select * from datos.especialidad;
*/