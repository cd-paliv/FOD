program ej5;
uses sysutils;
const valoralto = 9999;

type
  producto = record
    cod: integer;
    nombre: String;
    precio: integer;
    stock: integer;
    stockMin: integer;
  end;

  venta = record
    cod: integer;
    cantV: integer;
  end;

  arch_maestro = file of producto;
  arch_detalle = file of venta;

procedure crearArchivoMaestro (var archivo_logico: arch_maestro; var texto_logico: Text);
var
  p: producto;
begin
  rewrite(archivo_logico); reset(texto_logico);
  while(not EOF(texto_logico)) do begin
    readln(texto_logico, p.cod, p.nombre);
    readln(texto_logico, p.precio, p.stockMin, p.stock);
    p.nombre:= Trim(p.nombre);
    write(archivo_logico, p);
  end;
  close(archivo_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure exportMaestro (var archivo_logico: arch_maestro; var texto_logico: Text);
var
  p: producto;
begin
  reset(archivo_logico);
  rewrite(texto_logico);
  while (not EOF(archivo_logico)) do begin
    read (archivo_logico, p);
    writeln(texto_logico,'Producto ',p.cod,' (',p.nombre,'): Precio: ',p.precio,' | Stock Min: ',p.stockMin,' | Stock Act: ',p.stock);
    writeln(texto_logico,'---------------------------------------------------------------------------------------------------------');
  end;
  close(archivo_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure crearArchivoDetalle (var archivo_logico: arch_detalle; var texto_logico: Text);
var
  v: venta;
begin
  rewrite(archivo_logico); reset(texto_logico);
  while(not EOF(texto_logico)) do begin
    readln(texto_logico, v.cod, v.cantV);
    write(archivo_logico, v);
  end;
  close(archivo_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure printDetalle (var archivo_logico: arch_detalle);
var
  v: venta;
begin
  reset(archivo_logico);
  while (not EOF(archivo_logico)) do begin
    read (archivo_logico, v);
    writeln('Producto ',v.cod,': Cantidad de Ventas: ',v.cantV);
  end;
  writeln('------------------------------------------------');
  close(archivo_logico);
end;

procedure leer (var archivo_logico: arch_detalle; var reg: venta);
begin
  if (not EOF(archivo_logico)) then
    read (archivo_logico, reg)
  else
    reg.cod:= valoralto;
end;

procedure actualizarMaestro (var maestro_logico: arch_maestro; var detalle_logico: arch_detalle);
var
  regDet: venta;
  regMae: producto;
  aux: integer;
  totalV: integer;
begin
  reset(maestro_logico); reset(detalle_logico);
  read(maestro_logico, regMae);
  writeln('maestro obtenido: ',regMae.cod,' ',regMae.nombre,' ',regMae.precio,' ',regMae.stockMin,' ',regMae.stock);//
  readln();                                                                                                         //
  leer(detalle_logico, regDet);
  writeln('detalle obtenido: ',regDet.cod,' ',regDet.cantV);//
  readln();                                                 //
  while (regDet.cod <> valoralto) do begin
    aux:= regDet.cod;
    totalV:= 0;
    while (aux = regDet.cod) do begin
      totalV:= totalV + regDet.cantV;
      writeln('ventas act: ',totalV);//
      readln();                      //
      leer(detalle_logico, regDet);
      writeln('detalle obtenido: ',regDet.cod,' ',regDet.cantV);//
      readln();                                                 //
    end;
    while (regMae.cod <> aux) do
      read (maestro_logico, regMae);
    regMae.stock:= regMae.stock - totalV;
    writeln('stock actualizado: ',regMae.stock);//
    readln();                                   //
    seek(maestro_logico, filepos(maestro_logico)-1);
    write(maestro_logico, regMae);
    writeln('se escribio en maestro');//
    readln();                         //
    if (not EOF(maestro_logico)) then
      read(maestro_logico, regMae);
      writeln('maestro obtenido: ',regMae.cod,' ',regMae.nombre,' ',regMae.precio,' ',regMae.stockMin,' ',regMae.stock);//
      readln();                                                                                                         //
  end;
  close(maestro_logico); close(detalle_logico);
  writeln('Archivo actualizado con exito.');
end;

procedure exportLowStock (var archivo_logico: arch_maestro; var texto_logico: Text);
var
  p: producto;
begin
  reset(archivo_logico); rewrite(texto_logico);
  while (not EOF(archivo_logico)) do begin
    read (archivo_logico, p);
    if (p.stock < p.stockMin) then begin
      writeln(texto_logico,'Producto ',p.cod,' (',p.nombre,'): Precio: ',p.precio,' | Stock Min: ',p.stockMin,' | Stock Act: ',p.stock);
      writeln(texto_logico,'---------------------------------------------------------------------------------------------------------');
    end;
  end;
  close(archivo_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

var
  master: arch_maestro;
  detail: arch_detalle;
  nom: String;
  textMaster, textDetail, reportMaster, reportStock: Text;
  cod: integer;
begin
  assign(textMaster, 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\productos.txt');
  assign(textDetail, 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\ventas.txt');
  assign(reportMaster, 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\reporte.txt');
  assign(reportStock, 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\stock_minimo.txt');
  writeln('Eliga una opcion del menu');
  writeln('1: Crear un archivo maestro de productos a partir de "productos.txt".');
  writeln('2: Crear un archivo detalle de ventas a partir de "ventas.txt".');
  writeln('3: Listar el contenido del archivo maestro en "reporte.txt".');
  writeln('4: Listar el contenido del archivo detalle en pantalla.');
  writeln('5: Actualizar el archivo maestro con los datos del archivo detalle.');
  writeln('6: Listar en un archivo .txt a los productos que tengan un stock menor al minimo permitido en "stock_minimo.txt".');
  writeln('0: Salir.');
  readln(cod);
  while (cod <> 0) do begin
    case cod of
      1: begin
           writeln('Ingrese el nombre fisico del archivo maestro a crear');
           readln(nom);
           nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom;
           assign(master, nom);
           crearArchivoMaestro(master, textMaster);
           writeln();
         end;
      2: begin
           writeln('Ingrese el nombre fisico del archivo detalle a crear');
           readln(nom);
           nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom;
           assign(detail, nom);
           crearArchivoDetalle(detail, textDetail);
           writeln();
         end;
      3: begin
           exportMaestro (master, reportMaster);
           writeln();
         end;
      4: begin
           printDetalle(detail);
           writeln();
         end;
      5: begin
           actualizarMaestro(master, detail);
           writeln();
         end;
      6: begin
           exportLowStock(master, reportStock);
           writeln();
         end;
    else
      writeln('No existe esa opcion. Intentalo de nuevo');
    end;
    writeln('Eliga una opcion del menu');
    writeln('1: Crear un archivo maestro de productos a partir de "productos.txt".');
    writeln('2: Crear un archivo detalle de ventas a partir de "ventas.txt".');
    writeln('3: Listar el contenido del archivo maestro en "reporte.txt".');
    writeln('4: Listar el contenido del archivo detalle en pantalla.');
    writeln('5: Actualizar el archivo maestro con los datos del archivo detalle.');
    writeln('6: Listar en un archivo .txt a los productos que tengan un stock menor al minimo permitido.');
    writeln('0: Salir.');
    readln(cod);
  end;
end.









