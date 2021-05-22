{9. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
!NOTA: La información se encuentra ordenada por código de provincia y código de localidad}

program ej9;
const
	valoralto = 9999;
type
	mesa= record
		cod_provincia: integer;
		cod_localidad: integer;
		num_mesa: integer;
		cant_votos: integer;
	end;
	archivo = file of mesa;

//Crear el archivo a partir de un archivo de texto
procedure cargarArchivo(var a:archivo; var t:text);
var aux: mesa;
begin
	reset(t); //abro
	rewrite(a); //creo
	while not eof(t) do begin
		with aux do
			readln(t, cod_provincia, cod_localidad, num_mesa, cant_votos);
		write(a, aux); //los guardo en el archivo binario
	end;
	close(t);
	close(a);
	writeln('Archivo cargado');
	writeln('----------------------------------------------------');
end;

//imprimir info
procedure leer(var a:archivo; var dato:mesa);
begin
	if not eof(a) then read(a, dato)
	else dato.cod_provincia := valoralto;
end;

procedure contabilizar(var a:archivo);
var reg: mesa;
	totProv, totLoc, tot: integer;
	codProv, codLoc: integer;
begin
	reset(a);
	tot:= 0;
	leer(a, reg);
	while (reg.cod_provincia <> valoralto) do begin
		writeln('----------------------------------------------------');
		writeln('Provincia: ', reg.cod_provincia);
		codProv:= reg.cod_provincia;
		totProv:= 0;
		while (codProv = reg.cod_provincia) do begin
			writeln(' ');
			writeln('Localidad: ', reg.cod_localidad);
			codLoc := reg.cod_localidad;
			totLoc:= 0;
			while (codLoc = reg.cod_localidad) AND (codProv = reg.cod_provincia) do begin
				write('Mesa: ', reg.num_mesa, ' - ');
				writeln(reg.cant_votos);
				totLoc += reg.cant_votos;
				leer(a, reg);
			end;
			writeln('Total Localidad: ', totLoc);
			totProv += totLoc;
		end;
		writeln('Total Provincia: ', totProv);
		tot += totProv;
	end;
	writeln(' ');
	writeln('Total Pais: ', tot);
	writeln('----------------------------------------------------');
	close(a);
end;

//opciones del usuario
function opcion(): integer;
var opc:integer;
begin
	repeat
		writeln('0 - Terminar el programa');
		writeln('1 - Cargar archivos');
		writeln('2 - Imprimir datos');
		write('Ingrese la opcion: '); readln(opc);
	until ((opc >= 0) AND (opc <= 2));
	opcion:=opc;
end;

//PP
var a: archivo;
	opc: byte;
	texto: text;
begin
	writeln('VOTOS');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		repeat
			case opc of
				1: begin
					Assign(a, 'datos');
					Assign(texto, 'datos.txt');
					cargarArchivo(a, texto);
				end;
				2: contabilizar(a);
			end;
			opc:=opcion();
		until(opc = 0);
	end;
end.
