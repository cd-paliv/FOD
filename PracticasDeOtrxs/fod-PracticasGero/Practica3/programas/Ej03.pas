program ej3;
type
  novela = record
    cod: integer;
    genero: String;
    nombre: String;
    duracion: integer;
    director: String;
    precio: integer;
  end;

  arch_novelas = file of novela;

procedure crearArchivo (var archivo_logico: arch_novelas);
var
  n: novela;
begin
  rewrite(archivo_logico);
  n.cod:= 0; n.nombre:= '*'; //cabecera
  write(archivo_logico, n);
  writeln('Ingrese el codigo de la novela (0 para finalizar).');
  readln(n.cod);
  while(n.cod <> 0) do begin
    writeln('Ingrese el genero de la novela.');
    readln(n.genero);
    writeln('Ingrese el nombre de la novela.');
    readln(n.nombre);
    writeln('Ingrese la duracion de la novela.');
    readln(n.duracion);
    writeln('Ingrese el director de la novela.');
    readln(n.director);
    writeln('Ingrese el precio de la novela.');
    readln(n.precio);
    write(archivo_logico, n);
    writeln('Ingrese el codigo de la novela (0 para finalizar).');
    readln(n.cod);
  end;
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica3\archivos');
  close(archivo_logico);
end;

procedure alta (var archivo_logico: arch_novelas);
var
  n1, n2, auxn: novela;
begin
  writeln('Ingrese el codigo de la novela (0 para cancelar).');
  readln(n1.cod);
  if(n1.cod <> 0) then begin
    writeln('Ingrese el genero de la novela.');
    readln(n1.genero);
    writeln('Ingrese el nombre de la novela.');
    readln(n1.nombre);
    writeln('Ingrese la duracion de la novela.');
    readln(n1.duracion);
    writeln('Ingrese el director de la novela.');
    readln(n1.director);
    writeln('Ingrese el precio de la novela.');
    readln(n1.precio);
  end
  else
    exit;
  reset(archivo_logico);
  read(archivo_logico, n2);
  if (n2.cod <> 0) then begin //si cabecera tiene un NRR
    seek(archivo_logico, (-1*n2.cod)); //seek a ese NRR
    read(archivo_logico, auxn); //guardo su contenido en un aux
    seek(archivo_logico, filepos(archivo_logico)-1);
    write(archivo_logico, n1); //escribo el contenido de la alta
    seek(archivo_logico, 0); //voy a cabecera
    write(archivo_logico, auxn); //actualizo la cabecera
  end
  else begin
    seek(archivo_logico, filesize(archivo_logico));
    write(archivo_logico, n1);
  end;
  close(archivo_logico);
  writeln('Alta exitosa.');
end;

procedure modificar (var nombre_logico: arch_novelas);
var
   n: novela; busqueda: String;
begin
  reset(nombre_logico);
  writeln('Ingrese el nombre de la novela que desea modificar ("00" para finalizar)');
  readln(busqueda);
  while (busqueda <> '00') do begin
    while (not EOF(nombre_logico)) do begin
      read (nombre_logico, n);
      if (n.nombre = busqueda) then begin
         writeln('Ingrese el genero de la novela');
         readln(n.genero);
         writeln('Ingrese el nombre de la novela');
         readln(n.nombre);
         writeln('Ingrese la duracion de la novela');
         readln(n.duracion);
         writeln('Ingrese el director de la novela');
         readln(n.director);
         writeln('Ingrese el precio de la novela');
         readln(n.precio);
         seek(nombre_logico, (filePos(nombre_logico)-1));
         write(nombre_logico, n);
         writeln('Datos actualizados:');
         writeln('"',n.nombre,'" (',n.duracion,' minutos) | Director: ',n.director,' | Genero: ',n.genero,' | Precio: $',n.precio);
         writeln('------------------------------------------------------------------');
       end;
    end;
    seek(nombre_logico, 0);
    writeln('Ingrese el nombre de la novela que desea modificar ("00" para finalizar)');
    readln(busqueda);
  end;
  close(nombre_logico);
end;

procedure eliminar (var archivo_logico: arch_novelas);
var
  n, cabecera, aux: novela;
  busqueda: integer;
