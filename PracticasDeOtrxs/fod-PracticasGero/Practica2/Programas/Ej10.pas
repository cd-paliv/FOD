program ej10;
const valoralto = 9999;

type
  acceso = record
    ano: integer;
    mes: integer;
    dia: integer;
    id: integer;
    tiempo: integer;
  end;

  arch_accesos = file of acceso;

procedure crearArchivoMaestro (var archivo_logico: arch_accesos);
var
  a: acceso;
begin
  rewrite(archivo_logico);
  writeln('Ingrese el ano del acceso (-1 para finalizar).');
  readln(a.ano);
  while(a.ano <> -1) do begin
    writeln('Ingrese el mes.');
    readln(a.mes);
    writeln('Ingrese el dia.');
    readln(a.dia);
    writeln('Ingrese el id del usuario.');
    readln(a.id);
    writeln('Ingrese la cantidad de minutos que duro el acceso.');
    readln(a.tiempo);
    write(archivo_logico, a);
    writeln('Ingrese el ano del acceso (-1 para finalizar).');
    readln(a.ano);
  end;
  close(archivo_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure leer (var archivo_logico: arch_accesos; var reg: acceso);
begin
  if (not EOF(archivo_logico)) then
    read (archivo_logico, reg)
  else
    reg.ano:= valoralto;
end;

procedure corteDeControl (var archivo_logico: arch_accesos);
var
  reg: acceso;
  year: integer;
  auxAno, totAno, auxMes, totMes, auxDia, totDia, auxId, totId: integer;
  entro: boolean;
begin
  reset(archivo_logico);
  writeln('Ingrese el ano sobre el que desea realizar el informe.');
  readln(year);
  leer(archivo_logico, reg);
  entro:= false;
  while(year <> reg.ano) and (reg.ano <> valoralto) do
    leer(archivo_logico, reg);
  if (reg.ano <> valoralto) then begin
    writeln('Ano: ',reg.ano);
    totAno:= 0;
  end;
  while (reg.ano <> valoralto) do begin
    entro:= true;
    writeln('  Mes: ',reg.mes);
    auxAno:= reg.ano;
    auxMes:= reg.mes;
    totMes:= 0;
    while(reg.ano = auxAno) and (reg.mes = auxMes) do begin
      writeln('    Dia: ',reg.dia);
      auxDia:= reg.dia;
      totDia:= 0;
      while (reg.ano = auxAno) and (reg.mes = auxMes) and (reg.dia = auxDia) do begin
        auxId:= reg.id;
        totId:= 0;
        while (reg.ano = auxAno) and (reg.mes = auxMes) and
        (reg.dia = auxDia) and (reg.id = auxId) do begin
          totId:= totId + reg.tiempo;
          leer(archivo_logico,reg);
        end;
        totDia:= totDia + totID;
        writeln('      idUsuario ',auxId,': Tiempo total de acceso: ',totId);
      end;
      totMes:= totMes + totDia;
      writeln('    Tiempo total de acceso en el dia ',auxDia,': ',totDia);
      writeln();
    end;
    totAno:= totAno + totMes;
    writeln('  Tiempo total de acceso en el mes ',auxMes,': ',totMes);
    writeln();
    if (auxAno <> reg.ano) then begin
      writeln('Tiempo total de acceso en el ano ',auxAno,': ',totAno);
      writeln('---------------------------------------------------------------');
      break;
    end;
  end;
  if (reg.ano = valoralto) and (entro = false) then begin
    writeln('Ano no encontrado.');
    writeln();
  end;
  close(archivo_logico);
end;

var
  master: arch_accesos;
  nom: String;
  cod: integer;
begin
  writeln('ENTER para crear el archivo maestro de accesos al servidor.');
  readln();
  writeln('Ingrese el nombre fisico del archivo a crear.');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom;
  assign(master, nom);
  //crearArchivoMaestro(master);
  writeln();
  writeln('Eliga una opcion.');
  writeln('1: Hacer un reporte detallado de accesos en un ano en particular.');
  writeln('0: Salir.');
  readln(cod);
  while (cod <> 0) do begin
    if (cod = 1) then begin
      corteDeControl(master);
      writeln();
    end
    else
      writeln('Ingrese una opcion correcta.');
    writeln('Eliga una opcion.');
    writeln('1: Hacer un reporte detallado de accesos en un ano en particular.');
    writeln('0: Salir.');
    readln(cod);
  end;
end.


