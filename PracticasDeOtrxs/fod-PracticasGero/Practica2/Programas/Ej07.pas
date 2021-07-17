program ej7;
const valoralto = 9999;

type
  voto = record
    codProv: integer;
    codLoc: integer;
    numMesa: integer;
    cantVotos: integer;
  end;

  arch_votos = file of voto;

procedure crearArchivoMaestro (var archivo_logico: arch_votos);
var
  v: voto;
begin
  rewrite(archivo_logico);
  writeln('Ingrese el codigo de provincia (-1 para finalizar).');
  readln(v.codProv);
  while(v.codProv <> -1) do begin
    writeln('Ingrese el codigo de localidad.');
    readln(v.codLoc);
    writeln('Ingrese el numero de mesa.');
    readln(v.numMesa);
    writeln('Ingrese la cantidad de votos en la mesa.');
    readln(v.cantVotos);
    write(archivo_logico, v);
    writeln('Ingrese el codigo de provincia (-1 para finalizar).');
    readln(v.codProv);
  end;
  close(archivo_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure leer (var archivo_logico: arch_votos; var reg: voto);
begin
  if (not EOF(archivo_logico)) then
    read (archivo_logico, reg)
  else
    reg.codProv:= valoralto;
end;

procedure corteDeControl (var archivo_logico: arch_votos);
var
  reg: voto;
  auxProv, auxLoc, totProv, totLoc, totGeneral: integer;
begin
  reset(archivo_logico);
  totGeneral:= 0;
  leer(archivo_logico, reg);
  writeln('Codigo de Provincia: ',reg.codProv);
  writeln('Codigo de localidad    Total de Votos');
  totProv:= 0;
  while (reg.codProv <> valorAlto) do begin
    auxProv:= reg.codProv;
    auxLoc:= reg.codLoc;
    totLoc:= 0;
    while(reg.codProv = auxProv) and (reg.codLoc = auxLoc) do begin
      totLoc:= totLoc + reg.cantVotos;
      leer(archivo_logico, reg);
    end;
    writeln(auxLoc,'                      ',totLoc);
    totProv:= totProv + totLoc;
    if (auxProv <> reg.codProv) then begin
      totGeneral:= totGeneral + totProv;
      writeln('Total de Votos Provincia: ',totProv);
      writeln();
      if (reg.codProv <> valoralto) then begin
        writeln('Codigo de Provincia: ',reg.codProv);
        writeln('Codigo de localidad    Total de Votos');
      end;
      totProv:= 0;
    end;
  end;
  writeln('Total General de Votos: ',totGeneral);
  close(archivo_logico);
end;

var
  master: arch_votos;
  nom: String;
begin
  writeln('ENTER para crear el archivo de votos.');
  readln();
  writeln('Ingrese el nombre fisico del archivo a crear');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom;
  assign(master, nom);
  crearArchivoMaestro(master);
  writeln();
  writeln('ENTER para mostrar en pantalla un reporte general de votos.');
  readln();
  corteDeControl(master);
  readln();
end.

