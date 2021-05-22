{1. Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados.}

program ej1;
const
	fin = 'fin';
	valoralto = 9999;
type
	empleado= record
		nro:integer;
		ape:string[25];
		nom: string[25];
		edad:integer;
		DNI:string[10];
	end;
	archivo= file of empleado;

//----------------------------EJERCICIO 3y4 PRACTICA 1-------------------------
{imprimir empleado}
procedure listarEmpleado(e:empleado);
begin
	with e do begin
		writeln('Apellido: ', ape, ' |Nombre: ', nom, ' |Numero de empleado: ', nro, ' |Edad: ', edad, ' |DNI: ', dni);
	end;
end;
{leer los datos de los empleados}
procedure LeerD(var a:empleado);
begin
	writeln('Ingresar apellido del empleado - fin para finalizar');
	readln();
	read(a.ape);
	if (a.ape <> fin) then begin
		writeln('Ingresar nombre del empleado');
		readln();
		read(a.nom);
		writeln('Ingresar nro de empleado');
		readln(a.nro);
		writeln('Ingresar edad del empleado');
		readln(a.edad);
		writeln('Ingresar DNI del empleado');
		read(a.dni);
	end;
end;

procedure crearArchivo(var a:archivo);
var e:empleado;
begin
	rewrite(a); //abro para crear archivo
	writeln('----------------------------------------------------');
	LeerD(e);
	while (e.ape <> fin) do begin
		write(a, e); //guardo el empleado en el archivo
		LeerD(e);
	end;
	close(a); //cierro archivo
end;

//el nom_lógico de un archivo siempre representa un nexo con el nom_físico.
//por ende, es necesario pasarlo siempre por referencia, aunque no se modifique

//b i
procedure recorridoayp(var a:archivo); //imprimir todos con nombre x
var e:empleado; x:string[25];
begin
	writeln('Ingrese nombre o apellido');
	readln(x);
	reset(a);
	while not eof(a) do begin
		read(a, e);
		if (e.ape = x) or (e.nom = x) then //si el nombre es x me sirve y si el apellido es x tambien xd
			listarEmpleado(e);
	end;
	close(a);
end;

//b ii
procedure recorrido(var a:archivo); //imprimir todos
var e:empleado;
begin
	reset(a);
	while not eof(a) do begin
		write('!Empleado - ');
		read(a, e);
		listarEmpleado(e);
	end;
	close(a);
end;

//b iii
procedure recorrido70(var a:archivo); //imprimir mayores a 70 años
var e:empleado;
begin
	reset(a);
	while not eof(a) do begin
		read(a, e);
		if (e.edad > 70) then begin
			listarEmpleado(e);
		end;
	end;
	close(a);
end;

//4a
procedure agregar(var a:archivo);
var e:empleado;
begin
	reset(a);
	seek(a, filesize(a)); //posiciono puntero al final del archivo
	writeln('- Ingresar empleado para agregar al final');
	LeerD(e);
	while (e.ape <> fin) do begin
		write(a, e); //se agrega un empleado al archivo
		writeln('- Ingresar otro empleado para agregar al final');
		LeerD(e);
	end;
	close(a);
end;

//4b
procedure actualizar(var a:archivo); //NOTA: Las búsquedas deben realizarse por número de empleado.
var e:empleado; nro:integer;	//NO ESTÁ ORDENADO
begin
	reset(a);
	writeln('Ingresar el numero de empleado al que le desea modificar la edad | -1 para terminar');
	read(nro);
	while(not eof(a) AND (nro <> -1)) do begin //modifico hasta que el usuario ingrese -1
		read(a, e);
		while (not eof(a) AND (e.nro <> nro)) do
			read(a, e); //mientras no encuentre el empleado al que debo cambiar la edad, recorro
		if (e.nro = nro) then begin //si lo encontré, modifico la edad
			listarEmpleado(e);
			writeln('Ingrese la nueva edad: ');
			readln(e.edad);
			//e.edad:= edad;
			seek(a, filepos(a)-1); //voy a la pos del archivo que leí
			write(a, e); //y modifico la edad
		end;
		writeln('Ingresar el numero de empleado al que le desea modificar la edad | -1 para terminar)');
		read(nro);
	end;
	close(a);
end;

//4c
procedure exportar(var a:archivo; var texto:text);
var
	e:empleado;
