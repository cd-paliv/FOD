{	10. Se tiene información en un archivo de las horas extras realizadas por los empleados de una
empresa en un mes. Para cada empleado se tiene la siguiente información: departamento,
división, número de empleado, categoría y cantidad de horas extras realizadas por el
empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por división,
y por último, por número de empleado.
	Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía de 1
a 15. En el archivo de texto debe haber una línea para cada categoría con el número de
categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la posición
del valor coincidente con el número de categoría. }

program ej10;
const
	valoralto = 'zzzz';
	dimF = 15;
type
	rango = 1..dimF;

	empleado = record
		depto: string[25];
		division: string[25];
		numEmpleado: integer;
		categoria: rango;
		cantHorasExtra: integer;
	end;
	archivo = file of empleado;

	vecHorasExtra = array [rango] of real;

//cargo archivo
procedure cargarArchivo(var a:archivo; var t: text);
var aux: empleado;
begin
	reset(t); //abro
	rewrite(a); //creo
	while not eof(t) do begin
		with aux do begin
			readln(t, numEmpleado, categoria, depto);
			readln(t, cantHorasExtra, division);
		end;
		write(a, aux); //los guardo en el archivo binario
	end;
	close(t);
	close(a);
	writeln('Archivo detalle cargado');
	writeln('----------------------------------------------------');
end;

//cargo vector
procedure cargarVectorHoras(var v: vecHorasExtra; var t: text);
var categoria:rango; valor:real;
begin
	reset(t); //abro
	while not eof(t) do begin
		readln(t, categoria, valor);
		v[categoria]:= valor;
	end;
	close(t);
end;

//imprimir info
procedure leer(var a:archivo; var dato:empleado);
begin
	if not eof(a) then read(a, dato)
	else dato.depto := valoralto;
end;

procedure listarTotales (var a:archivo; vector:vecHorasExtra);
var reg: empleado;
	totDepto, totDiv: integer;
	codDepto, codDiv: string[25];
	montoDiv, montoDepto: real;
begin
	reset(a);
	leer(a, reg);
	while (reg.depto <> valoralto) do begin
		writeln('----------------------------------------------------');
		writeln('Departamento: ', reg.depto);
		codDepto:= reg.depto;
		totDepto:= 0;
		montoDepto:= 0;
		while (codDepto = reg.depto) do begin
			writeln(' ');
			writeln('Division: ', reg.division);
			codDiv := reg.division;
			totDiv:= 0;
			montoDiv:= 0;
			while (codDiv = reg.division) AND (codDepto = reg.depto) do begin
				write('Empleado: ', reg.numEmpleado, ' - ');
				write(reg.cantHorasExtra);
				writeln('hs - A cobrar: $', (reg.cantHorasExtra * vector[reg.categoria]):2:2);
				totDiv += reg.cantHorasExtra; //calculo cant de horas por division
				montoDiv += reg.cantHorasExtra * vector[reg.categoria]; //calculo monto total por division
				leer(a, reg);
			end;
			writeln('Total de horas division: ', totDiv, 'hs');
			writeln('Monto total por division: $', montoDiv:2:2);
			totDepto += totDiv;
			montoDepto += montoDiv;
		end;
		writeln(' ');
		writeln('Total de horas departamento: ', totDepto, 'hs');
		writeln('Monto total por departamento: $', montoDepto:2:2);
	end;
	writeln('----------------------------------------------------');
	close(a);
end;

//opciones del usuario
function opcion(): integer;
var opc:integer;
begin
	repeat
		writeln('0 - Terminar el programa');
		writeln('1 - Cargar archivos');
		writeln('2 - Imprimir datos');
		write('Ingrese la opcion: '); readln(opc);
	until ((opc >= 0) AND (opc <= 2));
	opcion:=opc;
end;

//PP
var a: archivo;
	opc: byte;
	texto: text;
	vHorasExtra: vecHorasExtra;
begin
	writeln('EMPLEADOS');
	writeln();
	Assign(texto, 'horas extra.txt');
	cargarVectorHoras(vHorasExtra, texto);
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		repeat
			case opc of
				1: begin
					Assign(a, 'datos');
					Assign(texto, 'datos.txt');
					cargarArchivo(a, texto);
				end;
				2: listarTotales(a, vHorasExtra);
			end;
			opc:=opcion();
		until(opc = 0);
	end;
end.
