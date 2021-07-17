program ej12;
const valoralto = 'zzzz';

type
  vuelo = record
    destino: String;
    fecha: integer;
    hora: integer;
    cantAsientos: integer;
  end;

  detalle = record
    destino: String;
    fecha: integer;
    hora: integer;
    cantComprados: integer;
  end;

  arch_vuelos = file of vuelo;
  arch_detalle = file of detalle;

procedure crearArchivoMaestro (var archivo_logico: arch_vuelos);
var
  v: vuelo;
begin
  rewrite(archivo_logico);
  writeln('Ingrese el destino del vuelo ("00" para finalizar).');
  readln(v.destino);
  while (v.destino <> '00') do begin
   writeln('Ingrese la fecha del vuelo (aaaammdd).');
   readln(v.fecha);
   writeln('Ingrese la hora del vuelo (hhmm).');
   readln(v.hora);
   writeln('Ingrese la cantidad de asientos disponibles.');
   readln(v.cantAsientos);
   write(archivo_logico, v);
   writeln('Ingrese el destino del vuelo ("00" para finalizar).');
   readln(v.destino);
 end;
 close(archivo_logico);
 writeln('Archivo guardado en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure crearArchivoDetalle(var archivo_logico: arch_detalle);
var
  v: detalle;
begin
  rewrite(archivo_logico);
  writeln('Ingrese el destino del vuelo ("00" para finalizar).');
  readln(v.destino);
  while (v.destino <> '00') do begin
   writeln('Ingrese la fecha del vuelo (aaaammdd).');
   readln(v.fecha);
   writeln('Ingrese la hora del vuelo (hhmm).');
   readln(v.hora);
   writeln('Ingrese la cantidad de asientos comprados.');
   readln(v.cantComprados);
   write(archivo_logico, v);
   writeln('Ingrese el destino del vuelo ("00" para finalizar).');
   readln(v.destino);
 end;
 close(archivo_logico);
 writeln('Archivo guardado en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure leer (var archivo_logico: arch_detalle; var reg: detalle);
begin
  if (not EOF(archivo_logico)) then
    read (archivo_logico, reg)
  else begin
    reg.destino:= valoralto;
  end;
end;

procedure minimo (var reg1, reg2: detalle; var det1, det2: arch_detalle;
var min: detalle);
begin
  if (reg1.destino<reg2.destino) then begin
    min:= reg1;
    leer(det1, reg1);
  end
  else
    if (reg1.destino=reg2.destino) then
      if (reg1.fecha<reg2.fecha) then begin
        min:= reg1;
        leer(det1, reg1);
      end
      else
        if (reg1.fecha=reg2.fecha) then
          if(reg1.hora<=reg2.hora) then begin
            min:= reg1;
            leer(det1, reg1);
          end
          else
            begin
              min:= reg2;
              leer(det2, reg2);
            end
        else
          begin
            min:= reg2;
            leer(det2, reg2);
          end;
    else
      begin
        min:= reg2;
        leer(det2, reg2);
      end;
end;

procedure actualizarMaestro (var maestro: arch_vuelos; var det1, det2: arch_detalle; var advertencia: Text);
var
  reg1, reg2, min: detalle;
  regM: vuelo;
  totAlf, totEnc: integer;
  valor: integer;
begin
  writeln('Ingrese el valor minimo de asientos disponibles para la advertencia.');
  readln(valor);
  reset(maestro); reset(det1); reset(det2); rewrite(advertencia);
  //writeln('se hizo reset');//
  //readln();                //

  leer(det1, reg1); leer(det2, reg2);
  //writeln('se leyo en registros');//
  //readln();                       //

  minimo (reg1, reg2, det1, det2, min);
  //writeln('minimo obtenido: ', min.destino,' ',min.fecha,' ',min.hora,' ',min.cantComprados);//
  //readln();                                                                               //
  while (min.destino <> valoralto) do begin
    //writeln('entró a while');//
    //readln();                //
    read (maestro, regM);
    //writeln('se leyo maestro');//
    //readln();
    //writeln('regM.destino: ',regM.destino,' | regM.fecha: ',regM.fecha,' | regM.hora: ',regM.hora),' | regM.cantAsientos: ',regM,cantAsientos);//
    //readln();                                                                                                                                  //
    while(min.destino <> regM.destino) and (min.fecha <> regM.fecha) and
    (min.hora <> regM.hora) do begin //
      writeln('Vuelo a ',regM.destino,' el ',regM.fecha,' a las ',regM.hora,'hs: Asientos Disponibles: ',regM.cantAsientos);
      if(regM.cantAsientos < valor) then begin
        writeln(advertencia,'Vuelo a ',regM.destino,' el ',regM.fecha,' a las ',regM.hora,'hs:');
        writeln(advertencia,'Advertencia -> Asientos disponibles: ',regM.cantAsientos,' | Cant. minima: ',valor);
        writeln('(Se registro el vuelo en advertencias.)');
      end;
      read(maestro, regM);
      //writeln('se leyo maestro');//
      //readln();
      //writeln('regM.destino: ',regM.destino,' | regM.fecha: ',regM.fecha,' | regM.hora: ',regM.hora),' | regM.cantAsientos: ',regM,cantAsientos);//
      //readln();                                                                                                                                  //
    end;//                                                                                              //
    while (min.destino = regM.destino) and (min.fecha = regM.fecha) and
    (min.hora = regM.hora) do begin
      regM.cantAsientos:= regM.cantAsientos - min.cantComprados;
      minimo(reg1, reg2, det1, det2, min);
      //writeln('minimo obtenido: ', min.destino,' ',min.fecha,' ',min.hora,' ',min.cantComprados);//
      //readln();//
    end;
    seek(maestro, filepos(maestro)-1);
    write(maestro, regM);
    //writeln('se actualizo el reg en maestro');//
    //readln();                                 //
    writeln('Vuelo a ',regM.destino,' el ',regM.fecha,' a las ',regM.hora,'hs: Asientos Disponibles: ',regM.cantAsientos);
    if(regM.cantAsientos < valor) then begin
      writeln(advertencia,'Vuelo a ',regM.destino,' el ',regM.fecha,' a las ',regM.hora,'hs:');
      writeln(advertencia,'Advertencia -> Asientos disponibles: ',regM.cantAsientos,' | Cant. minima: ',valor);
      writeln('(Se registro el vuelo en advertencias.)');
    end;
  end;
  close(maestro); close(det1); close(det2); close(advertencia);
  writeln('Archivo actualizado.');
end;

var
  master: arch_vuelos;
  detail1, detail2: arch_detalle;
  advertencias: Text;
  nom: String;
begin
  writeln('ENTER para crear archivo maestro.');
  readln();
  writeln('Ingrese el nombre fisico del archivo a crear.');
  readln(nom);
  nom:='C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom;
  assign(master, nom);
  crearArchivoMaestro(master);
  writeln();
  writeln('ENTER para crear archivo detalle 1.');
  readln();
  writeln('Ingrese el nombre fisico del archivo a crear.');
  readln(nom);
  nom:='C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom;
  assign(detail1, nom);
  crearArchivoDetalle(detail1);
  writeln();
  writeln('ENTER para crear archivo detalle 2.');
  readln();
  writeln('Ingrese el nombre fisico del archivo a crear.');
  readln(nom);
  nom:='C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom;
  assign(detail2, nom);
  crearArchivoDetalle(detail2);
  writeln();
  writeln('ENTER para actualizar el archivo maestro y generar un listado de advertencias.');
  readln();
  writeln('Ingrese el nombre fisico del archivo de advertencias a crear.');
  readln(nom);
  nom:='C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom+'.txt';
  assign(advertencias, nom);
  writeln('Se guardara en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
  actualizarMaestro(master, detail1, detail2, advertencias);
  writeln();
  writeln('ENTER para finalizar.');
  readln();
end.





