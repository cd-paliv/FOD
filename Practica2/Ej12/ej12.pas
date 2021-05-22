{12. La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio de la
organización. En dicho servidor, se almacenan en un archivo todos los accesos que se realizan
al sitio.
	La información que se almacena en el archivo es la siguiente: año, mes, dia, idUsuario y tiempo
de acceso al sitio de la organización. El archivo se encuentra ordenado por los siguientes
criterios: año, mes, dia e idUsuario.
	Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará el
año calendario sobre el cual debe realizar el informe
Se deberá tener en cuenta las siguientes aclaraciones:
	- El año sobre el cual realizará el informe de accesos debe leerse desde teclado.
	- El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año no
encontrado”.
	- Debe definir las estructuras de datos necesarias.
	- El recorrido del archivo debe realizarse una única vez procesando sólo la información
necesaria.}


program ej12;
const
	valoralto = 9999;
type
	acceso = record
		anio: integer;
		mes: 1..12;
		dia: 1..31;
		idUsuario: integer;
		tiempoAcceso: real;
	end;
	archivo = file of acceso;
{
procedure cargarArchivo(var a:archivo; var t:text);
var aux: acceso;
begin
	reset(t); //abro
	rewrite(a); //creo
	while not eof(t) do begin
		with aux do begin
			readln(t, anio, mes, dia, idUsuario, tiempoAcceso);
		end;
		write(a, aux);
	end;
	close(t);
	close(a);
	writeln('Archivo cargado');
	writeln('----------------------------------------------------');
end;}

//informe
procedure leer(var a:archivo; var dato:acceso);
begin
	if not eof(a) then read(a, dato)
	else dato.anio := valoralto;
end;

procedure informeAccesos(var a:archivo);
var	reg:acceso;
	anioIngresado: integer;
	totDia, totMes, totAnio: real;
	anioActual, mesActual, diaActual: integer;
begin
	reset(a);
	leer(a, reg);
	writeln(' ');
	write('Ingrese anio para realizar informe: '); readln(anioIngresado);
	while (reg.anio <> valoralto) AND (anioIngresado <> -1) do begin
		if (2000 <= anioIngresado) then begin //verifico que el año sea verídico
			while (reg.anio <> valoralto) AND (reg.anio <> anioIngresado) do //busco en anio en el archivo
				leer(a, reg);
			if (reg.anio = anioIngresado) then begin //si lo encontré hago el informe
				writeln('----------------------------------------------------');
				writeln('Anio: ', reg.anio);
				anioActual := reg.anio;
				totAnio:= 0;
				while (anioActual = reg.anio) do begin
					writeln(' ');
					writeln('  Mes: ', reg.mes);
					mesActual:= reg.mes;
					totMes:= 0;
					while (mesActual = reg.mes) AND (anioActual = reg.anio) do begin
						writeln('    Dia: ', reg.dia);
						diaActual:= reg.dia;
						totDia:= 0;
						while (diaActual = reg.dia) AND (mesActual = reg.mes) AND (anioActual = reg.anio) do begin
							write('      idUsuario ', reg.idUsuario, ' - ');
							writeln('Tiempo total de acceso: ', reg.tiempoAcceso:2:2, 'hs');
							totDia += reg.tiempoAcceso;
							leer(a, reg);
						end;
						writeln('    Tiempo total acceso del dia ', diaActual, ': ', totDia:2:2);
						totMes += totDia;
					end;
					writeln('  Tiempo total acceso del mes ', mesActual, ': ', totMes:2:2);
					totAnio += totMes;
				end;
				writeln(' ');
				writeln('Tiempo total acceso del anio ', anioActual, ': ', totAnio:2:2);
				writeln('----------------------------------------------------');
			end
			else writeln('Anio no encontrado'); //si no informo que no está
		end
		else writeln('Ingrese anio valido (>1999)');
		writeln(' ');
		write('Ingrese anio para realizar informe (-1 para finalizar): '); readln(anioIngresado);
	end;
	writeln(' ');
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
	//texto:text;
begin
	writeln('SERVIDOR');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		repeat
			case opc of
				1: begin
					Assign(a, 'accesos');
					{Assign(texto, 'accesos.txt');
					cargarArchivo(a, texto);}
					writeln('Archivos cargados');
				end;
				2: informeAccesos(a);
			end;
			opc:=opcion();
		until(opc = 0);
	end;
end.
