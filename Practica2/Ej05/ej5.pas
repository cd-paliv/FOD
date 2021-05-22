{5. A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
reuniendo dicha información.
	Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida
nacimiento, nombre, apellido, dirección detallada(calle,nro, piso, depto, ciudad), matrícula
del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
padre.
	En cambio los 50 archivos de fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
lugar.
	Realizar un programa que cree el archivo maestro a partir de toda la información los
archivos. Se debe almacenar en el maestro: nro partida nacimiento, nombre, apellido,
dirección detallada(calle,nro, piso, depto, ciudad), matrícula del médico, nombre y apellido
de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció, además
matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se deberá,
además, listar en un archivo de texto la información recolectada de cada persona.
!Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única.
Tenga en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y
además puede no haber fallecido.}

program ej5;
uses sysutils;
const
	valoralto = 9999;
	fin = 2;
type
	rango = 1..fin;

	direccion = record
		calle: integer;
		nro: integer;
		piso: integer;
		depto: string[25];
		ciudad: string[25];
	end;
	nacimiento = record
		nro: integer;
		nom: string[25];
		ape: string[25];
		dire: direccion;
		med: integer;
		nomyapeMadre: string[50];
		dniMadre: integer;
		nomyapePadre: string[50];
		dniPadre: integer;
	end;
	detalleN = file of nacimiento;
	vDetalleN = array [rango] of detalleN;
	vDRegistroN = array [rango] of nacimiento;

	fecha = record
		dia: 1..31;
		mes: 1..12;
		anio: integer;
	end;
	fallecimiento = record
		nro:integer;
		dni: integer;
		nomyape: string[50];
		med: integer;
		f: fecha;
		hora: real;
		lugar: string[25];
	end;
	detalleF = file of fallecimiento;
	vDetalleF = array [rango] of detalleF;
	vDRegistroF = array [rango] of fallecimiento;

	registroMae = record
		datos: nacimiento;
		vivo: boolean;
		medF: integer;
		f: fecha;
		hora: real;
	end;
	maestro = file of registroMae;

//cargo detalles NACIMIENTO a partir de txt
procedure leerNacimiento (var x: nacimiento; var t: text);
begin
	with x do begin
		readln(t, nro, med);
		readln(t, nom);
		readln(t, ape);
		readln(t, dniMadre, nomyapeMadre);
		readln(t, dniPadre, nomyapePadre);
		with dire do begin
			readln(t, calle, nro, piso, depto);
			readln(t, ciudad);
		end;
	end;
end;

procedure cargarArchivoDetN(var a:detalleN; var t: text);
var aux: nacimiento;
begin
	reset(t); //abro
	rewrite(a); //creo
	while not eof(t) do begin
		leerNacimiento(aux, t);
		write(a, aux); //los guardo en el archivo binario
	end;
	close(t);
	close(a);
	writeln('Archivo detalle cargado');
	writeln('----------------------------------------------------');
end;

//cargo detalles FALLECIMIENTO de txt
procedure cargarArchivoDetF(var a:detalleF; var t: text);
var aux: fallecimiento;
begin
	reset(t); //abro
	rewrite(a); //creo
	while not eof(t) do begin
		with aux do begin
			readln(t, nro, dni, med);
			readln(t, nomyape);
			readln(t, hora);
			readln(t, lugar);
			with f do
				readln(t, dia, mes, anio);
		end;
		write(a, aux); //los guardo en el archivo binario
	end;
	close(t);
	close(a);
	writeln('Archivo detalle cargado');
	writeln('----------------------------------------------------');
end;

//creo maestro con detalles
{nacimiento}
procedure leerN(var a:detalleN; var dato: nacimiento);
begin
	if not eof(a) then read(a, dato)
	else dato.nro := valoralto;
end;

procedure minimoN (var detalle: vDetalleN; var reg: vDRegistroN; var min: nacimiento);
var i, posMin: integer;
begin
	posMin:= -1;
	min.nro := valoralto;
	for i:=1 to fin do
		if (reg[i].nro <> valoralto) AND (reg[i].nro < min.nro) then begin
			posMin := i;
			min := reg[i];
		end;
	if (posMin <> -1) then
		leerN(detalle[posMin], reg[posMin]);
end;

{fallecimiento}
procedure leerF(var a:detalleF; var dato: fallecimiento);
begin
	if not eof(a) then read(a, dato)
	else dato.nro := valoralto;
end;

procedure minimoF (var detalle: vDetalleF; var reg: vDRegistroF; var min: fallecimiento);
var i, posMin: integer;
begin
	posMin:= -1;
	min.nro := valoralto;
	for i:=1 to fin do
		if(reg[i].nro <> valoralto) AND (reg[i].nro < min.nro) then begin
			posMin := i;
			min := reg[i];
		end;
	if (posMin <> -1) then
		leerF(detalle[posMin], reg[posMin]);
end;

