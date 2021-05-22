{7. Se cuenta con un archivo que almacena información sobre especies de aves en
vía de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las especies a
eliminar. Deberá realizar todas las declaraciones necesarias, implementar todos los
procedimientos que requiera y una alternativa para borrar los registros. Para ello deberá
implementar dos procedimientos, uno que marque los registros a borrar y posteriormente
otro procedimiento que compacte el archivo, quitando los registros marcados. Para
quitar los registros se deberá copiar el último registro del archivo en la posición del registro
a borrar y luego eliminar del archivo el último registro de forma tal de evitar registros
duplicados.
!Nota: Las bajas deben finalizar al recibir el código 500000}

program ej7;
const
	valoralto = 'zzzz';
type
	ave = record
		cod: integer;
		especie: string[20];
		fam: string[20];
		desc: string[20];
		zona: string[30];
	end;
	archivo = file of ave;

procedure crearArchivo(var a:archivo; var t:text);
var aux: ave;
begin
	reset(t); //abro
	rewrite(a); //creo
	while not eof(t) do begin
		with aux do begin
			readln(t, cod, especie);
			readln(t, fam);
			readln(t, desc);
			readln(t, zona);
		end;
		write(a, aux); //los guardo en el archivo binario
	end;
	close(t);
	close(a);
	writeln('Archivo maestro cargado');
end;

procedure leer(var a:archivo; var dato: ave);
begin
	if not eof(a) then read(a, dato)
	else dato.especie := valoralto;
end;

{eliminar}
procedure darBajaLogica(var a:archivo);
var	reg: ave;
	cod: Longint;
begin
	write('Realizando bajas, ingrese codigo de ave a eliminar (500.000 para finalizar): '); readln(cod);;
	reset(a);
	while (cod <> 500000) do begin //recorro todo el archivo hasta eliminar todas las ocurrencias del reg
		while not eof(a) do begin
			read(a, reg);
			if(reg.cod = cod) then begin
				seek(a, filepos(a) - 1);
				reg.cod:= -1;
				write(a, reg);
			end;
		end;
		seek(a, 0); //voy al principio porque no está ordenado
		write('Siguiendo con bajas, ingrese el codigo de un ave a eliminar: '); readln(cod);
	end;
	close(a);
end;

{compactar}
procedure darBajaFisica(var a:archivo);
var	reg: ave;
	pos, cont, i: integer;
begin
	cont := -1;
	reset(a);
	while not eof(a) do begin
		read(a, reg);
		if(reg.cod = -1) then begin
			pos:= filepos(a) - 1;
			seek(a, filesize(a) -1);
			read(a, reg);
			i:= 0;
			while(reg.cod = -1) do begin
				i += 1;
				seek(a, (filesize(a) -1) - i);
				read(a, reg);
			end;
			seek(a, pos);
			write(a, reg);
			cont += 1;
		end;
	end;
	seek(a, (filesize(a) -1) - cont);
	truncate(a);
	writeln('Archivo compactado');
end;

{verifico info}
procedure imprimir(var a:archivo);
var	reg: ave;
begin
	writeln('----------------------------------------------------');
	reset(a);
	leer(a, reg);
	while(reg.especie <> valoralto) do begin
		
		writeln('Cod: ', reg.cod, ' - Especie: ', reg.especie);
		leer(a, reg);
	end;
	close(a);
end;

//opciones del usuario
function opcion(): integer;
var opc:integer;
begin
	repeat
		writeln('0 - Terminar el programa');
		writeln('1 - Cargar archivo');
		writeln('2 - Manetenimiento del archivo');
		write('Ingrese la opcion: '); readln(opc);
	until ((opc >= 0) AND (opc <= 2));
	opcion:=opc;
end;

function opcionDos():integer;
var opc:integer;
begin
	repeat
		writeln('1 - Dar de baja especies de aves');
		writeln('2 - Compactar archivo');
		writeln('3 - Listar datos en pantalla');
		write('Ingrese la opcion: '); readln(opc);
	until((opc >= 1) AND (opc <= 4));
	opcionDos:=opc;
end;

//PP
var a: archivo;
	opc: byte;
	texto: text;
begin
	writeln('AVES');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		Assign(a, 'infoAves');
		repeat
			case opc of
				1: begin
					Assign(texto, 'infoAves.txt');
					crearArchivo(a, texto);
					writeln('----------------------------------------------------');
				end;
				2: begin
					writeln('----------------------------------------------------');
					opc:= opcionDos();
					case opc of
						1: begin
							writeln('----------------------------------------------------');
							darBajaLogica(a);
						end;
						2: darBajaFisica(a);
						3: imprimir(a);
					end;
					writeln('----------------------------------------------------');
				end;
			end;
			opc:=opcion();
		until(opc = 0);
	end;
end.
