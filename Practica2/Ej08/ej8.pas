{8. Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizado por cliente.
Para ello, se deberá informar por pantalla: los datos personales del cliente, el total mensual
(mes por mes cuánto compró) y finalmente el monto total comprado en el año por el cliente.
	Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido por la
empresa.
	El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año, mes,
día y monto de la venta.
	El orden del archivo está dado por: cod cliente, año y mes.
!Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron compras.}

program ej8;
const
	valoralto = 9999;
type
	cliente = record
		cod:integer;
		nomyape:string[40];
	end;
	fecha = record
		dia: 1..31;
		mes: 1..12;
		anio: integer;
	end;
	venta = record
		cli: cliente;
		f: fecha;
		monto: real;
	end;
	archivo = file of venta;

//Crear el archivo a partir de un archivo de texto
procedure cargarArchivo(var a:archivo; var t:text);
var aux: venta;
begin
	reset(t); //abro
	rewrite(a); //creo
	while not eof(t) do begin
		with aux do begin
			with cli do readln(t, cod, nomyape);
			with f do readln(t, dia, mes, anio);
			readln(t, monto);
		end;
		write(a, aux); //los guardo en el archivo binario
	end;
	close(t);
	close(a);
	writeln('Archivo maestro cargado');
	writeln('----------------------------------------------------');
end;

//total mensual de cliente: suma de dias
//total anual suma de mes
//total de ventas TODO

//reporte
procedure leer(var a:archivo; var dato:venta);
begin
	if not eof(a) then read(a, dato)
	else dato.cli.cod := valoralto;
end;

procedure crearReporte (var a:archivo);
var	reg: venta;
	tot, totMensual, totAnual, totCli: real;
	cod, anio, mes: integer;
begin
	reset(a);
	leer(a, reg);
	tot:= 0;
	while (reg.cli.cod <> valoralto) do begin
		writeln('----------------------------------------------------');
		writeln('Cliente: ', reg.cli.cod);
		cod:= reg.cli.cod;
		totCli:= 0;
		while (cod = reg.cli.cod) do begin
			writeln('');
			writeln('|Anio: ', reg.f.anio);
			anio:= reg.f.anio;
			totAnual:= 0;
			while (cod = reg.cli.cod) AND (anio = reg.f.anio) do begin
				writeln('|Mes: ', reg.f.mes);
				mes:= reg.f.mes;
				totMensual:= 0;
				while (cod = reg.cli.cod) AND (anio = reg.f.anio) AND (mes = reg.f.mes) do begin
					write('Dia: ', reg.f.dia, ' - $');
					writeln(reg.monto:2:2);
					totMensual += reg.monto;
					leer(a, reg);
				end;
				writeln('Total Mes: $', totMensual:2:2);
				totAnual += totMensual;
			end;
			writeln('Total Anio: $', totAnual:2:2);
			totCli += totAnual;
		end;
		writeln('Total Cliente: $', totCli:2:2);
		tot += totCli;
	end;
	writeln('----------------------------------------------------');
	writeln('Total Empresa: $', tot:2:2);
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
	writeln('EMPRESA');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		Assign(a, 'datos');
		repeat
			case opc of
				1: begin
					Assign(texto, 'datos.txt');
					cargarArchivo(a, texto);
				end;
				2: crearReporte(a);
			end;
			opc:=opcion();
		until(opc = 0);
	end;
end.
