program ej11;
const valoralto = 9999;

type
  log = record
    nro: integer;
    user: String;
    nombre: String;
    apellido: String;
    cantMails: integer;
  end;

  detalle = record
    nro: integer;
    destino: String;
    cuerpo: String;
  end;

  arch_logs = file of log;
  arch_detalle = file of detalle;

procedure crearArchivoMaestro (var archivo_logico: arch_logs);
var
  l: log;
begin
  rewrite(archivo_logico);
  writeln('Ingrese el numero de usuario (-1 para finalizar).');
  readln(l.nro);
  while (l.nro <> -1) do begin
   writeln('Ingrese el username.');
   readln(l.user);
   writeln('Ingrese el nombre.');
   readln(l.nombre);
   writeln('Ingrese el apellido.');
   readln(l.apellido);
   writeln('Ingrese la cantidad de mails enviados por el usuario.');
   readln(l.cantMails);
   write(archivo_logico, l);
   writeln('Ingrese el numero de usuario (-1 para finalizar).');
   readln(l.nro);
 end;
 close(archivo_logico);
end;

procedure crearArchivoDetalle (var archivo_logico: arch_detalle);
var
  d: detalle;
begin
  rewrite(archivo_logico);
  writeln('Ingrese el numero de usuario (-1 para finalizar).');
  readln(d.nro);
  while (d.nro <> -1) do begin
   writeln('Ingrese el username del destinatario.');
   readln(d.destino);
   writeln('Ingrese el cuerpo del mensaje a enviar.');
   readln(d.cuerpo);
   write(archivo_logico, d);
   writeln('Ingrese el numero de usuario (-1 para finalizar).');
   readln(d.nro);
 end;
 close(archivo_logico);
 writeln('Archivo guardado en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure leer (var archivo_logico: arch_detalle; var reg: detalle);
begin
  if (not EOF(archivo_logico)) then
    read (archivo_logico, reg)
  else
    reg.nro:= valoralto;
end;

procedure actualizarANDinforme (var maestro: arch_logs; var detail: arch_detalle; var informe: Text);
var
 regM: log;
 regD: detalle;
begin
  reset(maestro); reset(detail); rewrite(informe);
  leer(detail, regD);
  while (not EOF(maestro)) do begin
    read(maestro, regM);
    while (regM.nro = regD.nro) do begin
      regM.cantMails:= regM.cantMails + 1;
      leer(detail, regD);
    end;
    writeln(informe,'nro_usuario: ',regM.nro,' | Cant. mensajes enviados: ',regM.cantMails);
    seek(maestro,filepos(maestro)-1);
    write(maestro, regM);
  end;
  close(maestro); close(detail); close(informe);
  writeln('Archivo actualizado con exito.');
  writeln('Informe guardado en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

var
  master: arch_logs;
  detail: arch_detalle;
  nom: String;
  inform: Text;
begin
  writeln('ENTER para crear el archivo maestro "logmail.dat".');
  readln();
  assign(master,'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\logmail.dat');
  //crearArchivoMaestro(master);
  writeln();
  writeln('ENTER para crear el archivo detalle.');
  readln();
  writeln('Ingrese el nombre fisico del archivo a crear.');
  readln(nom);
  nom:='C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom;
  assign(detail, nom);
  //crearArchivoDetalle(detail);
  writeln();
  writeln('ENTER para actualizar el archivo maestro y exportar un informe por usuario.');
  readln();
  writeln('Ingrese el nombre fisico del informe.');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom+'.txt';
  assign(inform, nom);
  actualizarANDinforme(master, detail, inform);
  writeln();
  writeln('ENTER para finalizar.');
  readln();
end.




