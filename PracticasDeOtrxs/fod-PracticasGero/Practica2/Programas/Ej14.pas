program ej14;
const
  valoralto = 999999999;
  dimF = 3;
type
  emision = record
    date: integer;
    cod: integer;
    nombre: String;
    descripcion: String;
    precio: integer;
    totEjemplares: integer;
    totVendidos: integer;
  end;

  venta = record
    date: integer;
    cod: integer;
    cantVentas: integer;
  end;

  arch_emisiones = file of emision;
  arch_regDet = array [1..dimF] of file of venta;
  arch_ventas = array [1..dimf] of venta;


procedure crearArchivoMaestro (var archivo_logico: arch_emisiones);
var
  e: emision;
begin
  rewrite(archivo_logico);
  writeln('Ingrese la fecha de la emision ([aaaammdd]. 0 para finalizar).');
  readln(e.date);
  while(e.date <> 0) do begin
    writeln('Ingrese el codigo de la emision.');
    readln(e.cod);
    writeln('Ingrese el nombre de la emision.');
    readln(e.nombre);
    writeln('Ingrese la descripcion de la emision.');
    readln(e.descripcion);
    writeln('Ingrese el precio de la emision.');
    readln(e.precio);
    writeln('Ingrese la cantidad de ejemplares.');
    readln(e.totEjemplares);
    writeln('Ingrese el total de ventas.');
    readln(e.totVendidos);
    write(archivo_logico, e);
    writeln('Ingrese la fecha de la emision ([aaaammdd].0 para finalizar).');
    readln(e.date);
  end;
  close(archivo_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure crearArchivoDetalle (var archivo_logico: file of venta);
var
  v: venta;
begin
  rewrite(archivo_logico);
  writeln('Ingrese la fecha de la venta (0 para finalizar).');
  readln(v.date);
  while(v.date <> 0) do begin
    writeln('Ingrese el codigo de la emision vendida.');
    readln(v.cod);
    writeln('Ingrese la cantidad de ejemplares vendidos.');
    readln(v.cantVentas);
    write(archivo_logico, v);
    writeln('Ingrese la fecha de la venta (0 para finalizar).');
    readln(v.date);
  end;
  close(archivo_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure leer (var archivo_logico: file of venta; var reg: venta);
begin
  if (not EOF(archivo_logico)) then
    read (archivo_logico, reg)
  else begin
    reg.date:= valoralto; reg.cod:= valoralto;
  end;
end;

procedure minimo (var vec_det: arch_ventas; var min: venta; var vec_reg: arch_regDet);
var
  i, posMin, minDate, codminimo: integer;
begin
  posMin:= 0;
  minDate:= 99999999; codminimo:= 99999999;
  for i:= 1 to dimF do begin
    if (vec_det[i].date < minDate) then begin
      minDate:= vec_det[i].date;
      codminimo:= vec_det[i].cod;
      posMin:= i;
    end
    else if (vec_det[i].date = minDate) then
      if (vec_det[i].cod <= codminimo) then begin
        minDate:= vec_det[i].date;
        codminimo:= vec_det[i].cod;
        posMin:= i;
      end;
  end;
  if (posMin <> 0) then begin //si econtré min
    min:= vec_det[posMin];
    leer(vec_reg[posMin], vec_det[posMin]);
    //leo el siguiente detalle del archivo al cual correspondia el detalle "min"
    //y lo guardo en el vector de detalles ocupando la posicion que "min" acaba de liberar
  end
  else begin
    min.date:= valoralto;
    min.cod:= valoralto;
    min.cantVentas:= 0;
  end;
end;

procedure merge (var maestro_logico: arch_emisiones; var vec_reg: arch_regDet; var vec_det: arch_ventas);
var
  regM, auxMax, auxMin: emision;
  i, maxVentas, minVentas: integer;
  min: venta;
begin
  maxVentas:= 0; minVentas:= 9999;
  for i:= 1 to dimF do begin
    reset (vec_reg[i]);
    writeln('se hizo reset del reg ',i); //
    readln();                            //
    leer (vec_reg[i], vec_det[i]);
    //guardo el primer detalle de cada registro en su pos correspondiente el vector de detalles
    writeln('primer detalle del reg ',i,' guardado');  //
    writeln('vec_det[',i,'].date: ',vec_det[i].date);    //
    writeln('vec_det[',i,'].cod: ',vec_det[i].cod);//
    readln();                                          //
  end;
  writeln('enter para hacer reset a maestro');//
  readln();                                     //
  reset(maestro_logico);
  writeln('se hizo reset del maestro'); //
  readln();                               //
  minimo (vec_det, min, vec_reg);
  writeln('minimo obtenido: ',min.date,' ',min.cod,' ',min.cantVentas); //
  readln();                                                            //
  while (min.date <> valoralto) do begin
    writeln('entro al while');//
    readln();                 //
    read(maestro_logico, regM);
    writeln('maestro obtenido: ',regM.date,' ',regM.cod);//
    readln();                                           //
    while (regM.date <> min.date) and (regM.cod <> min.cod) do begin
      read(maestro_logico, regM);
      writeln('maestro obtenido: ',regM.date,' ',regM.cod);//
      readln();                                            //
    end;
    if (regM.totEjemplares = 0) then begin
      writeln('No hay ejemplares de este semanario, no se pueden realizar ventas.');
      minimo (vec_det, min, vec_reg);
      writeln('minimo obtenido: ',min.date,' ',min.cod,' ',min.cantVentas); //
      readln();
    end                                                              //
    else begin
      while ((min.date = regM.date) and (min.cod = regM.cod)) do begin
        regM.totVendidos:= regM.totVendidos + min.cantVentas;
        writeln('regM.totVendidos actualizado: ',regM.totVendidos); //
        readln();                                                   //
        minimo (vec_det, min, vec_reg);
        writeln('minimo obtenido: ',min.date,' ',min.cod,' ',min.cantVentas); //
        readln();                                                              //
      end;
      if(regM.totVendidos > regM.totEjemplares) then
        writeln('No alcanzan los ejemplares para realizar la venta deseada. Venta cancelada.')
      else begin
        seek(maestro_logico, filepos(maestro_logico)-1);
        write(maestro_logico, regM);
        writeln('se actualizo en maestro');//
        readln();                          //
        if(regM.totVendidos>= maxVentas) then begin
          maxVentas:= regM.totVendidos;
          auxMax:= regM;
        end;
        if(regM.totVendidos<= minVentas) then begin
          minVentas:= regM.totVendidos;
          auxMin:= regM;
        end;
      end;
    end;
  end;
  close(maestro_logico);
  writeln('maestro cerrado');//
  readln();                  //
  for i:= 1 to dimF do begin
    close (vec_reg[i]);
    writeln('reg ',i,' cerrado');//
    readln();                    //
  end; //
  writeln('Ejemplar mas vendido: Emision "',auxMax.nombre,'" del dia ',auxMax.date,' con ',maxVentas,' de ventas.');
  writeln();
  writeln('Ejemplar menos vendido: Emision "',auxMin.nombre,'" del dia ',auxMin.date,' con ',minVentas,' de ventas.');
  writeln();
  writeln('Archivo creado correctamente.');
end;

procedure exportMaestro (var archivo_logico: arch_emisiones; var texto_logico: Text);
var
  e: emision;
begin
  reset(archivo_logico);
  rewrite(texto_logico);
  while (not EOF(archivo_logico)) do begin
    read (archivo_logico, e);
    writeln(texto_logico, e.nombre,'(Cod. ',e.cod,') | Precio: $',e.precio,' | Fecha de Emision: ',e.date);
    writeln(texto_logico,'Descripcion: ',e.descripcion);
    writeln(texto_logico,'Total de ejemplares: ',e.totEjemplares,' | Total vendidos: ',e.totVendidos);
    writeln(texto_logico,'---------------------------------------------------------------');
  end;
  close(archivo_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

var
  master: arch_emisiones;
  arrayReg: arch_regDet;
  arrayDet: arch_ventas;
  textoMaster: Text;
  nom, aux: String;
  i: integer;
begin
  writeln('ENTER para crear archivo maestro de emisiones.');
  readln();
  writeln('Ingrese el nombre fisico del archivo a crear.');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom;
  assign(master, nom);
  //crearArchivoMaestro(master);
  writeln();
  writeln('ENTER para generar un reporte del archivo maestro.');
  readln();
  writeln('Ingrese el nombre fisico del archivo de texto a crear');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom+'.txt';
  assign(textoMaster, nom);
  exportMaestro(master, textoMaster);
  writeln();
  for i:= 1 to dimF do begin
    writeln('ENTER para crear archivo detalle ',i);
    readln();
    str(i, aux);
    nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\VentasSemanarios'+aux;
    assign (arrayReg[i], nom);
    //crearArchivoDetalle(arrayReg[i]);
    writeln();
  end;
  writeln('ENTER para actualizar el maestro con los ', i,' detalles.');
  readln();
  merge(master, arrayReg, arrayDet);
  writeln();
  writeln('ENTER para generar un reporte del archivo maestro actualizado.');
  readln();
  writeln('Ingrese el nombre fisico del archivo de texto a crear');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom+'.txt';
  assign(textoMaster, nom);
  exportMaestro(master, textoMaster);
  writeln();
  writeln('ENTER para finalizar.');
  readln();
end.
