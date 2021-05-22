{Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado
con la información correspondiente a las prendas que se encuentran a la venta. De
cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las prendas
a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las prendas que
quedarán obsoletas. Deberá implementar un procedimiento que reciba ambos archivos
y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda
correspondiente a valor negativo.
	Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las mismas
compactando el archivo. Para ello se deberá utilizar una estructura auxiliar, renombrando
el archivo original al finalizar el proceso.. Solo deben quedar en el archivo las prendas
que no fueron borradas, una vez realizadas todas las bajas físicas.}

program ej6;
const
	valoralto = 9999;
type
	prenda = record
		cod_prenda: integer;
		desc: string[20];
		colores: string[15];
		tipo_prenda: string[20];
		stock: integer;
		pre: real;
	end;
	maestro = file of prenda;

	detalle = file of integer; //codigos de prendas que quedarán obsoletas

//cargo maestro a partir de txt
procedure cargarArchivoMae(var a:maestro; var t:text);
var aux: prenda;
begin
	reset(t); //abro
	rewrite(a); //creo
	aux.stock:= 0; //cabecera
	write(a, aux);
	while not eof(t) do begin
		with aux do begin
			readln(t, cod_prenda, stock, pre);
			readln(t, tipo_prenda);
			readln(t, colores);
			readln(t, desc);
		end;
		write(a, aux); //los guardo en el archivo binario
	end;
	close(t);
	close(a);
	writeln('Archivo maestro cargado');
end;

//cargo detalles a partir de txt
procedure cargarArchivoDet(var a:detalle; var t: text);
var aux: integer;
begin
	reset(t); //abro
	rewrite(a); //creo
	while not eof(t) do begin
		readln(t, aux);
		write(a, aux); //los guardo en el archivo binario
	end;
	close(t);
	close(a);
	writeln('Archivo detalle cargado');
end;

//ACTUALIZACION
procedure leer(var a:maestro; var dato: prenda);
begin
	if not eof(a) then read(a, dato)
	else dato.cod_prenda := valoralto;
end;
procedure leerD(var a:detalle; var dato: integer);
begin
	if not eof(a) then read(a, dato)
	else dato := valoralto;
end;

procedure darBajaLogica(var mae:maestro; cab: prenda; reg: prenda);
begin
	seek(mae, filepos(mae) - 1);
	reg.stock:= (filepos(mae)) * -1; //me guardo la pos del reg a eliminar en negativo
	write(mae, cab); //lo reemplazo con el valor que está en la cabecera
	seek(mae, 0);
	write(mae, reg); //me guardo la pos eliminada al principio
end;

procedure eliminarPrendas(var mae:maestro; var det: detalle);
var	regm, cabecera: prenda;
	regd: integer;
begin
	reset(mae);
	leer(mae, regm);
	cabecera:= regm;
	reset(det);
	leerD(det, regd);
	while(regd <> valoralto) do begin //recorro el detalle
		while(regm.cod_prenda <> valoralto) AND (regm.cod_prenda <> regd) do //busco el det en el maestro
			leer(mae, regm);
		if(regm.cod_prenda <> valoralto) then
			darBajaLogica(mae, cabecera, regm);
		seek(mae, 0);
		leerD(det, regd);
	end;
	close(mae);
	close(det);
	writeln('Archivo actualizado');
end;

{compactación}
procedure darBajaFisica(var a:maestro; var archAuxiliar: maestro);
var	reg: prenda;
begin
	rewrite(archAuxiliar);
	reset(a);
	leer(a, reg);
	while(reg.cod_prenda <> valoralto) do begin
		if(reg.stock > 0) then write(archAuxiliar, reg);
		leer(a, reg);
	end;
	close(a);
	Erase(a); //elimino el archivo viejo
	close(archAuxiliar); //PRIMERO cierro
	rename(archAuxiliar, 'prendas'); //renombro el nuevo archivo sin las bajas lógicas
	writeln('Archivo compactado');
end;

{chekeo de la info}
procedure imprimir(var a:maestro);
var	reg: prenda;
begin
	writeln('----------------------------------------------------');
	reset(a);
	leer(a, reg);
	while(reg.cod_prenda <> valoralto) do begin
		if(reg.stock > 0) then
			writeln('Prenda: ', reg.cod_prenda, ' - Tipo: ', reg.tipo_prenda, ' - Stock: ', reg.stock, ' - Precio: ', reg.pre:2:2);
		leer(a, reg);
	end;
	close(a);
end;
{chekeo info del archivo compactado}
procedure imprimir2(var a:maestro);
var	reg: prenda;
begin
	writeln('----------------------------------------------------');
	reset(a);
	leer(a, reg);
	while(reg.cod_prenda <> valoralto) do begin
		writeln('Prenda: ', reg.cod_prenda, ' - Tipo: ', reg.tipo_prenda, ' - Stock: ', reg.stock, ' - Precio: ', reg.pre:2:2);
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
		writeln('1 - Cargar archivos');
		writeln('2 - Actualizar archivo');
		writeln('3 - Listar prendas');
		writeln('.4 - Compactar archivo');
		writeln('.5 - Listar nuevo archivo');
		write('Ingrese la opcion: '); readln(opc);
	until ((opc >= 0) AND (opc <= 5));
	opcion:=opc;
end;

//PP
var mae, archAuxiliar: maestro;
	det: detalle;
	opc: byte;
	tm, td: text;
begin
	writeln('ROPA');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		Assign(mae, 'prendas');
		Assign(det, 'detalle');
		repeat
			case opc of
				1: begin
					Assign(tm, 'prendas.txt');
					cargarArchivoMae(mae, tm);
					Assign(td, 'detalle.txt');
					cargarArchivoDet(det, td);
				end;
				2: eliminarPrendas(mae, det);
				3: imprimir(mae);
				4: begin
					Assign(archAuxiliar, 'ArchivoTemporal');
					darBajaFisica(mae, archAuxiliar);
				end;
				5: imprimir2(archAuxiliar);
			end;
			writeln('----------------------------------------------------');
			opc:=opcion();
		until(opc = 0);
	end;
end.
