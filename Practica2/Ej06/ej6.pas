{6- Se cuenta con un archivo maestro con los artículos de una cadena de venta de
indumentaria. De cada artículo se almacena: código del artículo, nombre, descripción,talle,
color, stock disponible, stock mínimo y precio del artículo.
	Se recibe diariamente un archivo detalle de cada una de las 15 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 15 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de artículo y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de artículo,
descripción, stock disponible y precio de aquellos artículo que tengan stock disponible por
debajo del stock mínimo.
!Nota: todos los archivos se encuentran ordenados por código de artículo. En cada detalle
puede venir 0 o N registros de un determinado artículo.}


program ej6;
uses sysutils;
const
	valoralto = 9999;
	fin = 3;
type
	rango = 1..fin;
	producto = record
		cod: integer;
		nom: string[25];
		desc: string[25];
		stockD: integer;
		stockMin: integer;
		pre: real;
		talle: (xxs, xs, s, m);
		color: string[20];
	end;
	maestro = file of producto;

	prod_detalle = record
		cod: integer;
		cantV: integer;
	end;
	detalle = file of prod_detalle;
	vDetalle = array [rango] of detalle;
	vDRegistro = array [rango] of prod_detalle;

//cargo maestro a partir de txt
procedure cargarArchivoMae(var a:maestro; var t:text);
var aux: producto;
begin
	reset(t); //abro
	rewrite(a); //creo
	while not eof(t) do begin
		with aux do begin
			readln(t, cod, stockD, stockMin, pre);
			readln(t, nom);
			readln(t, desc);
			readln(t, talle, color);
		end;
		write(a, aux); //los guardo en el archivo binario
	end;
	close(t);
	close(a);
	writeln('Archivo maestro cargado');
	writeln('----------------------------------------------------');
end;

//cargo detalles a partir de txt
procedure cargarArchivoDet(var a:detalle; var t: text);
var aux: prod_detalle;
begin
	reset(t); //abro
	rewrite(a); //creo
	while not eof(t) do begin
		with aux do begin
			readln(t, cod, cantV);
		end;
		write(a, aux); //los guardo en el archivo binario
	end;
	close(t);
	close(a);
	writeln('Archivo detalle cargado');
	writeln('----------------------------------------------------');
end;


//actualizo maestro con detalles
procedure leer(var a:detalle; var dato: prod_detalle);
begin
	if not eof(a) then read(a, dato)
	else dato.cod := valoralto;
end;

procedure minimo (var detalle: vDetalle; var reg: vDRegistro; var min: prod_detalle);
var i, posMin: rango;
begin
	posMin:= 1;
	min.cod := 9999;
	for i:=1 to fin do
		if(reg[i].cod < min.cod) then begin
			posMin := i;
			min := reg[i];
		end;
	leer(detalle[posMin], reg[posMin]);
end;

procedure maestro1(var mae: maestro; var det: vDetalle);
var regm: producto;
	regd: prod_detalle;
	reg: vDRegistro;
	i: rango;
	aux, tot: integer;
begin
	for i:=1 to fin do begin //abro y leo todos los detalles
		reset(det[i]);
		leer(det[i], reg[i]); //guardo los datos de mi vDetalles en el vector de registros
	end;
	minimo(det, reg, regd); //le paso el arreglo de detalles, el arreglo de registros para que me devuelva el min en regd
	reset(mae);
	read(mae, regm);
	while (regd.cod <> valoralto) do begin
		aux := regd.cod;
		tot := 0;
		while (aux = regd.cod) do begin
			tot := tot + regd.cantV;
			minimo(det, reg, regd);
		end;
		while (regm.cod <> aux) do //busco en el maestro el detalle
			read(mae, regm);
		regm.stockD := regm.stockD - tot;
		seek(mae, filepos(mae)-1);
		write(mae, regm); //lo guardo
		if not eof(mae) then read(mae, regm); //avanzo en el maestro
	end;
	for i:=1 to fin do close(det[i]);
	close(mae);
	writeln('Archivo actualizado');
end;

//guardo maestro con stock<min en txt
procedure exportarStock(var a:maestro; var texto:text);
var
	x: producto;
begin
	rewrite(texto); //abro archivo de texto para crearlo
	reset(a);	//abro archivo para modificarlo
	while not eof(a) do begin
		read(a, x);
		with x do
			if (stockD < stockMin) then
				writeln(texto, nom, ' ', stockD, ' $', pre:2:2, ' ', desc); //guardo en el archivo texto los datos
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
		writeln('1 - Cargar archivo maestro');
		writeln('2 - Cargar archivos detalles');
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
		writeln('2 - Exportar a archivo de texto los productos con stock menor al minimo');
		write('Ingrese la opcion: '); readln(opc);
	until((opc >= 1) AND (opc <= 2));
	opcionDos:=opc;
end;

//PP
var mae: maestro;
	det: vDetalle;
	opc: byte;
	nombreFisico: string[30];
	tm, td, texto: text;
	i: rango;
begin
	writeln('PRODUCTOS');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		writeln('Ingrese el nombre del archivo'); readln(nombreFisico);
		Assign(mae, nombreFisico);
		for i:=1 to fin do //le asigno a todos los detalles su nom_físico
			Assign(det[i], Format('detalle%d.dat', [i]));
		repeat
			case opc of
				1: begin
					Assign(tm, 'ej3maestro.txt');
					cargarArchivoMae(mae, tm);
				end;
				2: begin
					for i:=1 to fin do begin
						Assign(td, Format('detalle%d.txt', [i]));
						cargarArchivoDet(det[i], td);
					end;
				end;
				3: begin
					writeln('----------------------------------------------------');
					opc:= opcionDos();
					case opc of
						1: maestro1(mae, det);
						2: begin
							Assign(texto, 'reporteStockInsuficiente.txt');
							exportarStock(mae, texto);
						end;
					end;
					writeln('----------------------------------------------------');
				end;
			end;
			opc:=opcion();
		until(opc = 0);
	end;
end.
