{13. Suponga que usted es administrador de un servidor de correo electrónico. En los logs del
mismo (información guardada acerca de los movimientos que ocurren en el server) que se
encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el servidor
de correo genera un archivo con la siguiente información: nro_usuario, cuentaDestino,
cuerpoMensaje. Este archivo representa todos los correos enviados por los usuarios en un día
determinado. Ambos archivos están ordenados por nro_usuario y se sabe que un usuario
puede enviar cero, uno o más mails por día.}


{a. }

program ej13;
const
	valoralto = 9999;
type
	usuario = record
		nro_usuario: integer;
		nombreUsuario: string[25];
		nom: string[25];
		ape: string[25];
		cantidadMailEnviados: integer;
	end;
	maestro = file of usuario;

	correo = record
		nro_usuario: integer;
		cuentaDestino: string[30];
		cuerpoMensaje: string[50];
	end;
	detalle = file of correo;

//a- Realice el procedimiento necesario para actualizar la información del log en un día particular
procedure leer(var a:detalle; var dato: correo);
begin
	if not eof(a) then read(a, dato)
	else dato.nro_usuario := valoralto;
end;

procedure actualizarMae (var mae: maestro; var det: detalle);
var	regm: usuario;
	regd: correo;
	actual: integer;
begin
	reset(mae);
	read(mae, regm);

	reset(det);
	leer(det, regd);

	while (regd.nro_usuario <> valoralto) do begin
		actual := regd.nro_usuario;
		while (actual = regd.nro_usuario) do begin
			regm.cantidadMailEnviados += 1;
			leer(det, regd);
		end;
		while (regm.nro_usuario <> actual) do read(mae, regm); //busco el nro en el maestro
		seek(mae, filepos(mae)-1);
		write(mae, regm); //lo guardo
		if not eof(mae) then read(mae, regm); //avanzo en el maestro
	end;
	close(det);
	close(mae);
	writeln('Archivo actualizado');
end;

{b- Genere un archivo de texto que contenga el siguiente informe dado un archivo
	detalle de un día determinado}
procedure exportarArchivo(var a:maestro; var texto:text);
var
	x: usuario; //while maestro{ while detalle{} }
begin
	rewrite(texto); //abro archivo de texto para crearlo
	reset(a);	//abro archivo para modificarlo
	while not eof(a) do begin
		read(a, x);
		with x do
			if(cantidadMailEnviados = 0) then
				writeln(texto, 'nro usuario: ', nro_usuario, ' - No envió mails')
			else
				writeln(texto, 'nro usuario: ', nro_usuario, ' - Cantidad mails: ', cantidadMailEnviados);
	end;
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
		writeln('2 - Actualizar maestro');
		writeln('3 - Hacer informe de cantidad de mensajes enviados por usuario');
		write('Ingrese la opcion: '); readln(opc);
	until ((opc >= 0) AND (opc <= 3));
	opcion:=opc;
end;

//PP
var mae: maestro;
	det1: detalle;
	opc: byte;
	tm: text;
begin
	writeln('VUELOS');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		repeat
			case opc of
				1: begin
					Assign(mae, 'maestro');
					Assign(det1, 'detalle');
				end;
				2: actualizarMae(mae, det1);
				3: begin
					Assign(tm, 'informeUsuarios.txt');
					exportarArchivo(mae, tm);
				end;
			end;
			writeln('----------------------------------------------------');
			opc:=opcion();
		until(opc = 0);
	end;
end.
