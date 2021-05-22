{15. En la facultad de Ciencias Jurídicas existe un sistema a través del cual los alumnos del
posgrado tienen la posibilidad de pagar las carreras en RapiPago. Cuando el alumno se
inscribe a una carrera, se le imprime una chequera con seis códigos de barra para que pague
las seis cuotas correspondientes. Existe un archivo que guarda la siguiente información de los
alumnos inscriptos: dni_alumno, codigo_carrera y monto_total_pagado.
Todos los días RapiPago manda N archivos con información de los pagos realizados por los
alumnos en las N sucursales. Cada sucursal puede registrar cero, uno o más pagos y un
alumno puede pagar más de una cuota el mismo día. Los archivos que manda RapiPago tienen
la siguiente información: dni_alumno, codigo_carrera, monto_cuota.}

program ej15;
const
	valoralto = 9999;
	
type
	alumnos = record
		dni_alumno: long;
		codigo_carrera: integer;
		monto_total_pagado: real;
	end;
	maestro = file of alumnos;

	pagos = record
		dni_alumno: long;
		codigo_carrera: integer;
		monto_cuota: real;
	end;
	detalle = file of pagos;
	cuotas = array [1..6] of real;
