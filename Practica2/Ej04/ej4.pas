{4. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo dia en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
}

program ej4;
uses sysutils;
const
	valoralto = 9999;
	fin = 2;
type
	fecha = record
		dia: 1..31;
		mes: 1..12;
		anio: integer;
	end;
	rango = 1..fin;

	sesionMae = record
		cod_usuario: integer;
		fecha: fecha;
		tiempo_total: real;
	end;
	maestro = file of sesionMae;

	sesion = record
		cod_usuario: integer;
		fecha: fecha;
		tiempo_sesion: real;
	end;
	detalle = file of sesion;
	vDetalle = array [rango] of detalle;
	vDetRegistro = array [rango] of sesion;

{cargo detalles}
procedure cargarArchivo(var a:detalle; var t:text);
var aux: sesion;
begin
	reset(t); //abro
	rewrite(a); //creo
	while not eof(t) do begin
		with aux do begin
			readln(t, cod_usuario); 
			readln(t, tiempo_sesion);
			with fecha do
				readln(t, dia, mes, anio);
		end;
		write(a, aux);						//orden en que fueron escritos los datos en el .txt
	end;
	close(t);
	close(a);
	writeln('Archivo cargado');
	writeln('----------------------------------------------------');
end;

//creo maestro con detalles
procedure leer(var a:detalle; var dato: sesion);
begin
	if not eof(a) then read(a, dato)
	else dato.cod_usuario := valoralto;
end;

procedure minimo (var detalle: vDetalle; var reg: vDetRegistro; var min: sesion);
var i, posMin: integer;
begin
	posMin:= 0;
	min.cod_usuario := valoralto;
	min.fecha.dia := 31;
	min.fecha.mes := 12;
	min.fecha.anio := 2100;

	for i:=1 to fin do begin
		if(reg[i].cod_usuario <= min.cod_usuario) then begin
			if (reg[i].fecha.dia <= min.fecha.dia) then begin
				if (reg[i].fecha.mes <= min.fecha.mes) then begin
					if (reg[i].fecha.anio <= min.fecha.anio) then begin
						min := reg[i];
						posMin := i;
					end;
				end;
			end;
		end;
	end;

	if (posMin <> 0) then
		leer(detalle[posMin], reg[posMin]);
end;

procedure maestro1(var mae: maestro; var det: vDetalle);
var regm: sesionMae;
	min: sesion;
	reg: vDetRegistro;
	i: integer;
begin
	for i:=1 to fin do begin //abro y leo todos los detalles
		reset(det[i]);
		leer(det[i], reg[i]);
	end;
	minimo(det, reg, min);
	rewrite(mae); //creo el maestro
	while (min.cod_usuario <> valoralto) do begin
		{codigo}
		regm.cod_usuario := min.cod_usuario;
		{total}
		regm.tiempo_total := 0;
		while (regm.cod_usuario = min.cod_usuario) do begin
			{fecha}
			regm.fecha.dia:= min.fecha.dia;
			regm.fecha.mes:= min.fecha.mes;
			regm.fecha.anio:= min.fecha.anio;
			{suma tiempo total x usuario}
			while (regm.cod_usuario = min.cod_usuario) AND (regm.fecha.dia = min.fecha.dia) AND (regm.fecha.mes = min.fecha.mes) AND (regm.fecha.anio = min.fecha.anio)do begin
				regm.tiempo_total += min.tiempo_sesion;
				minimo(det, reg, min);
			end;
		end;
		write(mae, regm); //lo guardo
	end;
	close(mae);
	for i:=1 to fin do close(det[i]);
	writeln('Archivo actualizado');
end;

//guardo maestro en txt
procedure exportarMae(var a:maestro; var texto:text);
var x: sesionMae;
begin
	rewrite(texto);
	reset(a);
	while not eof(a) do begin
		read(a, x);
		with x do
			writeln(texto, 'Codigo de usuario: ', cod_usuario, ' - Tiempo total: ', tiempo_total:2:2, 'hs - Fecha: ', fecha.dia, '/', fecha.mes, '/', fecha.anio);
	end;
	close(a);
	close(texto);
end;

//imprimir para verificar datos
procedure listar(x: sesionMae);
begin
	with x do
		writeln('Codigo de usuario: ', cod_usuario, ' - Tiempo total: ', tiempo_total:2:2, 'hs - Fecha: ', fecha.dia, '/', fecha.mes, '/', fecha.anio);
end;

procedure imprimir(var a: maestro);
var aux: sesionMae;
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
		writeln('3');
		write('Ingrese la opcion: '); readln(opc);
	until((opc >= 1) AND (opc <= 3));
	opcionDos:=opc;
end;

//PP
var mae: maestro;
	det: vDetalle;
	opc: byte;
	tmnuevo, td: text;
	i: rango;
begin
	writeln('LAN');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		Assign(mae, 'maestro');
		for i:=1 to fin do //le asigno a todos los detalles su nom_físico
			Assign(det[i], Format('detalle%d.dat', [i]));
		repeat
			case opc of
				1: begin
					for i:=1 to fin do begin
						Assign(td, Format('ej4detallediario%d.txt', [i]));
						cargarArchivo(det[i], td);
					end;
				end;
				2: begin
					writeln('----------------------------------------------------');
					opc:= opcionDos();
					case opc of
						1: maestro1(mae, det);
						2: begin //exporto para verificar datos
							Assign(tmnuevo, 'maestr0.txt');
							exportarMae(mae, tmnuevo);
						end;
						3: imprimir(mae);
					end;
					writeln('----------------------------------------------------');
				end;
			end;
			opc:=opcion();
		until(opc = 0);
	end;
end.
