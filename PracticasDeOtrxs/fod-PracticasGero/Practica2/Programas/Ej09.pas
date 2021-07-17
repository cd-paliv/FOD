program ej9;
uses sysutils;
const valoralto = 'zzzz';

type
  provincia = record
    nombre: String;
    cantAlf: integer;
    cantEnc: integer;
  end;

  detalle = record
    nombre: String;
    codLoc: integer;
    cantAlf: integer;
    cantEnc: integer;
  end;

  arch_provincias = file of provincia;
  arch_detalle = file of detalle;

procedure crearArchivoMaestro (var archivo_logico: arch_provincias; var texto_logico: Text);
var
  p: provincia;
begin
  rewrite(archivo_logico); reset(texto_logico);
  while(not EOF(texto_logico)) do begin
    readln(texto_logico, p.cantAlf, p.cantEnc, p.nombre);
    p.nombre:= Trim(p.nombre);
    write(archivo_logico, p);
  end;
  close(archivo_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure crearArchivoDetalle (var archivo_logico: arch_detalle);
var
  d: detalle;
begin
  rewrite(archivo_logico);
  writeln('Ingrese el nombre de la provincia ("00" para finalizar).');
  readln(d.nombre);
  while(d.nombre <> '00') do begin
    writeln('Ingrese el codigo de localidad.');
    readln(d.codLoc);
    writeln('Ingrese la cantidad de habitantes alfabetizados.');
    readln(d.cantAlf);
    writeln('Ingrese la cantidad de habitantes encuestados.');
    readln(d.cantEnc);
    write(archivo_logico, d);
    writeln('Ingrese el nombre de la provincia ("00" para finalizar).');
    readln(d.nombre);
  end;
  close(archivo_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure leer (var archivo_logico: arch_detalle; var reg: detalle);
begin
  if (not EOF(archivo_logico)) then
    read (archivo_logico, reg)
  else begin
    reg.nombre:= valoralto;
  end;
end;

procedure minimo (var reg1, reg2: detalle; var det1, det2: arch_detalle;
var min: detalle);
begin
  if (reg1.nombre<=reg2.nombre) then begin
    min:= reg1;
    leer(det1, reg1);
  end
  else begin
    min:= reg2;
    leer(det2, reg2);
  end;
end;

procedure actualizarMaestro (var maestro: arch_provincias; var det1, det2: arch_detalle);
var
  reg1, reg2, min: detalle;
  regM: provincia;
  totAlf, totEnc: integer;
begin
  reset(maestro); reset(det1); reset(det2);
  writeln('se hizo reset');//
  readln();                //

  leer(det1, reg1); leer(det2, reg2);
  writeln('se leyo en registros');//
  readln();                       //

  minimo (reg1, reg2, det1, det2, min);
  writeln('minimo obtenido: ', min.nombre,' ',min.codLoc,' ',min.cantAlf,' ',min.cantEnc);//
  readln();                                                                               //
  while (min.nombre <> valoralto) do begin
    writeln('entró a while');//
    readln();                //
    read (maestro, regM);
    writeln('se leyo maestro');//
    readln();
    writeln('regM.nombre: ',regM.nombre,' | regM.cantAlf: ',regM.cantAlf,' | regM.cantEnc: ',regM.cantEnc);//
    readln();                                                                                              //
    while(min.nombre <> regM.nombre) do begin //
      read(maestro, regM);
      writeln('se leyo maestro');//
      readln();
      writeln('regM.nombre: ',regM.nombre,' | regM.cantAlf: ',regM.cantAlf,' | regM.cantEnc: ',regM.cantEnc);//
      readln();
    end;//                                                                                              //
    totAlf:= 0; totEnc:= 0;
    while (min.nombre = regM.nombre) do begin                 //
      totAlf:= totAlf + min.cantAlf;
      totEnc:= totEnc + min.cantEnc;
      writeln('totAlf actualizado: ',totAlf);//
      writeln('totEnc actualizado: ',totEnc);//
      readln();                              //
      minimo (reg1, reg2, det1, det2, min);
      writeln('minimo obtenido: ', min.nombre,' ',min.codLoc,' ',min.cantAlf,' ',min.cantEnc);//
      readln();                                                                               //
    end;
    regM.cantAlf:= totAlf;
    regM.cantEnc:= totEnc;
    seek(maestro, filepos(maestro)-1);
    write(maestro, regM);
    writeln('se actualizo el reg en maestro');//
    readln();                                 //
  end;
  close(maestro); close(det1); close(det2);
  writeln('Archivo actualizado.');
end;

procedure printMaestro (var archivo_logico: arch_provincias);
var
  p: provincia;
begin
  reset(archivo_logico);
  while (not EOF(archivo_logico)) do begin
    read (archivo_logico, p);
    writeln('Provincia: ',p.nombre,' | Cant. Habitantes Alfabetizados: ',p.cantAlf,' | Cant. Habitantes Encuestados: ',p.cantEnc);
  end;
  writeln('------------------------------------------------');
  close(archivo_logico);
end;

var
  master: arch_provincias;
  detail1, detail2: arch_detalle;
  masterText: Text;
  nom: String;
begin
  writeln('ENTER para crear el archivo maestro.');
  readln();
  writeln('Ingrese el nombre fisico del archivo maestro.');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom;
  assign(master, nom);
  writeln('Ingrese el nombre fisico del archivo de texto que contiene los valores actuales de las provincias.');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom+'.txt';
  assign(masterText, nom);
  crearArchivoMaestro(master, masterText);
  writeln();
  writeln('ENTER para crear el archivo detalle 1.');
  readln();
  writeln('Ingrese el nombre fisico del archivo detalle 1.');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom;
  assign(detail1, nom);
  crearArchivoDetalle(detail1);
  writeln();
  writeln('ENTER para crear el archivo detalle 2.');
  readln();
  writeln('Ingrese el nombre fisico del archivo detalle 2.');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom;
  assign(detail2, nom);
  crearArchivoDetalle(detail2);
  writeln();
  writeln('ENTER para actualizar el archivo maestro.');
  readln();
  actualizarMaestro(master, detail1, detail2);
  writeln();
  writeln('ENTER para imprimir en pantalla el archivo maestro actualizado.');
  readln();
  printMaestro(master);
  readln();
end.





