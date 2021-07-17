program ej7;
type
  novela = record
    cod: integer;
    nombre: string;
    genero: string;
    precio: integer;
  end;

  archivo_novelas = file of novela;
  texto_novelas = Text;

procedure crearArchivo (var archivo_logico: archivo_novelas; var texto_logico: texto_novelas);
var
 n: novela;
begin
  rewrite(archivo_logico);
  reset(texto_logico);
  while(not EOF(texto_logico)) do begin
    readln(texto_logico, n.cod, n.precio, n.genero);
    readln(texto_logico, n.nombre);
    write(archivo_logico, n);
  end;
  close(archivo_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica1\Archivos');
end;

procedure modificarNovelas (var archivo_logico: archivo_novelas);
var
  opc: integer; cod: integer; n: novela;
begin
  reset(archivo_logico);
  writeln('Ingrese el codigo de la novela que desea modificar (-1 para finalizar).');
  readln(cod);
  while (cod <> -1) do begin
    while(not EOF(archivo_logico)) do begin
      read(archivo_logico, n); //automaticamente incrementa el puntero
      if (n.cod = cod) then begin
        writeln('Eligio: ',n.nombre);
        writeln('Indique que campo de la novela desea modificar.');
        writeln('1: Codigo.');
        writeln('2: Nombre.');
        writeln('3: Precio.');
        writeln('4: Genero.');
        writeln('0: Finalizar edicion.');
        readln(opc);
        while (opc <> 0) do begin
          case opc of
            1: begin
                 writeln('Ingrese el nuevo codigo de la novela.');
                 readln(n.cod);
               end;
            2: begin
                 writeln('Ingrese el nuevo nombre de la novela.');
                 readln(n.nombre);
               end;
            3: begin
                 writeln('Ingrese el nuevo precio de la novela.');
                 readln(n.precio);
               end;
            4: begin
                 writeln('Ingrese el nuevo genero de la novela.');
                 readln(n.genero);
               end;
          else
            writeln('Elija una opcion correcta.');
          end;
          writeln('Indique que campo de la novela desea modificar.');
          writeln('1: Codigo.');
          writeln('2: Nombre.');
          writeln('3: Precio.');
          writeln('4: Genero.');
          writeln('0: Finalizar edicion.');
          readln(opc);
        end;
        seek(archivo_logico, (filePos(archivo_logico)-1));
        //vuelvo hacia el registro que debo modificar
        write(archivo_logico, n);
        writeln('Novela modificada con exito.');
        break;
      end;
    end;
    seek(archivo_logico, 0); //vuelvo al inicio
    writeln('Ingrese el codigo de la novela que desea modificar (-1 para finalizar).');
    readln(cod);
  end;
  close(archivo_logico);
end;

procedure imprimir (var archivo_logico: archivo_novelas);
var
  n: novela;
begin
  reset(archivo_logico);
  while (not EOF(archivo_logico)) do begin
    read(archivo_logico, n);
    writeln(n.nombre,' (cod. ',n.cod,') | Precio: $',n.precio);
    writeln('Genero: ',n.genero);
  end;
  close(archivo_logico);
end;

var
  nombre_fisico: string;
  novelas: archivo_novelas;
  texto: texto_novelas;
  opc: integer;
begin
  writeln('Ingrese el nombre fisico del archivo');
  readln(nombre_fisico);
  nombre_fisico:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica1\Archivos\' + nombre_fisico;
  assign(novelas, nombre_fisico);
  assign(texto, 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica1\Archivos\novelas.txt');
  writeln('Eliga una opcion del menu.');
  writeln('1: Crear un archivo binario a partir de "novelas.txt".');
  writeln('2: Actualizar el archivo binario.');
  writeln('0: Salir.');
  readln(opc);
  while (opc <> 0) do begin
    case opc of
      1: begin
           crearArchivo(novelas, texto);
           imprimir(novelas);
         end;
      2: begin
           modificarNovelas(novelas);
           imprimir(novelas);
         end;
    else
      writeln('Ingrese una opcion correcta');
    end;
    writeln('Eliga una opcion del menu.');
    writeln('1: Crear un archivo binario a partir de "novelas.txt".');
    writeln('2: Actualizar el archivo binario.');
    writeln('0: Salir.');
    readln(opc);
  end;
end.


