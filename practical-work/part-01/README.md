# Trabajo Práctico Integrador – Unidad I (parte II)

- Grupo: 2
- Materia: Bases de Datos Aplicadas
- Integrantes:
  - Alexis Ezequiel Castillo
  - Gonzalo Ezequiel Sosa
  - Lucas Ariel Clivio
  - Lucas Nahuel Hoz
- Fecha de entrega [TODO]

## Consigna

Luego de decidirse por un motor de base de datos relacional (le recomendamos SQL Server para
aplicar lo que se verá en la unidad 3, pero pueden escoger otro siempre que sea relacional si lo
desean), llegó el momento de generar la base de datos.

Deberá instalar el DMBS y documentar el proceso. No incluya capturas de pantalla. Detalle las
configuraciones aplicadas (ubicación de archivos, memoria asignada, seguridad, puertos, etc.)
en un documento como el que le entregaría al DBA.

Cree la base de datos, entidades y relaciones. Incluya restricciones y claves. Deberá entregar un
archivo .sql con el script completo de creación (debe funcionar si se lo ejecuta “tal cual” es
entregado). Incluya comentarios para indicar qué hace cada módulo de código.

Genere store procedures para manejar la inserción, modificado, borrado (si corresponde,
también debe decidir si determinadas entidades solo admitirán borrado lógico) de cada tabla.

Los nombres de los store procedures NO deben comenzar con “SP”. Genere esquemas para
organizar de forma lógica los componentes del sistema y aplique esto en la creación de objetos.
NO use el esquema “dbo”.

El archivo .sql con el script debe incluir comentarios donde consten este enunciado, la fecha de
entrega, número de grupo, nombre de la materia, nombres y DNI de los alumnos.

Se presenta un modelo de base de datos a implementar por el hospital Cure SA, para la reserva
de turnos médicos y la visualización de estudios clínicos realizados. El modelo es el siguiente:

![](./../../.github/der.png)

Para facilitar la lectura del diagrama se informa la identificación de la cardinalidad en las
relaciones

![](./../../.github/cardinality-identification.png)

### Aclaraciones:

El modelo es el esquema inicial, en caso de ser necesario agregue las relaciones/entidades que
sean convenientes.

Los turnos para estudios clínicos no se encuentran dentro del alcance del desarrollo del
sistema actual.

Los estudios clínicos son ingresados al sistema por el técnico encargado de realizar el estudio,
una vez finalizado el estudio (en el caso de las imágenes) y en el caso de los laboratorios cuando
el mismo se encuentre terminado.

Los turnos para atención médica tienen como estado inicial disponible, según el médico, la
especialidad y la sede.

Los prestadores están conformador por Obras Sociales y Prepagas con las cuales se establece
una alianza comercial. Dicha alianza puede finalizar en cualquier momento, por lo cual debe
poder ser actualizable de forma inmediata si el contrato no está vigente. En caso de no estar
vigente el contrato, deben ser anulados todos los turnos de pacientes que se encuentren
vinculados a esa prestadora y pasar a estado disponible.

Los estudios clínicos deben ser autorizados, e indicar si se cubre el costo completo del mismo o
solo un porcentaje. El sistema de Cure se comunica con el servicio de la prestadora, se le envía
el código del estudio, el dni del paciente y el plan; el sistema de la prestadora informa si está
autorizado o no y el importe a facturarle al paciente.

Los roles establecidos al inicio del proyecto son:

- Paciente
- Médico
- Personal Administrativo
- Personal Técnico Clínico
- Administrador General

> El usuario web se define utilizando el DNI
