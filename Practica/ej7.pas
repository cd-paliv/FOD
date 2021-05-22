{7. Realizar un programa que permita:
	a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
El nombre del archivo de texto es: “novelas.txt”
	b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
una novela y modificar una existente. Las búsquedas se realizan por código de novela.
!NOTA: La información en el archivo de texto consiste en: código de novela,
nombre,género y precio de diferentes novelas argentinas. De cada novela se almacena la
información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
información: código novela, precio, y género, y la segunda línea almacenará el nombre
de la novela.

* }

program ej7;
uses crt;
type
	novela = record
		cod: integer;
		nom:string[25];
		gen:string[25];
		pre: string[25];
	end;
	archivo = file of novela;

procedure listar(x: novela);
begin
	with x do
		writeln('Codigo: ', cod, ' |Nombre: ', nom, ' |Genero: ', gen, ' |Precio $', pre);
end;

procedure leer(var x: novela);
begin
	with x do begin
		writeln('Ingresar nombre de la novela'); readln(nom);
		if (nom <> 'fin') then begin
			writeln('Ingresar codigo de la novela'); readln(cod);
			writeln('Ingresar genero de la novela'); readln(gen);
			writeln('Ingresar precio de la novela'); readln(pre);
		end;
	end;
end;

procedure imprimir(var a:archivo);
var aux:novela;
begin
	reset(a);
	while not eof(a) do begin
		read(a, aux);
		listar(aux);
	end;
	close(a);
end;

procedure cargarArchivo(var a:archivo; var c:text);
var aux: novela;
begin
	reset(c);
	rewrite(a);
	while not eof(c) do begin
		with aux do begin
			readln(c, cod);
			readln(c, nom);
			readln(c, gen);
			readln(c, pre);
		end;
		write(a, aux); //los guardo en el archivo binario
	end;
	close(c);
	close(a);
	writeln('Archivo cargado');
	writeln('----------------------------------------------------');
end;

//Agregar datos al final del archivo
procedure agregar(var a:archivo);
var x:novela;
begin
	reset(a);
	seek(a, filesize(a)); //posiciono puntero al final del archivo
	writeln('Ingresando datos para agregar al final...');
	leer(x);
	while (x.nom <> 'fin') do begin
		write(a, x); //se agrega un dato al archivo
		writeln('Ingresando otro dato para agregar al final...');
		leer(x);
	end;
	close(a);
end;

//modificar
procedure actualizar(var a:archivo; opc:byte); //NOTA: Las búsquedas deben nombre de celular.
var x:novela; cod:integer;	//NO ESTÁ ORDENADO
begin
	reset(a);
	writeln('Ingresar el codigo del dato que desea modificar | -1 para terminar');
	readln(cod);
	while(not eof(a) AND (cod <> -1)) do begin //modifico hasta que el usuario decida
		read(a, x);
		while (not eof(a) AND (cod <> x.cod)) do
			read(a, x); //mientras no encuentre el dato al que debo modificar, recorro
		if (x.cod = cod) then begin //si lo encontré, modifico
			listar(x);
			writeln('Ingrese el nuevo dato: ');
			case opc of
				1: readln(x.cod); //no se debería poder modificar el código
				2: readln(x.nom);
				3: readln(x.gen);
				4: readln(x.pre);
			end;
			seek(a, filepos(a)-1); //voy a la pos del archivo que leí
			write(a, x); //y modifico la edad
		end;
		writeln('Ingresar el codigo del dato que desea modificar | -1 para terminar');
		readln(cod);
	end;
	close(a);
end;



//opciones del usuario
function opcion(): integer;
var opc:integer;
begin
	repeat
		writeln('0 - Terminar el programa');
		writeln('1 - Crear archivo');
		writeln('2 - Trabajar con archivo generado');
		write('Ingrese la opcion: '); readln(opc);
	until ((opc >= 0) AND (opc <= 2));
	opcion:=opc;
end;

function opcionDos():integer;
var opc:integer;
begin
	repeat
		writeln('1 - Listar en pantalla todos los datos del archivo');
		writeln('2 - Modificar una novela');
		writeln('3 - Agregar una novela al final del archivo');
		write('Ingrese la opcion: '); readln(opc);
	until((opc >= 1) AND (opc <= 3));
	opcionDos:=opc;
end;

function opcionTres():integer;
var opc:integer;
begin
	repeat
		writeln('1 - Modificar codigo de novela');
		writeln('2 - Modificar nombre de novela');
		writeln('3 - Modificar genero de novela');
		writeln('4 - Modificar precio de novela');
		write('Ingrese la opcion: '); readln(opc);
	until((opc >= 1) AND (opc <= 4));
	opcionTres:=opc;
end;

var a:archivo;
	opc: byte;
	nombreFisico: string[30];
	c: text;
begin
	writeln('NOVELAS');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		writeln('Ingrese el nombre del archivo'); readln(nombreFisico);
		Assign(a, nombreFisico);
		Assign(c, 'novelas.txt');
		repeat
			case opc of
				1: cargarArchivo(a, c);
				2: begin
					writeln('----------------------------------------------------');
					opc:= opcionDos();
					case opc of
						1: imprimir(a);
						2: begin
							writeln('----------------------------------------------------');
							opc:= opcionTres();
							actualizar(a, opc);
						end;
						3: agregar(a);
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
