program Ej02;
type
    arch_enteros = file of integer;
procedure recorrer (var arch_logico: file of integer; var cant: integer; var prom: real);
var
  num: integer; tot: real; cantT: integer;
begin
  tot:= 0; cantT:= 0;
  reset(arch_logico);
  while (not EOF(arch_logico))do begin
    read (arch_logico, num);
    if (num < 1000) then
       cant:= cant +1;
    cantT:= cantT + 1;
    tot:= tot + num;
    writeln(num);
  end;
  prom:= tot / cantT;
  close(arch_logico);
end;

var
   numeros: arch_enteros;
   nombre_fisico: string;
   cant: integer;
   prom: real;
begin
  cant:= 0; prom:= 0;
  writeln('Ingrese el nombre del archivo que quiere analizar');
  readln(nombre_fisico);
  assign(numeros, nombre_fisico);
  recorrer(numeros, cant, prom);
  writeln('Cantidad de numeros menores a 1000: ', cant);
  writeln('Promedio: ', prom);
  readln();
end.
