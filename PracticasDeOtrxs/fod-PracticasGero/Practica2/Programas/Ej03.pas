program ej3;
const valoralto = 9999;

type
  producto = record
    cod: integer;
    descripcion: String;
    precio: integer;
    stock: integer;
    stockMin: integer;
  end;

  detalle = record
    cod: integer;
    cantPedida: integer;
  end;

  archivo_maestro = file of producto;
  archivo_detalle = file of detalle;

procedure crearArchivoMaestro (var archivo_logico: archivo_maestro);
var
  p: producto;
begin
  rewrite(archivo_logico);
  writeln('Ingrese el codigo del producto (-1 para finalizar).');
  readln(p.cod);
  while(p.cod <> -1) do begin
    writeln('Ingrese la descripcion del producto.');
    readln(p.descripcion);
    writeln('Ingrese el precio del producto.');
    readln(p.precio);
    writeln('Ingrese el stock minimo del producto.');
    readln(p.stockMin);
    writeln('Ingrese el stock actual del producto.');
    readln(p.stock);
    write(archivo_logico, p);
    writeln('Ingrese el codigo del producto (-1 para finalizar).');
    readln(p.cod);
  end;
  close(archivo_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure crearArchivoDetalle (var archivo_logico: archivo_detalle);
var
  d: detalle;
begin
  rewrite(archivo_logico);
  writeln('Ingrese el codigo del producto (-1 para finalizar).');
  readln(d.cod);
  while(d.cod <> -1) do begin
    writeln('Ingrese la cantidad de productos pedidos.');
    readln(d.cantPedida);
    write(archivo_logico, d);
    writeln('Ingrese el codigo del producto (-1 para finalizar).');
    readln(d.cod);
  end;
  close(archivo_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure leer (var archivo_logico: archivo_detalle; var reg: detalle);
begin
  if (not EOF(archivo_logico)) then
    read (archivo_logico, reg)
  else
    reg.cod:= valoralto;
end;

procedure minimo (var reg1, reg2, reg3, reg4: detalle; var det1, det2, det3, det4: archivo_detalle;
var min: detalle; var suc: integer);
begin
  if ((reg1.cod<=reg2.cod) and (reg1.cod<=reg3.cod) and (reg1.cod<=reg4.cod)) then begin
    min:= reg1;
    leer(det1, reg1);
    suc:= 1;
  end
  else if ((reg2.cod <= reg3.cod) and (reg2.cod<=reg4.cod)) then begin
         min:= reg2;
         leer(det2, reg2);
         suc:= 2;
       end
       else if (reg3.cod<=reg4.cod) then begin
              min:= reg3;
              leer(det3, reg3);
              suc:= 3;
            end
            else begin
              min:= reg4;
              leer(det4, reg4);
              suc:= 4;
            end;
end;

procedure actualizarMaestro (var maestro: archivo_maestro; var det1, det2, det3, det4: archivo_detalle;
var lowStock, insuficientes: Text);
var
  reg1, reg2, reg3, reg4, min: detalle;
  regM: producto;
  suc: integer;
begin
  reset(maestro); reset(det1); reset(det2); reset(det3); reset(det4);
  rewrite(lowStock); rewrite(insuficientes);
  writeln('se hizo reset y rewrite');//
  readln();                          //

  leer(det1, reg1); leer(det2, reg2); leer(det3, reg3); leer(det4, reg4);
  writeln('se leyo en registros');//
  readln();                       //

  minimo (reg1, reg2, reg3, reg4, det1, det2, det3, det4, min, suc);
  writeln('minimo obtenido: ', min.cod,' ',min.cantPedida);//
  readln();                                                //
  while (min.cod <> valoralto) do begin
    read (maestro, regM);
    writeln('se leyo maestro');//
    readln();
    writeln('min.cod: ',min.cod,'| regM.cod: ',regM.cod);//
    readln();                                            //                  //
    while(min.cod <> regM.cod) do
      read(maestro, regM);
    while (min.cod = regM.cod) do begin
      regM.stock:= regM.stock - min.cantPedida;
      writeln('stock actualizado: ',regM.stock);//
      readln();                                 //
      if (regM.stock < 0) then begin
        writeln(insuficientes,'Pedido: ',min.cantPedida,' unidades del producto ',min.cod,' por parte de la sucursal ',suc);
        writeln(insuficientes, '------------------------------------------------------');
        writeln('se escribio en reporte insuf');//
        readln();                               //
      end;
      minimo (reg1, reg2, reg3, reg4, det1, det2, det3, det4, min, suc);
      writeln('minimo obtenido: ', min.cod,' ',min.cantPedida);//
      readln();                                                //
    end;
    if (regM.stock < regM.stockMin) then begin
      writeln(lowStock, 'Cod. Producto: ',regM.cod,' | Descripción: ',regM.descripcion,' | Precio: $',regM.precio);
      writeln(lowStock, 'Stock Minimo: ',regM.stockMin,' | Stock actual: ',regM.stock);
      writeln(lowStock, '------------------------------------------------------');
      writeln('se escribio en reporte lowstock');//
      readln();                                  //
    end;
    seek(maestro, filepos(maestro)-1);
    write(maestro, regM);
    writeln('se actualizo el reg en maestro');//
    readln();                               //
  end;
  close(maestro); close(det1); close(det2); close(det3); close(det4); close(lowStock); close(insuficientes);
  writeln('Archivo actualizado. Reportes Generados en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos.');
end;

var
  master: archivo_maestro;
  det1, det2, det3, det4: archivo_detalle;
  lowStock, insuficientes: Text;
  nom: String;
  i: integer;
begin
  writeln('ENTER para crear el archivo de productos.');
  readln();
  writeln('Ingrese el nombre fisico del archivo.');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\' + nom;
  assign(master, nom);
  crearArchivoMaestro(master);
  writeln();

  writeln('ENTER para crear el archivo de pedidos de la sucursal 1.');
  readln();
  writeln('Ingrese el nombre fisico.');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\' + nom;
  assign(det1, nom);
  crearArchivoDetalle(det1);
  writeln();

  writeln('ENTER para crear el archivo de pedidos de la sucursal 2.');
  readln();
  writeln('Ingrese el nombre fisico.');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\' + nom;
  assign(det2, nom);
  crearArchivoDetalle(det2);
  writeln();

  writeln('ENTER para crear el archivo de pedidos de la sucursal 3.');
  readln();
  writeln('Ingrese el nombre fisico.');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\' + nom;
  assign(det3, nom);
  crearArchivoDetalle(det3);
  writeln();

  writeln('ENTER para crear el archivo de pedidos de la sucursal 4.');
  readln();
  writeln('Ingrese el nombre fisico.');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\' + nom;
  assign(det4, nom);
  crearArchivoDetalle(det4);
  writeln();

  writeln('ENTER para actualizar el maestro y generar reportes.');
  readln();
  writeln('Ingrese el nombre del reporte de productos con bajo stock');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom+'.txt';
  assign(lowStock, nom);
  writeln('Ingrese el nombre del reporte de productos con stock insuficiente');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom+'.txt';
  assign(insuficientes, nom);
  actualizarMaestro(master, det1, det2, det3, det4, lowStock, insuficientes);
  readln();
end.





