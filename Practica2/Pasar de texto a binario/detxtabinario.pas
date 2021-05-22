{Este programa muestra como transferir la info de un archivo de texto a un archivo binario (.dat)

Precondiciones:
	|Ya existe un .txt
Tener en cuenta:
	|Recordar que los archivos de texto no tienen estructura y que se da por sentado que
	* un palabra, campo o dato se termina con un espacio.
	|Solamente puede haber un unico dato string por linea del archivo de texto y debe
	* ir al final de la misma.
	|El compilador hace las conversiones necesarias de texto a los distintos tipos de dato
}

program deTxtABinario;
type{
	personaEjemplo = record
		nom: string[25];
		dni: longint;
		edad: integer;
	end;}
	fecha = record
		dia: 1..31;
		mes: 1..12;
		anio: integer;
	end;
	sesion = record
		cod_usuario: integer;
		fecha: fecha;
		tiempo_sesion: real;
	end;
	
	archivo = file of sesion;

procedure cargarArchivo(var a:archivo; var t:text);
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

{
procedure cargarArchivo(var a:archivo; var t:text);
var aux: personaEjemplo;
begin
	reset(t); //abro
	rewrite(a); //creo
	while not eof(t) do begin
		with aux do readln(t, dni, edad, nom); //no importa el orden de registro, importa el
		write(a, aux);						//orden en que fueron escritos los datos en el .txt
	end;
	close(t);
	close(a);
	writeln('Archivo cargado');
	writeln('----------------------------------------------------');
end;}


//pp
var	texto: text;
	a: archivo;
begin
	Assign(a, 'detalle2.dat');
	Assign(texto, 'ej4detallediario2.txt');
	cargarArchivo(a, texto);
	writeln('archivo txt creado');
end.
