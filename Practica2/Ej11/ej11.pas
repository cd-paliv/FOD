{11. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
!NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia}

program ej11;
const
	valoralto = 'zzzz';
type
	encuesta = record
		nomProv: string[25];
		cantPersAlfa: integer;
		persTotal: integer;
	end;
	maestro = file of encuesta;

	agencia = record
		nomProv: string[25];
		codLoc: integer;
		cantPersAlfa: integer;
		persTotal: integer;
	end;
	detalle = file of agencia;

//actualizo maestro con detalles
procedure leer(var a:detalle; var dato: agencia);
begin
	if not eof(a) then read(a, dato)
	else dato.nomProv := valoralto;
end;

procedure minimo(var det1, det2: detalle; var r1, r2, min: agencia);
begin
	if (r1.nomProv <= r2.nomProv) then begin
		min := r1;
		leer(det1, r1);
	end
	else begin
		min:= r2;
		leer(det2, r2);
	end;
end;

procedure maestro1(var mae: maestro; var det1, det2: detalle);
var regm: encuesta;
	regd1, regd2, min: agencia;
	nomProv: string[25];
begin
	reset(mae); //abro y leo
	read(mae, regm);
	reset(det1);
	leer(det1, regd1);
	reset(det2);
	leer(det2, regd2);

	minimo(det1, det2, regd1, regd2, min);
	while (min.nomProv <> valoralto) do begin
		nomProv:= min.nomProv;
		while (nomProv = min.nomProv) do begin //mientras este en la misma provincia actualizo datos
			regm.cantPersAlfa += min.cantPersAlfa;
			regm.persTotal += min.persTotal;
			minimo(det1, det2, regd1, regd2, min);
		end;
		seek(mae, filepos(mae)-1);
		write(mae, regm);
		if not eof(mae) then read(mae, regm);
	end;
	close(mae);
	close(det1);
	close(det2);
end;

//imprimir para verificar datos
procedure listar(x: encuesta);
begin
	with x do
		writeln('Provincia: ', nomProv, ' |Cantidad de personas alfabetizadas: ', cantPersAlfa, ' |Total personas encuestadas: ', persTotal);
end;

procedure imprimir(var a: maestro);
var aux: encuesta;
begin
	writeln('----------------------------------------------------');
	reset(a);
	while not eof(a) do begin
		read(a, aux);
		listar(aux);
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
		writeln('2 - Actualizar maestro');
		writeln('3 - Imprimir datos');
		write('Ingrese la opcion: '); readln(opc);
	until ((opc >= 0) AND (opc <= 3));
	opcion:=opc;
end;

//PP
var mae: maestro;
	det1, det2: detalle;
	opc: byte;
begin
	writeln('ENCUESTA');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		repeat
			case opc of
				1: begin
					Assign(mae, 'maestro');
					Assign(det1, 'detalle1');
					Assign(det2, 'detalle2');
					writeln('Archivos cargados');
				end;
				2: maestro1(mae, det1, det2);
				3: imprimir(mae);
			end;
			writeln('----------------------------------------------------');
			opc:=opcion();
		until(opc = 0);
	end;
end.
