program ej4;
const
  valoralto = 9999;
  dimF = 5;
type
  log = record
    cod: integer;
    fecha: integer;
    t_total: integer;
  end;

  detalle = record
    cod: integer;
    fecha: integer;
    t_sesion: integer;
  end;

  arch_maestro = file of log;
  arch_detalle = array [1..dimF] of file of detalle;
  arch_regDet = array [1..dimF] of detalle; //no se asigna xq no es archivo

procedure crearArchivoDetalle (var archivo_logico: file of detalle);
var
  d: detalle;
begin
  rewrite(archivo_logico);
  writeln('Ingrese el codigo del usuario (-1 para finalizar).');
  readln(d.cod);
  while(d.cod <> -1) do begin
    writeln('Ingrese la fecha de la sesion (Dia de la semana del 1 al 7).');
    readln(d.fecha);
    writeln('Ingrese la duracion en minutos de la sesion.');
    readln(d.t_sesion);
    write(archivo_logico, d);
    writeln('Ingrese el codigo del usuario (-1 para finalizar).');
    readln(d.cod);
  end;
  close(archivo_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure leer (var archivo_logico: file of detalle; var reg: detalle);
begin
  if (not EOF(archivo_logico)) then
    read (archivo_logico, reg)
  else begin
    reg.cod:= valoralto; reg.fecha:= valoralto;
  end;
end;

procedure minimo (var vec_det: arch_regDet; var min: detalle; var vec_reg: arch_detalle);
var
  i, posMin, codminimo, fechaminima: integer;
begin
  posMin:= 0;
  codminimo:= 999; fechaminima:= 999;
  for i:= 1 to dimF do begin
    if (vec_det[i].cod < codminimo) then begin
      codminimo:= vec_det[i].cod;
      fechaminima:= vec_det[i].fecha;
      posMin:= i;
    end
    else if (vec_det[i].cod = codminimo) then
      if (vec_det[i].fecha <= fechaminima) then begin
        codminimo:= vec_det[i].cod;
        fechaminima:= vec_det[i].fecha;
        posMin:= i;
      end;
  end;
  if (posMin <> 0) then begin //si encontré min
    min:= vec_det[posMin];
    leer(vec_reg[posMin], vec_det[posMin]);
    //leo el siguiente detalle del archivo al cual correspondia el detalle "min"
    //y lo guardo en el vector de detalles ocupando la posicion que "min" acaba de liberar
  end
  else begin
    min.cod:= valoralto;
    min.fecha:= valoralto;
    min.t_sesion:= 0;
  end;
end;

procedure merge (var maestro_logico: arch_maestro; var vec_reg: arch_detalle; var vec_det: arch_regDet);
var
  regM: log;
  i: integer;
  min: detalle;
begin
  for i:= 1 to dimF do begin
    reset (vec_reg[i]);
    writeln('se hizo reset del reg ',i); //
    readln();                            //
    leer (vec_reg[i], vec_det[i]);
    //guardo el primer detalle de cada registro en su pos correspondiente del vector de detalles
    writeln('primer detalle del reg ',i,' guardado');  //
    writeln('vec_det[',i,'].cod: ',vec_det[i].cod);    //
    writeln('vec_det[',i,'].fecha: ',vec_det[i].fecha);//
    readln();                                          //
  end;
  writeln('enter para hacer rewrite a maestro');//
  readln();                                     //
  rewrite(maestro_logico);
  writeln('se hizo rewrite del maestro'); //
  readln();                               //
  minimo (vec_det, min, vec_reg);
  writeln('minimo obtenido: ',min.cod,' ',min.fecha,' ',min.t_sesion); //
  readln();                                                            //
  while (min.cod <> valoralto) do begin
    regM.cod:= min.cod;
    regM.fecha:= min.fecha;
    writeln('regM.cod actualizado: ',regM.cod); //
    readln();                                   //
    writeln('regM.fecha actualizada: ',regM.fecha); //
    readln();                                       //
    regM.t_total := 0;
    while ((min.cod = regM.cod) and (min.fecha = regM.fecha)) do begin
      regM.t_total:= regM.t_total + min.t_sesion;
      writeln('regM.t_total actualizado: ',regM.t_total); //
      readln();                                       //
      minimo (vec_det, min, vec_reg);
      writeln('minimo obtenido: ',min.cod,' ',min.fecha,' ',min.t_sesion); //
      readln();                                                            //
    end;
    write(maestro_logico, regM);
    writeln('se escribio en maestro');//
    readln();                         //
  end;
  close(maestro_logico);
  writeln('maestro cerrado');//
  readln();                  //
  for i:= 1 to dimF do begin
    close (vec_reg[i]);
    writeln('reg ',i,' cerrado');//
    readln();                    //
  end; //
  writeln('Archivo creado correctamente.');
end;

procedure exportMaestro (var archivo_logico: arch_maestro; var texto_logico: Text);
var
  m: log;
begin
  reset(archivo_logico);
  rewrite(texto_logico);
  while (not EOF(archivo_logico)) do begin
    read (archivo_logico, m);
    writeln(texto_logico,'Cod Usuario: ',m.cod,' | Fecha de Sesion: Día ',m.fecha);
    writeln(texto_logico,'Duracion total (e/ diferentes sesiones en diferentes maquinas): ',m.t_total);
    writeln(texto_logico,'---------------------------------------------------------------');
  end;
  close(archivo_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

var
  master: arch_maestro;
  arrayReg: arch_detalle;
  arrayDet: arch_regDet;
  texto: Text;
  nom, nomF, aux: String;
  i: integer;
begin
  assign(master,'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\maestro');
  //assign(master,'Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\maestro');
  for i:= 1 to dimF do begin
    writeln('ENTER para crear archivo detalle ',i);
    readln();
    str(i, aux);
    nomF:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\det'+aux;
    assign (arrayReg[i], nomF);
    crearArchivoDetalle(arrayReg[i]);
    writeln();
  end;
  writeln('ENTER para hacer un merge de detalles a archivo maestro.');
  readln();
  merge(master, arrayReg, arrayDet);
  writeln();
  writeln('ENTER para generar un reporte del archivo maestro.');
  readln();
  writeln('Ingrese el nombre fisico del archivo de texto a crear');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom+'.txt';
  assign(texto, nom);
  exportMaestro(master, texto);
  writeln();
  writeln('ENTER para finalizar.');
  readln();
end.


