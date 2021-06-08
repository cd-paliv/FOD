program ej3;
const
	valoralto = 9999;
type
	novela = record
		cod: integer;
		gen: string[25];
		nom: string[30];
		dur: real;
		dir: string[25];
		pre: real;
	end;
	archivo = file of novela;

procedure LeerD(var r: novela);
begin
	write('Ingresar codigo de la novela (-1 para finalizar): '); readln(r.cod);
	if (r.cod <> -1) then begin
		write('Ingresar genero de la novela: '); readln(r.gen);
		write('Ingresar nombre de la novela: '); readln(r.nom);
		write('Ingresar duracion de la novela: '); readln(r.dur);
		write('Ingresar director de la novela: '); readln(r.dir);
		write('Ingresar precio de la novela: '); readln(r.pre);
	end;
end;

procedure crearArchivo(var a:archivo);
var r:novela;
begin
	rewrite(a);
	r.cod:= 0;
	write(a, r); //primero pongo el registro cabecera
	LeerD(r);
	while (r.cod <> -1) do begin
		write(a, r);
		LeerD(r);
	end;
	close(a);
	writeln('Archivo cargado');
end;

//MANTENIMIENTO
procedure leer(var a:archivo; var dato: novela);
begin
	if not eof(a) then read(a, dato)
	else dato.cod := valoralto;
end;

{alta}
procedure darAlta(var a:archivo);
var	reg, nuevoReg: novela;
begin
	reset(a);
	writeln('-Ingrese nueva novela para agregar al archivo-');
	LeerD(nuevoReg);
	read(a, reg); //leo la cabecera
	if(reg.cod < 0) then begin //si tengo registros eliminados pongo el nuevoReg en esa pos
		seek(a, reg.cod * -1); //hago la pos guardada en la cabecera positiva y voy a esa
		leer(a, reg); //leo el reg a guardado ahí para reemplazar la cabecera
		seek(a, filepos(a)-1);
		write(a, nuevoReg); //guardo el reg con los nuevos datos ingresados
		seek(a, 0);
		write(a, reg); //reemplazo la cabecera sin la pos ahora ocupada
	end
	else begin //sino lo pongo al final
		seek(a, filesize(a));
		write(a, nuevoReg);
	end;
	close(a);
	writeln('Novela dada de alta');
end;

{modificar}
procedure modificarDatos(var a:archivo);
var	reg, nuevoReg: novela;
begin
	reset(a);
	write('Ingrese el codigo de novela a modificar: '); readln(nuevoReg.cod);
	leer(a, reg);
	while (reg.cod <> nuevoReg.cod) AND (reg.cod <> valoralto) do leer(a, reg);
	if(reg.cod <> valoralto) then begin
		seek(a, filepos(a)-1);
		write('Genero: '); readln(reg.gen);
		write('Nombre: '); readln(reg.nom);
		write('Duracion: '); readln(reg.dur);
		write('Director: '); readln(reg.dir);
		write('Precio: '); readln(reg.pre);
		write(a, reg);
		writeln('Datos modificados');
	end
	else writeln('No se encontro la novela');
	close(a);
end;

{eliminar}
procedure darBajaLogica(var a:archivo);
var	reg, cabecera: novela;
	cod: integer;
begin
	write('Ingrese codigo a borrar: '); readln(cod);
	reset(a);
	leer(a, reg);
	cabecera:= reg;
	while(reg.cod <> valoralto) AND (reg.cod <> cod) do leer(a, reg);
	if(reg.cod <> valoralto) then begin
		seek(a, filepos(a) - 1);
		reg.cod:= (filepos(a)) * -1; //me guardo la pos del reg a eliminar en negativo
		write(a, cabecera); //lo reemplazo con el valor que está en la cabecera
		seek(a, 0);
		write(a, reg); //me guardo la pos eliminada al principio
		writeln('Novela dada de baja');
	end
	else writeln('No se encontro la novela');
	close(a);
end;

{exportar a txt}
procedure exportarArchivo(var a:archivo; var texto:text);
var	r, cabecera: novela;
begin
	rewrite(texto);
	reset(a);
	read(a, r);
	cabecera:= r;
	read(a, r);
	while not eof(a) do begin
		if(r.cod > 0) then begin //si tiene cod < 0 está eliminado
			writeln(texto, 'Novela: ');
			with r do
				writeln(texto, '   Codigo: ', cod, ' |Genero: ', gen, ' |Nombre: ', nom, ' |Duracion: ', dur:2:2, ' |Director: ', dir, ' |Precio: $', pre:2:2);
		end;
		read(a, r);
	end;
	if(cabecera.cod < 0) then begin
		write(texto, '-------------------x-------------------');
		write(texto, 'Posiciones eliminadas: ');
		while(cabecera.cod < 0) do begin
			write(texto, cabecera.cod, ' ');
			seek(a, cabecera.cod * -1);
			read(a, cabecera);
		end;
		
	end else write(texto, 'Ninguna.');
	close(a);
	close(texto);
end;

//opciones del usuario
function opcion(): integer;
var opc:integer;
begin
	repeat
		writeln('0 - Terminar el programa');
		writeln('1 - Cargar archivo');
		writeln('2 - Manetenimiento del archivo');
		write('Ingrese la opcion: '); readln(opc);
	until ((opc >= 0) AND (opc <= 2));
	opcion:=opc;
end;

function opcionDos():integer;
var opc:integer;
begin
	repeat
		writeln('1 - Dar de alta una nueva novela');
		writeln('2 - Modificar los datos de una novela existente');
		writeln('3 - Dar de baja una novela');
		writeln('4 - Exportar archivo a archivo de texto');
		write('Ingrese la opcion: '); readln(opc);
	until((opc >= 1) AND (opc <= 4));
	opcionDos:=opc;
end;

//PP
var a, aux: archivo;
	opc: byte;
	nombreFisico, nomIngresado: string[30];
	texto: text;
begin
	writeln('NOVELAS');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		write('Ingrese el nombre del archivo: '); readln(nombreFisico);
		Assign(a, nombreFisico);
		repeat
			case opc of
				1: crearArchivo(a);
				2: begin
					writeln('----------------------------------------------------');
					write('Ingrese nombre del archivo a modificar: '); readln(nomIngresado);
					Assign(aux, nomIngresado);
					{$I-} reset(aux); {$I+}
					if IOResult <> 0 then writeln('ERROR: No existe el archivo ' + nomIngresado)
					else begin
						close(aux);
						opc:= opcionDos();
						case opc of
							1: darAlta(a);
							2: modificarDatos(a);
							3: darBajaLogica(a);
							4: begin
								Assign(texto, 'novelas.txt');
								exportarArchivo(a, texto);
							end;
						end;
					end;
					writeln('----------------------------------------------------');
				end;
			end;
			opc:=opcion();
		until(opc = 0);
	end;
end.
