program ej2;
const
	fin = 'fin';
	valoralto = 9999;
type
	empleado= record
		nro:integer;
		ape:string[25];
		nom: string[25];
		edad:integer;
		dire: string[30];
		tel: integer;
		nac: string[8];
		DNI:longint;
	end;
	archivo= file of empleado;

procedure LeerD(var a:empleado);
begin
	writeln('Ingresar apellido del empleado | fin para finalizar');
	readln();
	read(a.ape);
	if (a.ape <> fin) then begin
		writeln('Ingresar nombre del empleado');
		readln();
		read(a.nom);
		writeln('Ingresar nro de empleado');
		readln(a.nro);
		writeln('Ingresar edad del empleado');
		readln(a.edad);
		writeln('Ingresar direccion del empleado');
		read(a.dire);
		writeln('Ingresar telefono del empleado');
		read(a.tel);
		writeln('Ingresar fecha de nacimiento del empleado');
		read(a.nac);
		writeln('Ingresar DNI del empleado');
		read(a.dni);
	end;
end;

procedure crearArchivo(var a:archivo);
var e:empleado;
begin
	rewrite(a);
	LeerD(e);
	while (e.ape <> fin) do begin
		write(a, e);
		LeerD(e);
	end;
	close(a);
	writeln('Archivo cargado');
end;

//BAJA LÓGICA
procedure bajaLogica(var a:archivo);
var	reg: empleado;
	st: string;
begin
	reset(a);
	read(a, reg);
	while not eof(a) do begin
		if (reg.dni < 8000000) then begin
			st := '*' + reg.nom;
			reg.nom:= st;
			seek(a, filepos(a)-1);
			write(a, reg); //reemplazo los datos por *dato para borralos lógicamente
		end;
		read(a, reg);
	end;
	close(a);
	writeln('Baja logica realizada');
end;

var	a: archivo;
begin
	Assign(a, 'archivo');
	crearArchivo(a);
	writeln('-----------------------------------------------');
	bajaLogica(a);
end.
