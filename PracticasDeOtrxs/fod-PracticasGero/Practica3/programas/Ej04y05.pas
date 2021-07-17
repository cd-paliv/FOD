program ej4;
uses sysutils;
type
  tTitulo = String[50];
  tArchRevistas = file of tTitulo;

procedure crearArchivo (var archivo_logico: tArchRevistas);
var
  aux: tTitulo;
begin
  rewrite(archivo_logico);
  aux:= '0';
  write(archivo_logico, aux);
  aux:= 'test';              //
  write(archivo_logico, aux);//
  close(archivo_logico);
end;

procedure alta (var archivo_logico: tArchRevistas; titulo: tTitulo);
var
  titulo2, auxT: tTitulo;
begin
  reset(archivo_logico);
  writeln('se hizo reset');//
  readln();                //
  read(archivo_logico, titulo2);
  writeln('se leyo en titulo2: ',titulo2);//
  readln();                               //
  if (titulo2 <> '0') then begin //si cabecera tiene un NRR
    writeln('entro al if');//
    readln();                //
    seek(archivo_logico, StrToInt(titulo2));//seek a ese NRR
    writeln('se hizo seek: ',filepos(archivo_logico));//
    readln();                                         //
    read(archivo_logico, auxT); //guardo su contenido en un aux
    writeln('se guardo en aux: ',auxT);//
    readln();                          //
    seek(archivo_logico, filepos(archivo_logico)-1);
    writeln('se hizo seek: ',filepos(archivo_logico));//
    readln();                                         //
    write(archivo_logico, titulo); //escribo el contenido de la alta
    writeln('se guardo el contenido de alta: ',titulo);//
    readln();                                          //
    seek(archivo_logico, 0); //voy a cabecera
    writeln('se hizo seek: ',filepos(archivo_logico));//
    readln();                                         //
    write(archivo_logico, auxT); //actualizo la cabecera
    writeln('se actualizo cabecera');//
    readln();                        //
  end
  else begin
    writeln('entro al else');//
    readln();                //
    seek(archivo_logico, filesize(archivo_logico));
    writeln('se hizo seek: ',filepos(archivo_logico));//
    readln();                                         //
    write(archivo_logico, titulo);
    writeln('se guardo el contenido de alta: ',titulo);//
    readln();                                          //
  end;
  writeln('enter para cerrar');//
  readln();                    //
  close(archivo_logico);
  writeln('Alta exitosa.');
end;

procedure eliminar (var archivo_logico: tArchRevistas; busqueda: tTitulo);
var
  titulo, cabecera, aux: tTitulo;
begin
  reset(archivo_logico);
  read(archivo_logico, cabecera);
  while (not EOF(archivo_logico)) do begin
    read(archivo_logico, titulo);
    writeln('se leyo titulo: ',titulo);//
    readln();                          //
    if (titulo = busqueda) then begin
      aux:= IntToStr((filepos(archivo_logico)-1));//guardo en aux el NRR del titulo eliminado
      writeln('se actualizo aux: ',aux);//
      readln();                         //
      seek(archivo_logico, filepos(archivo_logico)-1); //voy al registro que eliminé
      writeln('se hizo seek: ',filepos(archivo_logico));//
      readln();                                         //
      write(archivo_logico, cabecera); //reemplazo el contenido del registro por lo que habia en cabecera
      writeln('se escribio el contenido de auxiliar cabecera en el reg eliminado. enter para salir del if');//
      readln();                                                                                             //
      seek(archivo_logico, 0);
      write(archivo_logico, aux); //guardo en cabecera el contenido de aux
      writeln('se guardo aux en la cabecera');//
      readln();                               //
      break;
    end;
  end;
  close(archivo_logico);
  writeln('Novela eliminada.');
end;

procedure mostrarTitulos (var nombre_logico: tArchRevistas);
var
  titulo: tTitulo;
  numero, error: integer;
begin
  reset(nombre_logico);
  writeln('Revistas:');
  while (not EOF(nombre_logico))do begin
    read (nombre_logico, titulo);
    val(titulo, numero, error); //intenta convertir el titulo en un numero
    if (error <> 0) then  //si da error (es un titulo) lo imprime, si no da error es xq es una pos libre (contiene NRR)
      writeln('Revista: ',titulo);
  end;
  writeln('------------------------------------------------------------------');
  close(nombre_logico);
end;

var
  revistas: tArchRevistas;
  nom, aux: String;
  opc: integer;
begin
  writeln('Ingrese el nombre fisico del archivo de revistas.');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica3\archivos\'+nom;
  assign(revistas, nom);
  //crearArchivo(revistas);
  writeln('Elija una opcion.');
  writeln('1: Alta.');
  writeln('2: Baja.');
  writeln('3: Mostrar revistas.');
  writeln('0: Salir.');
  readln(opc);
  while(opc <> 0) do begin
    case opc of
      1: begin
           writeln('Ingrese el titulo que quiere agregar.');
           readln(aux);
           alta(revistas, aux);
           writeln();
         end;
      2: begin
           writeln('Ingrese el titulo que quiere eliminar.');
           readln(aux);
           eliminar (revistas, aux);
           writeln();
         end;
      3: begin
           mostrarTitulos(revistas);
           writeln();
         end
    else
      writeln('Ingrese una opcion correcta.');
    end;
    writeln('Elija una opcion.');
    writeln('1: Alta.');
    writeln('2: Baja.');
    writeln('3: Mostrar revistas.');
    writeln('0: Salir.');
    readln(opc);
  end;
end.
