program ej5;
uses crt;
const
	fin = 'fin';
type
	celular = record
		cod:integer;
		sm:integer;
		sdis:integer;
		nom:string[30];
		mar:string[30];
		pre:string[30]; //real
		desc:string[30];
	end;
	archivo = file of celular;

procedure listarCelular(c: celular);
begin
	with c do
		writeln('Codigo: ', cod, ' |Nombre: ', nom, ' |Stock Minimo: ', sm, ' |Stock Disponible: ', sdis, ' |Marca:', mar, ' |Precio: $', pre, ' |Descripcion: ', desc);
end;

procedure Leer(var c:celular);
begin
	with c do begin
		writeln('Ingresar nombre del celular'); readln(nom);
		if(nom <> fin) then begin
			writeln('Ingresar codigo del celular'); readln(cod);
			writeln('Ingresar stock minimo del celular'); readln(sm);
			writeln('Ingresar stock disponible del celular'); readln(sdis);
			writeln('Ingresar marca del celular'); readln(mar);
			writeln('Ingresar precio del celular'); readln(pre);
			writeln('Ingresar descripcion del celular'); readln(desc);
		end;
	end;
end;

procedure imprimir(var a:archivo);
var aux:celular;
begin
	reset(a);
	while not eof(a) do begin
		read(a, aux);
		listarCelular(aux);
	end;
	close(a);
end;

//5A - Crear archivo y cargarlo con datos ingresados de 'celulares.txt'
procedure cargarArchivo(var a:archivo; var c:text);
var cel:celular;
begin
	reset(c); //abro archivo para leer
	rewrite(a); //creo archivo a
	while not eof(c) do begin
		with cel do begin
			readln(c, cod);
			readln(c, pre);
			readln(c, mar);
			readln(c, nom);
			readln(c, sdis);
			readln(c, sm);
			readln(c, desc); //leo datos del archivo de texto
		end;
		write(a, cel); //los guardo en el archivo binario
	end;
	close(c);
	close(a);
	writeln('Archivo cargado');
	writeln('----------------------------------------------------');
end;

//5B - imprimir celulares con menos stock del minimo
procedure stockMenor(var a:archivo);
var c:celular;
begin
	reset(a);
	while not eof(a) do begin
		read(a,c);
		if (c.sdis < c.sm) then
			listarCelular(c);
	end;
end;

//5C - listar celulares cuya descripcion fue dada por el usuario
//??

//5D - exportar el archivo a texto
procedure exportar(var a:archivo; var texto:text);
var
	cel: celular;
begin
	rewrite(texto); //abro archivo de texto para crearlo
	reset(a);	//abro archivo para modificarlo
	while not eof(a) do begin
		read(a, cel);
		with cel do
			writeln(texto, cod, ' ', nom, ' ', sm, ' ', sdis, ' ', mar, ' ', pre, ' ', desc); //guardo en el archivo texto los datos
	end;	//al escribir en archivos texto, los tipos se pasan, todos, automaticamente a string
	close(a);
	close(texto);
end;

//6A - anadir uno o más cel al final del archivo
procedure agregar(var a:archivo);
var x:celular;
begin
	reset(a);
	seek(a, filesize(a)); //posiciono puntero al final del archivo
	writeln('Ingresando celular para agregar al final...');
	Leer(x);
	while (x.nom <> fin) do begin
		write(a, x); //se agrega un dato al archivo
		writeln('Ingresando otro celular para agregar al final...');
		Leer(x);
	end;
	close(a);
end;

//6B - modificar stock
procedure actualizar(var a:archivo); //NOTA: Las búsquedas deben nombre de celular.
var x:celular; nom:string[30];	//NO ESTÁ ORDENADO
begin
	reset(a);
	writeln('Ingresar el nombre del celular al que le desea modificar el stock disponible | fin para terminar');
	read(nom);
	while(not eof(a) AND (nom <> fin)) do begin //modifico hasta que el usuario ingrese fin
		//seek(a, 0);
		read(a, x);
		while (not eof(a) AND (nom <> x.nom)) do
			read(a, x); //mientras no encuentre el dato al que debo modificar, recorro
		if (x.nom = nom) then begin //si lo encontré, modifico
			listarCelular(x);
			writeln('Ingrese el nuevo stock: ');
			readln(x.sdis);
			seek(a, filepos(a)-1); //voy a la pos del archivo que leí
			write(a, x); //y modifico
		end;
		writeln('Ingresar el nombre del celular al que le desea modificar el stock disponible | fin para terminar');
		read(nom);
	end;
	close(a);
end;

//6C - exportar el contenido a archivo de texto sin stock
procedure exportar6(var a:archivo; var texto:text);
var
	cel: celular;
begin
	rewrite(texto); //abro archivo de texto para crearlo
	reset(a);	//abro archivo para modificarlo
	while not eof(a) do begin
		read(a, cel);
		if (cel.sdis = 0) then
			with cel do
				writeln(texto, ' ', cod, ' ', nom, ' ', sm, ' ', sdis, ' ', mar, ' ', pre, ' ', desc);
	end;	//al escribir en archivos texto, los tipos se pasan, todos, automaticamente a string
	close(a);
	close(texto);
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
		writeln('0 - Listar en pantalla todos los datos del archivo');
		writeln('1 - Listar en pantalla celulares con stock menor al minimo');
		writeln('2 - Listar celulares con descipcion proporcionada por el usuario');
		writeln('3 - Exportar archivo generado en 1 a archivo de texto');
		writeln('4 - Anadir uno o mas celulares al final del archivo (ingresar fin en nombre para terminar)');
		writeln('5 - Modificar stock de un celular');
		writeln('6 - Exportar celulares con stock 0 a archivo de texto');
		write('Ingrese la opcion: '); readln(opc);
	until((opc >=0)and(opc <=6));
	opcionDos:=opc;
end;

//PP
var a:archivo;
	opc: byte;
	nombreFisico: string[30];
	c, texto: text;
begin
	writeln('CELULARES');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		writeln('Ingrese el nombre del archivo'); readln(nombreFisico);
		Assign(a, nombreFisico);
		Assign(c, 'celulares.txt');
		repeat
			case opc of
				1: cargarArchivo(a, c);
				2: begin
					writeln('----------------------------------------------------');
					opc:= opcionDos();
					case opc of
						0: imprimir(a);
						1: stockMenor(a);
						2: writeln('todfavía no lo sé');
						3: begin
							Assign(texto, 'celular.txt');
							exportar(a, texto);
						end;
						4: agregar(a);
						5: actualizar(a);
						6:begin
							Assign(texto, 'SinStock.txt');
							exportar6(a, texto);
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


{5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
	a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares, deben contener: código de celular, el nombre,
descripción, marca, precio, stock mínimo y el stock disponible.
	b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
	c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
	d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celular.txt” con todos los celulares del mismo.
!NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario
una única vez.
!NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
dos líneas consecutivas: en la primera se especifica: código de celular, el precio, marca
y nombre, y en la segunda el stock disponible, stock mínimo y la descripción, en ese
orden. Cada celular se carga leyendo dos líneas del archivo “carga.txt”.

6. Agregar al menú del programa del ejercicio 5, opciones para:
	a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.
	b. Modificar el stock de un celular dado.
	c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
!NOTA: Las búsquedas deben realizarse por nombre de celular.


* }