begin
	rewrite(texto); //abro archivo de texto para crearlo
	reset(a);	//abro archivo para modificarlo
	while not eof(a) do begin
		read(a, e);
		with e do
			writeln(texto, nro, ' ', ape, ' ', nom, ' ', dni, ' ', edad); //guardo en el archivo texto los datos
	end;	//al escribir en archivos texto, los tipos se pasan, todos, automaticamente a string
	close(a);
	close(texto);
end;

//4d
procedure exportarDNI(var a:archivo; var texto:text);
var
	e:empleado;
begin
	Assign(texto, 'faltaDNIEmpleado.txt');
	rewrite(texto);
	reset(a);
	while not eof(a) do begin
		read(a, e);
		with e do begin
			if (e.dni = '00') then
				writeln(texto, nro, ' ', ape, ' ', nom, ' ', dni, ' ', edad);
		end;
	end;
	close(a);
	close(texto);
end;

//-------------------------------EJERCICIO 1----------------------------------
procedure leer(var a:archivo; var dato: empleado);
begin
	if not eof(a) then read(a, dato)
	else dato.nro := valoralto;
end;

procedure realizarBaja(var a: archivo);
var	nro, pos: integer;
	reg: empleado;
begin
	reset(a);
	writeln('BAJA DE UN EMPLEADO');
	write('Ingrese nro de empleado: '); readln(nro);
	leer(a, reg);
	while(reg.nro <> valoralto) AND (reg.nro <> nro) do //busco el empleado
		leer(a, reg);
	if(reg.nro = nro) then begin
		pos:= filepos(a)-1;
		seek(a, filesize(a)-1); //voy al ult reg del archivo
		read(a, reg); //lo leo
		seek(a, pos); //vuelvo al registro que quiero borrar
		write(a, reg);
		seek(a, filesize(a)-1); //hago truncate al ult elemento para reposicionar eof
		truncate(a);
		writeln('Baja exitosa');
	end
	else writeln('El empleado no se encuentra en el archivo');
	close(a);
end;

//funciones que le muestran al usuario sus opciones a elegir
function opcion():integer; // inicial
var opc: integeR;
begin
	repeat
		writeln('0 - Terminar el programa');
		writeln('1 - Crear archivo');
		writeln('2 - Trabajar con archivo generado');
		write('Ingrese la opcion: '); readln(opc);
	until ((opc >= 0) AND (opc <= 2));
	opcion:=opc;
end;

function opcionDos():integer; //si elijen trabajar con el archivo generado
var opc: integeR;
begin
	repeat
		writeln('1 - Listar en pantalla empleados con apellido o nombre determinado');
		writeln('2 - Listar todos los empleados');
		writeln('3 - Listar empleados con edades tal'); 
		writeln('4 - Anadir uno o mas empleados al final del archivo (ingresar fin en apellido para terminar)');
		writeln('5 - Modificar la edad de uno o mas empleados');
		writeln('6 - Exportar archivo binario a un archivo de texto llamado todos_empleados.txt');
		writeln('7 - Exportar a un archivo de texto los empleados sin DNI');
		writeln('8 - Realizar la baja de un empleado');
		write('Ingrese la opcion: '); readln(opc);
	until((opc >= 1) AND (opc <= 8));
	opcionDos:=opc;
end;


//pp
var a:archivo;
	opc:byte;
	texto: text;
begin
	writeln('EMPLEADOS');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		Assign(a, 'maestr0');
		repeat
			case opc of
				1: crearArchivo(a); //3a
				2: begin
					writeln('----------------------------------------------------');
					opc:= opcionDos();
					case opc of
						1: recorridoayp(a); //3bi
						2: recorrido(a); //3bii
						3: recorrido70(a); //3biii
						4: agregar(a); //4a
						5: actualizar(a); //4b
						6: begin
							Assign(texto, 'todos_empleados.txt');
							exportar(a, texto); //4c
						end;
						7: begin
							Assign(texto, 'todos_empleados.txt');
							exportarDNI(a, texto); //4d
						end;
						8: realizarBaja(a);
					end;
					writeln('----------------------------------------------------');
				end;
			end;
			opc:=opcion();
		until(opc = 0);
	end;
	if (opc = 0) then writeln('Eligio opcion 0 - Terminando programa...');
end.
