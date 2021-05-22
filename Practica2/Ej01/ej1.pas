{1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes empleados en concepto de comisión, 
de cada uno de ellos se conoce: código de empleado, nombre y monto de la comisión. 
	La información del archivo se encuentra ordenada por código de empleado y 
cada empleado puede aparecer más de una vez en el archivo de comisiones.
	Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. 
	En consecuencia, deberá generar un nuevo archivo en el cual, 
cada empleado aparezca una única vez con el valor total de sus comisiones.
!NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser recorrido una única vez.
* }

program ej1;
const
	valoralto = 9999;
type
	empleado = record
		cod: integer;
		nom: string[25];
		monto: real;
	end;
	archivo = file of empleado;


procedure listar(x: empleado);
begin
	with x do
		writeln('Codigo: ', cod, ' |Nombre: ', nom, ' |Monto: $', monto:2:2);
end;

procedure imprimir(var a:archivo);
var aux:empleado;
begin
	reset(a);
	while not eof(a) do begin
		read(a, aux);
		listar(aux);
	end;
	close(a);
end;

//compacto txt con datos de empleados a archivo binario para luego crear el maestro
procedure cargarArchivo(var a:archivo; var t:text);
var aux: empleado;
begin
	reset(t); //abro
	rewrite(a); //creo
	while not eof(t) do begin
		with aux do readln(t, cod, monto, nom);
		write(a, aux); //los guardo en el archivo binario
	end;
	close(t);
	close(a);
	writeln('Archivo cargado');
	writeln('----------------------------------------------------');
end;

//1
procedure leer(var a:archivo; var dato:empleado);
begin
	if not eof(a) then read(a, dato)
	else dato.cod := valoralto;
end;

procedure maestro(var mae: archivo; var det: archivo);
var actual, regd: empleado;
begin
	rewrite(mae); //creo
	reset(det); //abro
	leer(det, regd);
	while (regd.cod <> valoralto) do begin
		actual:= regd;
		actual.monto := 0;
		while (actual.cod = regd.cod) do begin
			actual.monto += regd.monto;
			leer(det, regd);
		end;
		//seek(mae, filepos(mae)-1);
		write(mae, actual);
	end;
	close(det);
	close(mae);
	writeln('Archivo cargado');
	writeln('----------------------------------------------------');
end;

//opciones de usuario
function opcion(): integer;
var opc:integer;
begin
	repeat
		writeln('0 - Terminar el programa');
		writeln('1 - Crear archivo binario');
		writeln('2 - Trabajar con archivo creado');
		write('Ingrese la opcion: '); readln(opc);
	until ((opc >= 0) AND (opc <= 2));
	opcion:=opc;
end;

function opcionDos():integer;
var opc:integer;
begin
	repeat
		writeln('1 - Crear un archivo en el que cada empleado aparezca una unica vez con el valor total de sus comisiones');
		writeln('2 - Listar en pantalla todos los datos del archivo');
		write('Ingrese la opcion: '); readln(opc);
	until((opc >= 1) AND (opc <= 2));
	opcionDos:=opc;
end;

//PP
var
	mae1, det1: archivo;
	t: text;
	opc: byte;
	nombreFisico: string[25];
begin
	writeln('EMPLEADOS');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		writeln('Ingrese el nombre del archivo'); readln(nombreFisico);
		Assign(mae1, nombreFisico);
		Assign(t, 'empleados.txt');
		Assign(det1, 'empleados');
		repeat
			case opc of
				1: cargarArchivo(det1, t);
				2: begin
					writeln('----------------------------------------------------');
					opc:= opcionDos();
					case opc of
						1: maestro(mae1, det1);
						2: begin
							writeln('----------------------------------------------------');
							writeln('Archivo a compactar:');
							writeln();
							imprimir(det1);
							writeln();
							writeln('Archivo compactado:');
							writeln();
							imprimir(mae1);
							writeln();
							writeln('----------------------------------------------------');
						end;
					end;
				end;
			end;
			opc:= opcion();
		until(opc = 0);
	end;
end.
