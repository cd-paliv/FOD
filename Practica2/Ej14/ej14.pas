{14. Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus
próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la
cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles para
actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida y
cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino más
fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada uno del
maestro. Se pide realizar los módulos necesarios para:
}

program ej14;
const
	valoralto = 'zzzz';
type
	fecha = record
		dia: 1..31;
		mes: 1..12;
		anio: integer;
	end;

	{maestro}
	vuelo = record
		destino:string[25];
		f: fecha;
		horaSalida: real;
		cantAsientosDisp: integer;
	end;
	maestro = file of vuelo;

	{detalle}
	vueloDetalle = record
		destino:string[25];
		f:fecha;
		horaSalida: real;
		cantAsientosComprados: integer;
	end;
	detalle = file of vueloDetalle;

	{lista}
	lista = ^nodo;
	nodo = record
		dato: vuelo;
		sig: lista;
	end;

{}
procedure cargarArchivo(var a:maestro; var t:text);
var aux: vuelo;
begin
	reset(t); //abro
	rewrite(a); //creo
	while not eof(t) do begin
		with aux do begin
			readln(t, cantAsientosDisp, destino);
			with f do
				readln(t, dia, mes, anio);
			readln(t, horaSalida);
		end;
		write(a, aux);
	end;
	close(t);
	close(a);
	writeln('Archivo mae cargado');
	writeln('----------------------------------------------------');
end;

procedure cargarArchivoD(var a:detalle; var t:text);
var aux: vueloDetalle;
begin
	reset(t); //abro
	rewrite(a); //creo
	while not eof(t) do begin
		with aux do begin
			readln(t, cantAsientosComprados, destino);
			with f do
				readln(t, dia, mes, anio);
			readln(t, horaSalida);
		end;
		write(a, aux);
	end;
	close(t);
	close(a);
	writeln('Archivo cargado');
	writeln('----------------------------------------------------');
end;

{b. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que tengan
menos de una cantidad específica de asientos disponibles. La misma debe ser ingresada por teclado}
//agrego a lista
procedure agregarNodo (var l:lista; v:vuelo);
var aux: lista;
begin
	new(aux);
	aux^.dato:= v;
	aux^.sig:= l;
	l := aux;
end;

//actualizo maestro con detalles
procedure leer(var a:detalle; var dato: vueloDetalle);
begin
	if not eof(a) then read(a, dato)
	else dato.destino := valoralto;
end;

procedure minimo(var det1, det2: detalle; var r1, r2, c, min: vueloDetalle);
begin
	if (r1.destino <= r2.destino) then
		if(r1.destino < c.destino) then begin
			min := r1;
			leer(det1, r1);
		end else if (r1.destino = c.destino) AND ((r1.f.dia < c.f.dia) OR (r1.f.mes < c.f.mes) OR (r1.f.anio < c.f.anio)) then begin
				min := r1;
				leer(det1, r1);
			end else if (r1.destino = c.destino) AND ((r1.f.dia = c.f.dia) OR (r1.f.mes = c.f.mes) OR (r1.f.anio = c.f.anio)) AND (r1.horaSalida < c.horaSalida) then begin
					min := r1;
					leer(det1, r1);
				end
	else if(r2.destino < c.destino) then begin
			min := r2;
			leer(det2, r2);
		end else if (r2.destino = c.destino) AND ((r1.f.dia < c.f.dia) OR (r1.f.mes < c.f.mes) OR (r1.f.anio < c.f.anio)) then begin
				min := r2;
				leer(det2, r2);
			end else if (r2.destino = c.destino) AND ((r1.f.dia = c.f.dia) OR (r1.f.mes = c.f.mes) OR (r1.f.anio = c.f.anio)) AND (r2.horaSalida < c.horaSalida) then begin
					min := r2;
					leer(det2, r2);
				end;
end;

{a. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
sin asiento disponible}
procedure maestro1(var mae: maestro; var det1, det2: detalle; var l:lista);
var	regm: vuelo;
	regd1, regd2, min, comparo: vueloDetalle;
	destinoActual: string[25];
	diaActual, mesActual, anioActual: integer;
	horaSalidaActual: real;
	cantAsientosOcupados, cantMin: integer;
