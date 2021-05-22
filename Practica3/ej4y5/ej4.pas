{4. Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 implica que no hay registros borrados y N indica que el próximo registro a
reutilizar es el N, siendo éste un número relativo de registro válido.}

program ej4;
const
	valoralto = 'fin';
type
	tTitulo  = string[50];
	tArchRevistas = file of tTitulo;

procedure crearArchivo(var a:tArchRevistas);
var r: tTitulo;
begin
	rewrite(a);
	r:= '0';
	write(a, r); //primero pongo el registro cabecera
	write('Ingrese titulo de la revista (fin para finalizar): '); readln(r);
	while (r <> 'fin') do begin
		write(a, r);
		write('Ingrese titulo de la revista: '); readln(r);
	end;
	close(a);
	writeln('Archivo cargado');
end;

procedure leer(var a:tArchRevistas; var dato: tTitulo);
begin
	if not eof(a) then read(a, dato)
	else dato := valoralto;
end;

{pasa un string a un entero}
function obtenerEntero(texto: string): integer;
var	valor, codigoDeError: integer;
begin
	valor := 0;
	Val(texto, valor, codigoDeError); //guarda el entero que esta en texto a valor, si no se logra la conversion codigo de error guarda el valor 0
	if(codigoDeError <> 0) then
		obtenerEntero := valor
	else obtenerEntero := -1;
end;

{a. Abre el archivo y agrega el título de la revista, recibido como
 parámetro manteniendo la política descripta anteriormente}
procedure agregar(var a: tArchRevistas; titulo: string);
var	reg: tTitulo;
	pos: integer;
begin
	reset(a);
	read(a, reg);
	pos := obtenerEntero(reg); //de string a int
	if(pos < 0) then begin
		seek(a, pos * -1);
		leer(a, reg);
		seek(a, filepos(a) - 1);
		write(a, titulo);
		seek(a, 0);
		write(a, reg);
	end
	else begin
		seek(a, filesize(a));
		write(a, titulo);
	end;
	close(a);
	writeln('Titulo agregado');
end;

{b. Liste el contenido del archivo omitiendo las revistas eliminados. Modifique lo que
 considere necesario para obtener el listado.}
procedure imprimir(var a:tArchRevistas);
var	reg: tTitulo;
	pos, error: integer;
begin
	reset(a);
	leer(a, reg);
	while(reg <> valoralto) do begin
		Val(reg, pos, error);
		if(error = 0) AND (pos < 0) then //la pos no importa, lo pongo porque sino no me deja compilar
			write(reg);
		leer(a, reg);
	end;
	close(a);
end;

{5. Abre el archivo y elimina el título de la revista recibida como
parámetro manteniendo la política descripta anteriormente}
procedure darBajaLogica(var a:tArchRevistas; titulo: string);
var	reg, cabecera: tTitulo;
	pos: integer;
begin
	reset(a);
	leer(a, reg);
	cabecera:= reg;
	while(reg <> valoralto) AND (reg <> titulo) do leer(a, reg);
	if(reg <> valoralto) then begin
		seek(a, filepos(a) - 1);
		pos:= (filepos(a)) * -1; //me guardo la pos del reg a eliminar en negativo
		Str(pos, reg);
		write(a, cabecera); //lo reemplazo con el valor que está en la cabecera
		seek(a, 0);
		write(a, reg); //me guardo la pos eliminada al principio
		writeln('Titulo eliminado');
	end
	else writeln('No se encontro el titulo');
	close(a);
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
		writeln('1 - Agregar un titulo al archivo');
		writeln('2 - Eliminar un titulo del archivo');
		writeln('3 - Listar en pantalla todos los titulos');
		write('Ingrese la opcion: '); readln(opc);
	until((opc >= 1) AND (opc <= 3));
	opcionDos:=opc;
end;

//PP
var a: tArchRevistas;
	opc: byte;
	titulo: tTitulo;
begin
	writeln('REVISTAS');
	writeln();
	opc:= opcion();
	writeln('----------------------------------------------------');
	if (opc <> 0) then begin
		Assign(a, 'archivo');
		repeat
			case opc of
				1: crearArchivo(a);
				2: begin
					writeln('----------------------------------------------------');
					opc:= opcionDos();
					case opc of
						1: begin
							write('Ingrese titulo a agregar: '); read(titulo);
							agregar(a, titulo);
						end;
						2: begin
							write('Ingrese titulo a borrar: '); readln(titulo);
							darBajaLogica(a, titulo);
						end;
						3: imprimir(a);
					end;
					writeln('----------------------------------------------------');
				end;
			end;
			opc:=opcion();
		until(opc = 0);
	end;
end.
