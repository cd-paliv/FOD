{7- El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De cada
venta se registra: código de producto y cantidad de unidades vendidas. Se pide realizar un
programa con opciones para:
}

program ej7;
uses sysutils;
const
	valoralto = 9999;
type
	producto = record
		cod: integer;
		nom: string[25];
		stockD: integer;
		stockMin: integer;
		pre: real;
	end;
	maestro = file of producto;

	prod_detalle = record
		cod: integer;
		cantV: integer;
	end;
	detalle = file of prod_detalle;

//a. Crear el archivo maestro a partir de un archivo de texto llamado “productos.txt”.
procedure cargarArchivoMae(var a:maestro; var t:text);
var aux: producto;
begin
	reset(t); //abro
	rewrite(a); //creo
	while not eof(t) do begin
		with aux do begin
			readln(t, cod, stockD, stockMin, pre);
			readln(t, nom);
		end;
		write(a, aux); //los guardo en el archivo binario
	end;
	close(t);
	close(a);
	writeln('Archivo maestro cargado');
	writeln('----------------------------------------------------');
end;

//b. Listar el contenido del archivo maestro en un archivo de texto llamado “reporte.txt”,
//listando de a un producto por línea.
procedure exportarMae(var a:maestro; var texto:text);
var
	x: producto;
begin
	rewrite(texto); //abro archivo de texto para crearlo
	reset(a);	//abro archivo para modificarlo
	while not eof(a) do begin
		read(a, x);
		with x do
			writeln(texto, cod, ' ', nom, ' ', stockD, ' ', stockMin, ' $', pre:2:2); //guardo en el archivo texto los datos
	end;	//al escribir en archivos texto, los tipos se pasan, todos, automaticamente a string
	close(a);
	close(texto);
end;

//c. Crear un archivo detalle de ventas a partir de en un archivo de texto llamado “ventas.txt”.
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

//d. Listar en pantalla el contenido del archivo detalle de ventas.
procedure listar(x: prod_detalle);
begin
	with x do
		writeln('Codigo: ', cod, ' |Cant. vendido: ', cantV);
end;

procedure imprimir(var a: detalle);
var aux: prod_detalle;
begin
	reset(a);
	while not eof(a) do begin
		read(a, aux);
		listar(aux);
	end;
	close(a);
end;

//e. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
	//● Ambos archivos están ordenados por código de producto.
	//● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del archivo detalle.
	//● El archivo detalle sólo contiene registros que están en el archivo maestro.
procedure leer(var a:detalle; var dato:prod_detalle);
begin
	if not eof(a) then read(a, dato)
	else dato.cod := valoralto;
end;

procedure maestro1(var mae: maestro; var det: detalle);
var regm: producto;
	regd: prod_detalle;
	actual, tot: integer;
begin
	reset(mae); //abro
	reset(det); //abro
	read(mae, regm);
	leer(det, regd);
	while (regd.cod <> valoralto) do begin
		actual:= regd.cod;
		tot:= 0;
		while (actual = regd.cod) do begin //mientras el alumno sea el mismo actualizo datos
			tot := tot + regd.cantV;
			leer(det, regd);
		end;
		while (regm.cod <> actual) do //busco el alumno en el maestro
			read(mae, regm);
		regm.stockD := regm.stockD - tot;
		seek(mae, filepos(mae)-1);
		write(mae, regm); //lo guardo
		if not eof(mae) then read(mae, regm); //avanzo en el maestro
	end;
	close(det);
	close(mae);
	writeln('Archivo actualizado');
end;

//f. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
//stock actual esté por debajo del stock mínimo permitido.
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
				writeln(texto, nom, ' ', stockD, ' $', pre:2:2); //guardo en el archivo texto los datos
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
		writeln('2 - Exportar maestro a archivo de texto');
		writeln('3 - Listar en pantalla todos los datos del archivo detalle');
		writeln('4 - Exportar a archivo de texto los productos con stock menor al minimo');
		write('Ingrese la opcion: '); readln(opc);
	until((opc >= 1) AND (opc <= 4));
	opcionDos:=opc;
end;

//PP
var mae: maestro;
	det: detalle;
	opc: byte;
	tm, td, tmnuevo, texto: text;
begin
	writeln('PRODUCTOS');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		Assign(mae, 'maestro');
		Assign(det, 'detalles');
		repeat
			case opc of
				1: begin
					Assign(tm, 'productos.txt');
					cargarArchivoMae(mae, tm);
				end;
				2: begin
					Assign(td, 'ventas.txt');
					cargarArchivoDet(det, td);
				end;
				3: begin
					writeln('----------------------------------------------------');
					opc:= opcionDos();
					case opc of
						1: maestro1(mae, det);
						2: begin
							Assign(tmnuevo, 'reporte.txt');
							exportarMae(mae, tmnuevo);
						end;
						3: imprimir(det);
						4: begin
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