begin
	reset(mae); //abro y leo
	read(mae, regm);
	reset(det1);
	leer(det1, regd1);
	reset(det2);
	leer(det2, regd2);

	writeln('Ingresar cantidad minima de asientos disponibles');
	readln(cantMin);

	comparo.destino:= 'zzzz'; comparo.f.dia:= 31; comparo.f.mes:=12; comparo.f.anio:=9999; comparo.horaSalida:= 9999.9;

	minimo(det1, det2, regd1, regd2, comparo, min);
	while (min.destino <> valoralto) do begin
		destinoActual:= min.destino;
		cantAsientosOcupados:= 0;
		while (destinoActual = min.destino) do begin
			diaActual:= min.f.dia; mesActual:= min.f.mes; anioActual:= min.f.anio;
			while ((diaActual = min.f.dia) AND (mesActual = min.f.mes) AND (anioActual = min.f.anio)) AND (destinoActual = min.destino) do begin
				horaSalidaActual:= min.horaSalida;
				while (horaSalidaActual = min.horaSalida) AND ((diaActual = min.f.dia) AND (mesActual = min.f.mes) AND (anioActual = min.f.anio)) AND (destinoActual = min.destino) do begin
					cantAsientosOcupados += min.cantAsientosComprados;
					minimo(det1, det2, regd1, regd2, comparo, min);
				end;
			end;
		end;
		while(regm.destino <> destinoActual) AND ((diaActual = min.f.dia) AND (mesActual = min.f.mes) AND (anioActual = min.f.anio)) AND (regm.horaSalida <> horaSalidaActual) do read(mae, regm);
		regm.cantAsientosDisp -= cantAsientosOcupados;
		if(regm.cantAsientosDisp < cantMin) then agregarNodo(l, regm);


		seek(mae, filepos(mae)-1);
		write(mae, regm);
		if not eof(mae) then read(mae, regm);
	end;
	close(mae);
	close(det1);
	close(det2);
end;

//imprimir para verificar datos
procedure listar(x: vuelo);
begin
	with x do
		writeln('Destino: ', destino, ' |Fecha: ', f.dia, '/', f.mes, '/', f.anio, ' |Hora de salida: ', horaSalida, ' |Asientos disponibles: ', cantAsientosDisp);
end;

procedure imprimir(var a: maestro);
var aux: vuelo;
begin
	writeln('----------------------------------------------------');
	reset(a);
	while not eof(a) do begin
		read(a, aux);
		listar(aux);
	end;
	close(a);
end;

procedure imprimirLista(l:lista);
begin
	writeln('-Vuelos con asientos disponibles menor al minimo-');
	writeln(' ');
	while(l <> NIL) do begin
		writeln('Destino: ', l^.dato.destino, ' |Hora salida: ', l^.dato.horaSalida);
		l:= l^.sig;
	end;
end;

//opciones del usuario
function opcion(): integer;
var opc:integer;
begin
	repeat
		writeln('0 - Terminar el programa');
		writeln('1 - Cargar archivos');
		writeln('2 - Actualizar maestro');
		writeln('3 - Imprimir datos');
		writeln('4 - Imprimir lista');
		write('Ingrese la opcion: '); readln(opc);
	until ((opc >= 0) AND (opc <= 4));
	opcion:=opc;
end;

//PP
var mae: maestro;
	det1, det2: detalle;
	opc: byte;
	tm, td1, td2: text;
	l: lista;
begin
	writeln('VUELOS');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		Assign(mae, 'maestro');
		Assign(det1, 'detalle1');
		Assign(det2, 'detalle2');
		l:= NIL;
		repeat
			case opc of
				1: begin
					Assign(tm, 'maestro.txt');
					cargarArchivo(mae, tm);
					Assign(td1, 'detalle1.txt');
					cargarArchivoD(det1, td1);
					Assign(td2, 'detalle2.txt');
					cargarArchivoD(det2, td2);
					{Assign(mae, 'maestro');
					Assign(det1, 'detalle1');
					Assign(det2, 'detalle2');
					writeln('Archivos cargados');}
				end;
				2: maestro1(mae, det1, det2, l);
				3: imprimir(mae);
				4: imprimirLista(l);
			end;
			writeln('----------------------------------------------------');
			opc:=opcion();
		until(opc = 0);
	end;
end.
