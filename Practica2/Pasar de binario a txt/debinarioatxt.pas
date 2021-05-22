{Este programa muestra como transferir la info de un archivo binario a un archivo de texto (.txt)

Precondiciones:
	|El archivo ya está cargado en la ejecución del programa
Tener en cuenta:
	|Al escribir en archivos de texto el compilador pasa todos los tipos de datos 
	* automáticamente a tipo string
	|No importa el orden del registro, se puede guardar de cualquier forma
}

program debinarioatxt;
type
	personaEjemplo = record
		nom: string[25];
		dni: longint;
		edad: integer;
	end;
	archivo = file of personaEjemplo;

procedure exportarArchivo(var a:archivo; var texto:text);
var
	x: personaEjemplo;
begin
	rewrite(texto); //abro archivo de texto para crearlo
	reset(a);	//abro archivo para modificarlo
	while not eof(a) do begin
		read(a, x);
		with x do
			writeln(texto, nom, ' ', dni, ' ', edad); //guardo en el archivo texto los datos
	end;
	close(a);
	close(texto);
end;

//pp
var	texto: text;
	a: archivo;
begin
	Assign(a, 'ejemplo');
	Assign(texto, 'exportado.txt');
	exportarArchivo(a, texto);
	writeln('archivo txt creado');
end.
