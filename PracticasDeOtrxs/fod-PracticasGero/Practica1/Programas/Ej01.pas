program enteros;
type
    arch_enteros = file of integer;

procedure agregarNumeros (var arch_logico: file of integer);
var
   num: integer;
begin
     rewrite(arch_logico);
     writeln('Ingrese un numero');
     readln(num);
     while (num <> 10000) do begin
           write (arch_logico, num);
           writeln('Ingrese un numero');
           readln(num);
     end;
     close(arch_logico);
end;

procedure recorrer (var arch_logico: file of integer);
var
  num: integer;
begin
  reset(arch_logico);
  while (not EOF(arch_logico))do begin
    read (arch_logico, num);
    writeln(num)
  end;
  close(arch_logico);
end;

var
   numeros: arch_enteros;
   nombre_fisico: string;
begin
  writeln('Ingrese el nombre fisico del archivo');
  readln(nombre_fisico);
  assign(numeros, nombre_fisico);
  agregarNumeros(numeros);
  writeln('Numeros en el archivo: ');
  recorrer(numeros);
  readln();
end.
