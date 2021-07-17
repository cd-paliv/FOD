program ej7;
type
  especie = record
    cod: integer;
    nom: String;
    familia: String;
    descripcion: String;
    zona: String;
  end;

  arch_especies = file of especie;

procedure crearArchivo (var archivo_logico: arch_especies);
var
  e: especie;
begin
  rewrite(archivo_logico);
  writeln('Ingrese el codigo de la especie (-1 para finalizar).');
  readln(e.cod);
  while(e.cod <> -1) do begin
    writeln('Ingrese el nombre de la especie.');
    readln(e.nom);
    writeln('Ingrese la familia de ave de la especie.');
    readln(e.familia);
    writeln('Ingrese la descripcion de la especie.');
    readln(e.descripcion);
    writeln('Ingrese la zona geografica en la que habita la especie.');
    readln(e.zona);
    write(archivo_logico, e);
    writeln('Ingrese el codigo de la especie (-1 para finalizar).');
    readln(e.cod);
  end;
  close(archivo_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica3\archivos');
end;

procedure bajaLogica (var archivo_logico: arch_especies);
var
  e: especie;
  baja: integer;
begin
  reset(archivo_logico);
  writeln('Ingrese el codigo de la especie que desea eliminar (100000 para finalizar).');
  readln(baja);
  while (baja <> 100000) do begin
    while (not EOF(archivo_logico)) do begin
      read(archivo_logico, e);
      if (e.cod = baja) then begin
        e.nom:= '*'+e.nom;
        seek(archivo_logico, filepos(archivo_logico)-1);
        write(archivo_logico, e);
      end;
    end;
    seek(archivo_logico, 0);
    writeln('Ingrese el codigo de la especie que desea eliminar (100000 para finalizar).');
    readln(baja);
  end;
  close(archivo_logico);
  writeln('Archivo actualizado.');
end;

procedure compactar (var archivo_logico: arch_especies);
var
  e: especie;
  auxPos: integer;
  auxEspecie: especie;
  i: integer;
begin
  reset(archivo_logico);
  while(not EOF(archivo_logico))do begin
    read(archivo_logico, e);
    if (e.nom[1] = '*') then begin
      auxPos:= filepos(archivo_logico)-1; //guardo la pos en la que está el dato a eliminar
      seek(archivo_logico, filesize(archivo_logico)-1); //voy al ultimo reg del archivo
      read(archivo_logico, auxEspecie); //guardo el contenido del mismo
      i:= 0;
      while (auxEspecie.nom[1] = '*') do begin //si el reg que lei tambien debe ser eliminado
        i:= i+1;
        seek(archivo_logico, (filesize(archivo_logico)-1)-i);
        read(archivo_logico, auxEspecie);
      end;
      seek(archivo_logico, filepos(archivo_logico)-1); //me posiciono en el reg a truncar
      Truncate(archivo_logico); //el ult reg pasa a ser EOF
      seek(archivo_logico, auxPos); //vuelvo a la pos en la que se encuentra la especie a eliminar
      write(archivo_logico, auxEspecie); //reemplazo por la ultima especie del archivo
    end;
  end;
  close(archivo_logico);
end;

procedure mostrar (var archivo_logico: arch_especies);
var
  e: especie;
begin
  reset(archivo_logico);
  while (not EOF(archivo_logico)) do begin
    read(archivo_logico, e);
    writeln('Especie: ',e.nom,' (cod. ',e.cod,') ---> Familia: ',e.familia);
    writeln('[ Zona Geografica: ',e.zona,' ]');
    writeln('Descripcion: ',e.descripcion);
    writeln('-----------------------------------------------------------------');
  end;
  close(archivo_logico);
end;

var
  especies: arch_especies;
  nom: String;
begin
  writeln('ENTER para crear el archivo de especies.');
  readln();
  writeln('Ingrese el nombre logico del archivo.');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica3\archivos\'+nom;
  assign(especies, nom);
  //crearArchivo(especies);
  writeln();
  mostrar(especies);
  writeln();
  writeln('ENTER para eliminar especies del archivo.');
  readln();
  bajaLogica(especies);
  writeln();
  compactar(especies);
  mostrar(especies);
  writeln();
  readln();
end.