{paso datos de nacimiento a regm}
procedure registrosN(det: nacimiento; var mae: registroMae);
begin
	with mae do
		with datos do begin
			nro := det.nro;
			nom := det.nom;
			ape := det.ape;
			med := det.med;
			nomyapeMadre := det.nomyapeMadre;
			dniMadre := det.dniMadre;
			nomyapePadre := det.nomyapePadre;
			dniPadre := det.dniPadre;
			with dire do begin
				calle := det.dire.calle;
				nro:= det.dire.nro;
				piso:= det.dire.piso;
				depto:= det.dire.depto;
				ciudad:= det.dire.ciudad;
			end;
		end;
end;

{MAESTRO}
procedure maestro1(var mae: maestro; var detN: vDetalleN; var detF: vDetalleF);
var regm: registroMae;
	regdN: nacimiento;
	regdF: fallecimiento;
	regN: vDRegistroN;
	regF: vDRegistroF;
	i: rango;
begin
	for i:=1 to fin do begin //abro y leo todos los detalles
		reset(detN[i]);
		leerN(detN[i], regN[i]);
		reset(detF[i]);
		leerF(detF[i], regF[i]);
	end;
	minimoN(detN, regN, regdN); //le paso el arreglo de detalles, el arreglo de registros para que me devuelva el min en regd
	minimoF(detF, regF, regdF);
	rewrite(mae); //creo
	while (regdN.nro <> valoralto) do begin
		registrosN(regdN, regm);
		if (regdN.nro <> regdF.nro) then begin
			regm.vivo := true;
			regm.medF:= -1;
			regm.hora:= 0.0;
			regm.f.dia:= 1; regm.f.mes:= 1; regm.f.anio:= -1;
		end
		else begin
			regm.vivo := false;
			regm.medF := regdF.med;
			regm.hora := regdF.hora;
			regm.f.dia:= regdF.f.dia; regm.f.mes:= regdF.f.mes; regm.f.anio:= regdF.f.anio;
			minimoF(detF, regF, regdF);
		end;
		minimoN(detN, regN, regdN);
		write(mae, regm); //lo guardo
	end;
	for i:=1 to fin do begin
		close(detN[i]);
		close(detF[i]);
	end;
	close(mae);
	writeln('Archivo actualizado');
end;

//guardo maestro en txt
procedure exportarMae(var a:maestro; var texto:text);
var x: registroMae;
begin
	rewrite(texto); //abro archivo de texto para crearlo
	reset(a);	//abro archivo para modificarlo
	while not eof(a) do begin
		read(a, x);
		//writeln(texto, ''+#13+#10);
		with x do begin
			with datos do
				writeln(texto, nro, ' ', nom, ' ', ape, ' |', med, ' |Madre: ', nomyapeMadre, ' - ', dniMadre, ' |Padre: ', nomyapePadre, ' - ', dniPadre, ' |Vivo? ', vivo);
			if not(vivo) then begin
				write(texto, 'Médico deceso: ', medF, ' |Hora de deceso: ', hora:2:2, 'hs |Día ');
				with f do
					writeln(texto, dia, '/', mes, '/', anio); //guardo en el archivo texto los datos
			end;
		end;
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
		writeln('1 - Cargar archivos');
		writeln('2 - Trabajar con archivos generados');
		write('Ingrese la opcion: '); readln(opc);
	until ((opc >= 0) AND (opc <= 2));
	opcion:=opc;
end;

function opcionDos():integer;
var opc:integer;
begin
	repeat
		writeln('1 - Actualizar archivo maestro');
		writeln('2 - Exportar archivo maestro a archivo de texto');
		write('Ingrese la opcion: '); readln(opc);
	until((opc >= 1) AND (opc <= 2));
	opcionDos:=opc;
end;

//PP
var mae: maestro;
	detN: vDetalleN;
	detF: vDetalleF;
	opc: byte;
	tdN, tdF, tmnuevo: text;
	i: rango;
begin
	writeln('PARTIDAS');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		Assign(mae, 'maestro');
		for i:=1 to fin do begin //le asigno a todos los detalles su nom_físico
			Assign(detN[i], Format('Xnac%d.dat', [i]));
			Assign(detF[i], Format('Xfalle%d.dat', [i]));
		end;
		repeat
			case opc of
				1: begin
					for i:=1 to fin do begin
						Assign(tdN, Format('nacimiento%d.txt', [i]));
						cargarArchivoDetN(detN[i], tdN);
						Assign(tdF, Format('fallecimiento%d.txt', [i]));
						cargarArchivoDetF(detF[i], tdF);
					end;
				end;
				2: begin
					writeln('----------------------------------------------------');
					opc:= opcionDos();
					case opc of
						1: maestro1(mae, detN, detF);
						2: begin
							Assign(tmnuevo, 'maestr0.txt');
							exportarMae(mae, tmnuevo);
						end;
					end;
					writeln('----------------------------------------------------');
				end;
			end;
			opc:=opcion();
		until(opc = 0);
	end;
end.