begin
  reset(archivo_logico);
  writeln('Ingrese el codigo de la novela que desea eliminar.');
  readln(busqueda);
  while (not EOF(archivo_logico)) do begin
    read(archivo_logico, n);
    if (n.cod = busqueda) then begin
      n.nombre:= '*'+n.nombre; //marco el nom del registro
      seek(archivo_logico, filepos(archivo_logico)-1);
      write(archivo_logico, n);
      aux:= n; //guardo el contenido del registro en aux
      aux.cod:= (filepos(archivo_logico)-1)*-1; //pongo como cod su pos en negativo
      seek(archivo_logico, 0);
      read(archivo_logico, cabecera); //guardo en una variable el contenido de cabecera
      seek(archivo_logico, filepos(archivo_logico)-1);
      write(archivo_logico, aux); //guardo en cabecera el contenido de aux
      seek(archivo_logico, aux.cod*-1); //voy al registro que eliminé
      write(archivo_logico, cabecera); //reemplazo el contenido del registro por lo que habia en cabecera
    end;
  end;
  close(archivo_logico);
  writeln('Novela eliminada.');
end;

procedure exportNovelas (var archivo_logico: arch_novelas; var texto_logico: Text);
var
  n: novela;
begin
  reset(archivo_logico); rewrite(texto_logico);
  while(not EOF(archivo_logico)) do begin
    read(archivo_logico, n);
    if(n.nombre[1] <> '*') then begin //si el primer caracter no es la marca
      writeln(texto_logico, '"',n.nombre,'" (Cod. ',n.cod,') --> Director: ',n.director,' | Duracion: ',n.duracion,' minutos');
      writeln(texto_logico, 'Genero: ',n.genero,' | Precio: $', n.precio);
      writeln(texto_logico,'----------------------------------------------------------------');
    end
    else begin
      writeln(texto_logico,'>>>>ESPACIO LIBRE (Registro eliminado)<<<<');
      writeln(texto_logico, '"',n.nombre,'" (Cod. ',n.cod,') --> Director: ',n.director,' | Duracion: ',n.duracion,' minutos');
      writeln(texto_logico, 'Genero: ',n.genero,' | Precio: $', n.precio);
      writeln(texto_logico,'----------------------------------------------------------------');
    end;
  end;
  close(archivo_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica3\archivos');
end;

procedure mantenimiento (var archivo_logico: arch_novelas);
var
  opc: integer;
begin
  writeln('¿Que tipo de mantenimiento desea realizar?');
  writeln('1: Alta.');
  writeln('2: Modificar un registro.');
  writeln('3: Baja.');
  writeln('0: Cancelar (Volver al menu principal).');
  readln(opc);
  while (opc <> 0) do begin
    case opc of
      1: begin
           alta(archivo_logico);
           writeln();
         end;
      2: begin
           modificar(archivo_logico);
           writeln();
         end;
      3: begin
           eliminar(archivo_logico);
           writeln();
         end
    else
      writeln('Elija una opcion correcta.');
    end;
    writeln('¿Que tipo de mantenimiento desea realizar?');
    writeln('1: Alta.');
    writeln('2: Modificar un registro.');
    writeln('3: Baja.');
    writeln('0: Cancelar (Volver al menu principal).');
    readln(opc);
  end;
end;

var
  novelas: arch_novelas;
  textoNovelas: Text;
  opc: integer;
  nom: String;
begin
  writeln('Seleccione una opcion del menu.');
  writeln('1: Crear un archivo de novelas.');
  writeln('2: Mantenimiento del archivo (Altas, Bajas, Actualizaciones).');
  writeln('3: Listar el contenido de archivo de novelas en un archivo txt.');
  writeln('0: Salir.');
  readln(opc);
  while (opc <> 0) do begin
    case opc of
      1: begin
           writeln('Ingrese el nombre fisico que tendra el archivo.');
           readln(nom);
           nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica3\archivos\'+nom;
           assign(novelas, nom);
           crearArchivo(novelas);
           writeln();
         end;
      2: begin
           writeln('Ingrese el nombre fisico del archivo.');
           readln(nom);
           nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica3\archivos\'+nom;
           assign(novelas, nom);
           mantenimiento(novelas);
           writeln();
         end;
      3: begin
           writeln('Ingrese el nombre fisico del archivo de novelas.');
           readln(nom);
           nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica3\archivos\'+nom;
           assign(novelas, nom);
           writeln('Ingrese el nombre fisico que tendra el archivo de texto.');
           readln(nom);
           nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica3\archivos\'+nom+'.txt';
           assign(textoNovelas, nom);
           exportNovelas(novelas, textoNovelas);
           writeln();
         end
    else
     writeln('No existe esa opcion. Intentalo de nuevo');
    end;
    writeln('Seleccione una opcion del menu.');
    writeln('1: Crear un archivo de novelas.');
    writeln('2: Mantenimiento del archivo (Altas, Bajas, Actualizaciones).');
    writeln('3: Listar el contenido de archivo de novelas en un archivo txt.');
    writeln('0: Salir.');
    readln(opc);
  end;
end.





