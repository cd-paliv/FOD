{	Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
	Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:

* }

program ej2;
const
	valoralto = 9999;
type
	alumno = record
		cod: integer;
		ape: string[25];
		nom: string[25];
		cantSF: integer;
		cantF: integer;
	end;
	maestro = file of alumno;
	finalocursada = record
		cod: integer;
		foc: string[15];
	end;
	detalle = file of finalocursada;

//a. Crear el archivo maestro a partir de un archivo de texto llamado “alumnos.txt”
//Todos los archivos están ordenados por código de alumno
procedure cargarArchivoMae(var a:maestro; var t:text);
var aux: alumno;
begin
	reset(t); //abro
	rewrite(a); //creo
	while not eof(t) do begin
		with aux do begin
			readln(t, cod, cantSF, cantF);
			readln(t, ape);
			readln(t, nom);
		end;
		write(a, aux); //los guardo en el archivo binario
	end;
	close(t);
	close(a);
	writeln('Archivo maestro cargado');
	writeln('----------------------------------------------------');
end;

//b. Crear el archivo detalle a partir de en un archivo de texto llamado “detalle.txt”
//en el archivo detalle puede haber 0, 1 ó más registros por cada alumno del archivo maestro
procedure cargarArchivoDet(var a:detalle; var t:text);
var aux: finalocursada;
begin
	reset(t); //abro
	rewrite(a); //creo
	while not eof(t) do begin
		with aux do begin
			readln(t, cod);
			readln(t, foc);
		end;
		write(a, aux); //los guardo en el archivo binario
	end;
	close(t);
	close(a);
	writeln('Archivo detalle cargado');
	writeln('----------------------------------------------------');
end;

//c. Listar el contenido del archivo maestro en un archivo de texto llamado “reporteAlumnos.txt”
procedure exportarMae(var a:maestro; var texto:text);
var
	x: alumno;
begin
	rewrite(texto); //abro archivo de texto para crearlo
	reset(a);	//abro archivo para modificarlo
	while not eof(a) do begin
		read(a, x);
		with x do
			writeln(texto, cod, ' ', ape, ' ', nom, ' ', cantSF, ' ', cantF); //guardo en el archivo texto los datos
	end;	//al escribir en archivos texto, los tipos se pasan, todos, automaticamente a string
	close(a);
	close(texto);
end;

//d. Listar el contenido del archivo detalle en un archivo de texto llamado “reporteDetalle.txt”
procedure exportarDet(var a:detalle; var texto:text);
var
	x: finalocursada;
begin
	rewrite(texto); //abro archivo de texto para crearlo
	reset(a);	//abro archivo para modificarlo
	while not eof(a) do begin
		read(a, x);
		with x do
			writeln(texto, cod, ' ', foc); //guardo en el archivo texto los datos
	end;	//al escribir en archivos texto, los tipos se pasan, todos, automaticamente a string
	close(a);
	close(texto);
end;


{ e. Actualizar el archivo maestro de la siguiente manera:
	i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado
	ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin final}
procedure leer(var a:detalle; var dato:finalocursada);
begin
	if not eof(a) then read(a, dato)
	else dato.cod := valoralto;
end;

procedure maestro1(var mae: maestro; var det: detalle);
var regm: alumno; regd: finalocursada; actual: integer;
begin
	reset(mae); //abro
	reset(det); //abro
	read(mae, regm);
	leer(det, regd);
	while (regd.cod <> valoralto) do begin
		actual:= regd.cod;
		while (actual = regd.cod) do begin //mientras el cod sea el mismo actualizo datos
			if (regd.foc = 'Tiene-final') then regm.cantF += 1
			else regm.cantSF += 1;
			leer(det, regd);
		end;
		while (regm.cod <> actual) do //busco el cod en el maestro
			read(mae, regm);
		seek(mae, filepos(mae)-1);//se asume que SÍ O SÍ se encuentra el cod en mae
		write(mae, regm); //lo actualizo
		if not eof(mae) then read(mae, regm); //avanzo en el maestro
	end;
	close(det);
	close(mae);
	writeln('Archivo actualizado');
end;

//f. Listar en un archivo de texto los alumnos que tengan más de cuatro materias con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
procedure exportarF(var a:maestro; var texto:text);
var
	x: alumno;
begin
	rewrite(texto); //abro archivo de texto para crearlo
	reset(a);	//abro archivo para modificarlo
	while not eof(a) do begin
		read(a, x);
		if (x.cantSF > 4) then
			with x do
				writeln(texto, cod, ' ', ape, ' ', nom, ' ', cantSF, ' ', cantF); //guardo en el archivo texto los datos
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
		writeln('1 - Crear archivo maestro');
		writeln('2 - Crear archivo detalle');
		writeln('3 - Trabajar con archivos generados');
		write('Ingrese la opcion: '); readln(opc);
	until ((opc >= 0) AND (opc <= 3));
	opcion:=opc;
end;

function opcionDos():integer;
var opc:integer;
begin
	repeat
		writeln('1 - Actualizar archivo maestro');
		writeln('2 - Exportar archivo maestro a archivo de texto');
		writeln('3 - Exportar archivo detalle a archivo de texto');
		writeln('4 - Exportar a archivo de texto alumnos con +4 materias sin final');
		write('Ingrese la opcion: '); readln(opc);
	until((opc >= 1) AND (opc <= 4));
	opcionDos:=opc;
end;

//PP
var mae: maestro;
	det: detalle;
	opc: byte;
	nombreFisico: string[30];
	tm, td, tmnuevo, tdnuevo, sinfinal: text;
begin
	writeln('ALUMNOS');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		writeln('Ingrese el nombre del archivo'); readln(nombreFisico);
		Assign(mae, nombreFisico);
		Assign(det, 'detalle.dat');
		repeat
			case opc of
				1: begin
					Assign(tm, 'alumnos.txt');
					cargarArchivoMae(mae, tm);
				end;
				2: begin
					Assign(td, 'detalle.txt');
					cargarArchivoDet(det, td);
				end;
				3: begin
					writeln('----------------------------------------------------');
					opc:= opcionDos();
					case opc of
						1: maestro1(mae, det);
						2: begin
							Assign(tmnuevo, 'reporteAlumnos.txt');
							exportarMae(mae, tmnuevo);
						end;
						3: begin
							Assign(tdnuevo, 'reporteDetalle.txt');
							exportarDet(det, tdnuevo);
						end;
						4: begin
							Assign(sinfinal, 'reporte4Finales.txt');
							exportarF(mae, sinfinal);
						end;
					end;
					writeln('----------------------------------------------------');
				end;
			end;
			opc:=opcion();
		until(opc = 0);
	end;
end.
