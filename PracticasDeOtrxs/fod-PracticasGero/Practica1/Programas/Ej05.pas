program ej5;
uses sysutils;
type
  electrodomestico = record
    cod: integer;
    precio: integer;
    nombre: string;
    stock: integer;
    stockMinimo: integer;
    descripcion: string;
  end;

  archivo_electrodomesticos = file of electrodomestico;

  texto_electrodomesticos = Text;

procedure crearArchivo (var archivo_logico: archivo_electrodomesticos; var texto_logico: texto_electrodomesticos);
var
  e: electrodomestico;
begin
  rewrite(archivo_logico); reset(texto_logico);
  while(not EOF(texto_logico)) do begin
    readln(texto_logico,e.cod,e.precio,e.nombre);
    readln(texto_logico,e.stock,e.stockMinimo,e.descripcion);
    e.nombre:= Trim(e.nombre); e.descripcion:= Trim(e.descripcion);
    write(archivo_logico, e);
  end;
  close(archivo_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica1\Archivos');
end;

procedure stockInsuficiente (var archivo_logico: archivo_electrodomesticos);
var
  e: electrodomestico;
begin
  reset(archivo_logico);
  while(not EOF(archivo_logico)) do begin
    read(archivo_logico, e);
    if (e.stock < e.stockMinimo) then begin
      writeln(e.nombre,'(cod. producto: ',e.cod,'): Precio: $',e.precio,' |');
      writeln('Descripcion: ',e.descripcion,' |');
      writeln('Stock minimo: ',e.stockMinimo,' | Stock actual: ',e.stock);
      writeln('----------------------------------------------------------------');
    end;
  end;
  close(archivo_logico);
end;

procedure buscarDescripcion (var archivo_logico: archivo_electrodomesticos);
var
  e: electrodomestico;
  desc: string;
begin
  reset(archivo_logico);
  writeln('Ingrese la descripcion que desea buscar');
  readln(desc);
  while(not EOF(archivo_logico)) do begin
    read(archivo_logico, e);
    if (e.descripcion = desc) then begin
      writeln(e.nombre,'(cod. producto: ',e.cod,'): Precio: $',e.precio,' |');
      writeln('Descripcion: ',e.descripcion,' |');
      writeln('Stock minimo: ',e.stockMinimo,' | Stock actual: ',e.stock);
      writeln('----------------------------------------------------------------');
    end;
  end;
  close(archivo_logico);
end;

procedure exportElectro (var archivo_logico: archivo_electrodomesticos; var texto_logico: texto_electrodomesticos);
var
  e: electrodomestico;
begin
  reset(archivo_logico);
  rewrite(texto_logico);
  while (not EOF(archivo_logico)) do begin
    read (archivo_logico, e);
    writeln(texto_logico,'Cod: ',e.cod,' | Precio: ',e.precio,' | Nombre: ',e.nombre);
    writeln(texto_logico,'Stock Disponible: ',e.stock,' | Stock minimo: ', e.stockMinimo);
    writeln(texto_logico,'Descripcion: ',e.descripcion);
    writeln(texto_logico,'---------------------------------------------------------------');
  end;
  close(archivo_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica1\Archivos');
end;

//Ej 06
procedure aniadirElectro (var archivo_logico: archivo_electrodomesticos);
var
   e: electrodomestico;
begin
  reset(archivo_logico);
  seek(archivo_logico, filesize(archivo_logico));
  writeln('Ingrese el codigo del electrodomestico (-1 para volver al menu)');
  readln(e.cod);
  while (e.cod <> -1) do begin
    writeln('Ingrese el precio del electrodomestico');
    readln(e.precio);
    writeln('Ingrese el nombre del electrodomestico');
    readln(e.nombre);
    writeln('Ingrese el stock disponible');
    readln(e.stock);
    writeln('Ingrese el stock minimo');
    readln(e.stockMinimo);
    writeln('Ingrese la descripcion');
    readln(e.descripcion);
    write(archivo_logico, e);
    writeln('Ingrese el codigo del electrodomestico (-1 para volver al menu)');
    readln(e.cod);
  end;
  close(archivo_logico);
end;

procedure modificarStock (var archivo_logico: archivo_electrodomesticos);
var
   e: electrodomestico; busqueda: integer;
begin
  reset(archivo_logico);
  writeln('Ingrese el codigo del electrodomestico del cual desea modificar el stock (-1 para finalizar)');
  readln(busqueda);
  while (busqueda <> -1) do begin
    while (not EOF(archivo_logico)) do begin
      read (archivo_logico, e);
      if (e.cod = busqueda) then begin
         writeln('Ingrese el nuevo stock');
         readln(e.stock);
         seek(archivo_logico, (filePos(archivo_logico)-1));
         write(archivo_logico, e);
         writeln('Datos actualizados:');
         writeln(e.nombre,'(cod. producto: ',e.cod,'): Precio: $',e.precio,' |');
         writeln('Descripcion: ',e.descripcion,' |');
         writeln('Stock minimo: ',e.stockMinimo,' | Stock actual: ',e.stock);
         writeln('----------------------------------------------------------------');
       end;
    end;
    seek(archivo_logico, 0);
    writeln('Ingrese el codigo del electrodomestico del cual desea modificar el stock (-1 para finalizar)');
    readln(busqueda);
  end;
  close(archivo_logico);
end;

procedure exportStock (var archivo_logico: archivo_electrodomesticos; var texto_logico: texto_electrodomesticos);
var
  e: electrodomestico;
begin
  reset(archivo_logico);
  rewrite(texto_logico);
  while (not EOF(archivo_logico)) do begin
    read (archivo_logico, e);
    if (e.stock = 0) then begin
      writeln(texto_logico,'Cod: ',e.cod,' | Precio: ',e.precio,' | Nombre: ',e.nombre);
      writeln(texto_logico,'Stock Disponible: ',e.stock,' | Stock minimo: ', e.stockMinimo);
      writeln(texto_logico,'Descripcion: ',e.descripcion);
      writeln(texto_logico,'---------------------------------------------------------------');
    end;
  end;
  close(archivo_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica1\Archivos');
end;

var
  electrodomesticos: archivo_electrodomesticos;
  nombre_fisico: string;
  texto1: texto_electrodomesticos;
  texto2: texto_electrodomesticos;
  cod: integer;
begin
  assign(texto1, 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica1\Archivos\carga.txt');
  assign(texto2, 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica1\Archivos\SinStock.txt');
  writeln('Ingrese el nombre fisico del archivo');
  readln(nombre_fisico);
  nombre_fisico:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica1\Archivos\' + nombre_fisico;
  assign(electrodomesticos, nombre_fisico);
  writeln('Eliga una opcion del menu');
  writeln('1: Crear un archivo de electrodomesticos a partir de "electro.txt".');
  writeln('2: Listar los datos de los electrodomesticos con un stock menor al minimo.');
  writeln('3: Listar los electrodomesticos que cumplan con una determinada descripcion.');
  writeln('4: Exportar el archivo ',nombre_fisico,' a "electro.txt".');
  //ej 06
  writeln('5: Añadir mas electrodomesticos al final del archivo.');
  writeln('6: Modificar el stock de uno o mas electrodomesticos.');
  writeln('7: Exportar los datos de los electrodomesticos sin stock a "SinStock.txt".');
  writeln('0: Salir.');
  readln(cod);
  while (cod <> 0) do begin
    case cod of
      1: crearArchivo(electrodomesticos, texto1);
      2: stockInsuficiente(electrodomesticos);
      3: buscarDescripcion (electrodomesticos);
      4: exportElectro(electrodomesticos, texto1);
      5: aniadirElectro(electrodomesticos);
      6: modificarStock(electrodomesticos);
      7: exportStock(electrodomesticos, texto2);
    else
      writeln('No existe esa opcion. Intentalo de nuevo');
    end;
    writeln('Eliga una opcion del menu');
    writeln('1: Crear un archivo de electrodomesticos a partir de "electro.txt".');
    writeln('2: Listar los datos de los electrodomesticos con un stock menor al minimo.');
    writeln('3: Listar los electrodomesticos que cumplan con una determinada descripcion.');
    writeln('4: Exportar el archivo ',nombre_fisico,' a "electro.txt".');
    //ej 06
    writeln('5: Añadir mas electrodomesticos al final del archivo.');
    writeln('6: Modificar el stock de uno o mas electrodomesticos.');
    writeln('7: Exportar los datos de los electrodomesticos sin stock a "SinStock.txt".');
    writeln('0: Salir.');
    readln(cod);
  end;
end.

