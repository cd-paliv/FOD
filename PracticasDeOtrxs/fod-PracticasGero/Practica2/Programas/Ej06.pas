program ej6;
const valoralto = 9999;

type
  client = record
    cod: integer;
    nombre: String;
    apellido: String;
  end;

  venta = record
    cliente: client;
    ano: integer;
    mes: integer;
    dia: integer;
    monto: integer;
  end;

  arch_ventas = file of venta;

procedure crearArchivoMaestro (var archivo_logico: arch_ventas);
var
  v: venta;
begin
  rewrite(archivo_logico);
  writeln('Ingrese el codigo del cliente (-1 para finalizar).');
  readln(v.cliente.cod);
  while(v.cliente.cod <> -1) do begin
    writeln('Ingrese el nombre del cliente.');
    readln(v.cliente.nombre);
    writeln('Ingrese el apellido del cliente.');
    readln(v.cliente.apellido);
    writeln('Ingrese el ano de la venta.');
    readln(v.ano);
    writeln('Ingrese el mes de la venta (numero).');
    readln(v.mes);
    writeln('Ingrese el dia de la venta.');
    readln(v.dia);
    writeln('Ingrese el monto pagado.');
    readln(v.monto);
    write(archivo_logico, v);
    writeln('Ingrese el codigo del cliente (-1 para finalizar).');
    readln(v.cliente.cod);
  end;
  close(archivo_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure leer (var archivo_logico: arch_ventas; var reg: venta);
begin
  if (not EOF(archivo_logico)) then
    read (archivo_logico, reg)
  else
    reg.cliente.cod:= valoralto;
end;

procedure reporte (var archivo_logico: arch_ventas);
var
  reg: venta;
  auxC, auxM: integer;
  totMes, totAno, totEmp: integer;
begin
  reset(archivo_logico);
  totEmp:= 0;
  leer(archivo_logico, reg);
  while (reg.cliente.cod <> valoralto) do begin
    writeln('Cliente n°',reg.cliente.cod,': ',reg.cliente.nombre,' ',reg.cliente.apellido);
    auxC:= reg.cliente.cod;
    totAno:= 0;
    while (reg.cliente.cod = auxC) do begin
      auxM:= reg.mes; totMes:= 0;
      while(reg.cliente.cod = auxC) and (reg.mes = auxM) do begin
        totMes:= totMes + reg.monto;
        leer(archivo_logico,reg);
      end;
      writeln('Gasto total en el mes ',auxM,': $',totMes);
      totAno:= totAno + totMes;
    end;
    writeln('-----------------------------------------------------------------');
    writeln('Gasto total en el ano: $',totAno);
    totEmp:= totEmp + totAno;
    writeln('-----------------------------------------------------------------');
  end;
  writeln();
  writeln('-----------------------------------------------------------------');
  writeln('Ganancias totales de la empresa en el año: $',totEmp);
  writeln('-----------------------------------------------------------------');
  close(archivo_logico);
end;

var
  master: arch_ventas;
  nom: String;
begin
  writeln('ENTER para crear el archivo de ventas.');
  readln();
  writeln('Ingrese el nombre fisico del archivo a crear');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom;
  assign(master, nom);
  crearArchivoMaestro(master);
  writeln();
  writeln('ENTER para mostrar en pantalla un reporte anual.');
  readln();
  reporte(master);
  readln();
end.







