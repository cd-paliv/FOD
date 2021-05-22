program ej3;
uses crt;
const
	fin = 'fin';
type
	empleado= record
		nro:integer;
		ape:string[25];
		nom: string[25];
		edad:integer;
		DNI:string[10];
	end;
	archivo= file of empleado;


procedure listarEmpleado(e:empleado);
begin
	with e do begin
		writeln('Apellido: ', ape, ' |Nombre: ', nom, ' |Numero de empleado: ', nro, ' |Edad: ', edad, ' |DNI: ', dni);
	end;
end;


procedure Leer(var a:empleado);
begin
	writeln('Ingresar apellido del empleado');
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
	Leer(e);
	while (e.ape <> fin) do begin
		write(a, e); //guardo el empleado en el archivo
		Leer(e);
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
	Leer(e);
	while (e.ape <> fin) do begin
		write(a, e); //se agrega un empleado al archivo
		writeln('- Ingresar otro empleado para agregar al final');
		Leer(e);
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

function opcionDos():integer; //si elijen trabajar con el archivo generado,
var opc: integeR;				//les hago elegir entre las opciones
begin
	repeat
		writeln('1 - Listar en pantalla empleados con apellido o nombre determinado');
		writeln('2 - Listar todos los empleados');
		writeln('3 - Listar empleados con edades tal'); 
		writeln('4 - Anadir uno o mas empleados al final del archivo (ingresar fin en apellido para terminar)');
		writeln('5 - Modificar la edad de uno o mas empleados');
		writeln('6 - Exportar archivo binario a un archivo de texto llamado todos_empleados.txt');
		writeln('7 - Exportar a un archivo de texto los empleados sin DNI');
		write('Ingrese la opcion: '); readln(opc);
	until((opc >=1)and(opc <=7));
	opcionDos:=opc;
end;



//pp
var a:archivo;
	opc:byte; 
	nombreFisico:string[30];
	texto: text;
begin
	writeln('EMPLEADOS');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		writeln('Ingrese el nombre del archivo'); readln(nombreFisico); //Página 28 del libro: "la asignación nom_lógico-nom:físico debe resolverse en el cuerpo del programa principal
		Assign(a, nombreFisico);
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
					end;
					writeln('----------------------------------------------------');
				end;
			end;
			opc:=opcion();
		until(opc = 0);
	end;
	if (opc = 0) then begin
		writeln('Eligio opcion 0 - Terminando programa...');
		delay (1000);
	end;
end.
