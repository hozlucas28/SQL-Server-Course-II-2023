# Trabajo práctico integrador

- Grupo: 2
- Materia: Bases de Datos Aplicadas
- Integrantes:
  - Alexis Ezequiel Castillo
  - Gonzalo Ezequiel Sosa
  - Lucas Ariel Clivio
  - Lucas Nahuel Hoz
- Fecha de entrega: 14/11/2023

## Primer parte

### Consigna

Luego de decidirse por un motor de base de datos relacional (le recomendamos SQL Server para
aplicar lo que se verá en la unidad 3, pero pueden escoger otro siempre que sea relacional si lo
desean), llegó el momento de generar la base de datos.

Deberá instalar el DMBS y documentar el proceso. No incluya capturas de pantalla. Detalle las
configuraciones aplicadas (ubicación de archivos, memoria asignada, seguridad, puertos, etc.)
en un documento como el que le entregaría al DBA.

Cree la base de datos, entidades y relaciones. Incluya restricciones y claves. Deberá entregar un
archivo .sql con el script completo de creación (debe funcionar si se lo ejecuta “tal cual” es
entregado). Incluya comentarios para indicar qué hace cada módulo de código.

Genere Store Procedures para manejar la inserción, modificado, borrado (si corresponde,
también debe decidir si determinadas entidades solo admitirán borrado lógico) de cada tabla.

Los nombres de los Store Procedures NO deben comenzar con “SP”. Genere esquemas para
organizar de forma lógica los componentes del sistema y aplique esto en la creación de objetos.
NO use el esquema “dbo”.

El archivo .sql con el script debe incluir comentarios donde consten este enunciado, la fecha de
entrega, número de grupo, nombre de la materia, nombres y DNI de los alumnos.

Se presenta un modelo de base de datos a implementar por el hospital Cure SA, para la reserva
de turnos médicos y la visualización de estudios clínicos realizados. El modelo es el siguiente:

![](https://github.com/hozlucas28/SQL-Server-Course-II-2023/blob/Master/.github/der.png?raw=true)

Para facilitar la lectura del diagrama se informa la identificación de la cardinalidad en las
relaciones

![](https://github.com/hozlucas28/SQL-Server-Course-II-2023/blob/Master/.github/cardinality-identification.png?raw=true)

#### Aclaraciones:

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
el código del estudio, el DNI del paciente y el plan; el sistema de la prestadora informa si está
autorizado o no y el importe a facturarle al paciente.

Los roles establecidos al inicio del proyecto son:

- Paciente
- Médico
- Personal Administrativo
- Personal Técnico Clínico
- Administrador General

> El usuario web se define utilizando el DNI

## Segunda parte

Se proveen maestros de Médicos, Pacientes, Prestadores y Sedes en formato CSV. También se
dispone de un archivo JSON que contiene la parametrización del mecanismo de autorización
según estudio y obra social, además de porcentaje cubierto, etc. Ver archivo “Datasets para
importar” en MIeL.

Se requiere que importe toda la información antes mencionada a la base de datos. Genere los
objetos necesarios (Store Procedures, funciones, etc.) para importar los archivos antes
mencionados. Tenga en cuenta que cada mes se recibirán archivos de novedades con la misma
estructura pero datos nuevos para agregar a cada maestro. Considere este comportamiento al
generar el código. Debe admitir la importación de novedades periódicamente.
La estructura/esquema de las tablas a generar será decisión suya. Puede que deba realizar
procesos de transformación sobre los maestros recibidos para adaptarlos a la estructura
requerida.

Los archivos CSV/JSON no deben modificarse. En caso de que haya datos mal cargados,
incompletos, erróneos, etc., deberá contemplarlo y realizar las correcciones en el fuente SQL.
(Sería una excepción si el archivo está malformado y no es posible interpretarlo como JSON o
CSV). Documente las correcciones que haga indicando número de línea, contenido previo y
contenido nuevo. Esto se cotejará para constatar que cumpla correctamente la consigna.
Adicionalmente se requiere que el sistema sea capaz de generar un archivo XML detallando los
turnos atendidos para informar a la Obra Social. El mismo debe constar de los datos del paciente
(Apellido, nombre, DNI), nombre y matrícula del profesional que lo atendió, fecha, hora,
especialidad. Los parámetros de entrada son el nombre de la obra social y un intervalo de fechas.
Deberá presentar un archivo .sql con el script de creación de los objetos correspondientes. En el
mismo incluya un comentario donde conste este enunciado, la fecha de entrega, número de
grupo, nombre de la materia, nombres y DNI de los alumnos. El mismo archivo SQL debe permitir
la generación de los objetos consignados en esta entrega (debe admitir una ejecución completa
sin fallos).
