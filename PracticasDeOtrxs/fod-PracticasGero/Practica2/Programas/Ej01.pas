program ej1;
const valoralto = 9999;
type
  comision = record
    cod: integer;
    monto: integer;
    nombre: String;
  end;

  archivo_com = file of comision;

 //supongo que el usuario va a ingresar las ventas ordenadas
procedure crearArchivoConsola (var archivo_logico1: archivo_com);
var
  c: comision;
  nomF: String;
begin
  writeln('Ingrese el nombre fisico del archivo');
  readln(nomF);
  nomF:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nomF;
  assign(archivo_logico1, nomF);
  rewrite(archivo_logico1);
  writeln('Ingrese el codigo del empleado (-1 para finalizar)');
  readln(c.cod);
  while (c.cod <> -1) do begin
    writeln('Ingrese el nombre del empleado');
    readln(c.nombre);
    writeln('Ingrese el monto vendido');
    readln(c.monto);
    write(archivo_logico1, c);
    writeln('Ingrese el codigo del empleado (-1 para finalizar)');
    readln(c.cod);
  end;
  close(archivo_logico1);
  writeln('Archivo guardado exitosamente en: C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos.');
end;

procedure leer (var archivo_logico1: archivo_com; var reg: comision);
begin
  if (not EOF(archivo_logico1)) then
    read (archivo_logico1, reg)
  else
    reg.cod:= valoralto;
end;

procedure acumular (var archivo_logico1: archivo_com; var archivo_logico2: archivo_com);
var
  reg: comision;
  regFinal: comision;
  auxC: integer;
  auxN: String;
  total: integer;
  nomF: String;
begin
  writeln('Ingrese el nombre fisico del nuevo archivo');
  readln(nomF);
  nomF:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nomF;
  assign(archivo_logico2, nomF);
  reset(archivo_logico1); rewrite(archivo_logico2);
  leer(archivo_logico1, reg);
  while (reg.cod <> valoralto) do begin
    auxC:= reg.cod;
    auxN:= reg.nombre;
    total:= 0;
    while (auxC = reg.cod) do begin
      total:= total + reg.monto;
      leer(archivo_logico1, reg);
    end;
    regFinal.cod:= auxC;
    regFinal.nombre:= auxN;
    regFinal.monto:= total;
    write(archivo_logico2, regFinal);
  end;
  close(archivo_logico1); close(archivo_logico2);
  writeln('Archivo guardado en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos.');
end;

procedure imprimirArchivo (var archivo_logico: archivo_com);
var
  c: comision;
begin
  reset(archivo_logico);
  while(not EOF(archivo_logico)) do begin
    read (archivo_logico, c);
    writeln('Codigo de empleado: ',c.cod,' | Nombre: ',c.nombre,' | Total de Ingresos: ',c.monto);
  end;
  close(archivo_logico);
end;

var
  comisiones: archivo_com;
  comisionesCompacto: archivo_com;
begin
  writeln('ENTER para crear un archivo de comisiones por empleado.');
  readln();
  crearArchivoConsola(comisiones);
  readln();
  writeln('ENTER para crear un nuevo archivo compactando el total de ingresos por empleado.');
  readln();
  acumular(comisiones, comisionesCompacto);
  readln();
  writeln('ENTER para imprimir los datos del nuevo archivo.');
  readln();
  imprimirArchivo(comisionesCompacto);
  readln();
end.

