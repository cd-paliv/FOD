program pr1ej1;

const
	fin = 30000;
type
	archivo = file of integer;

var
	a: archivo;
	nombreFisico: string[20];
	nro, suma: integer;
	prom: real;
begin
	writeln('Ingrese el nombre del archivo');
	readln(nombreFisico);
	Assign (a, nombreFisico); //enlace entre nom_lógico y nom_físico ingresado por teclado
	rewrite (a); //apertura del archivo para creación
	writeln('Ingrese un nro entero');
	readln(nro); //lectura de nro entero
	while (nro <> fin) do begin
		write(a, nro); //escritura del dato en el archivo
		writeln('Ingrese otro nro entero | 30.000 para finalizar');
		readln(nro);
	end;
	close(a); //cierre del archivo


	//ej2
	//IMPRIMIR ARCHIVO
	suma:=0;
	writeln('-------------------------------------------------');
	writeln('Archivo ', nombreFisico, ': ');
	reset(a); //abro como lectura/escritura. reset redirecciona puntero al principio automáticamente
	while (not eof(a)) do begin //eof se declara sólo
		read(a, nro); //se obtiene un elemento del archivo
		write(nro);
		if (nro < 1500) then
			writeln(' < 1500');
		suma:= suma + nro;
	end;
	prom:= suma/filesize(a);
	writeln('Promedio: ', prom:2:2);
	close(a); //cierro archivo
end.
