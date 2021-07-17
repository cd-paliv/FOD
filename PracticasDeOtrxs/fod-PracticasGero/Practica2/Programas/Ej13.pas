program ej13;
const
  valoralto = 9999;
  dimF = 3;
type
  alumno = record
    dni: integer;
    codC: integer;
    totPagado: integer;
  end;

  pago = record
    dni: integer;
    codC: integer;
    monto: integer;
  end;

  arch_alumnos = file of alumno;
  arch_regDet = array [1..dimF] of file of pago;
  arch_pagos = array [1..dimF] of pago;

procedure crearArchivoMaestro (var archivo_logico: arch_alumnos);
var
  a: alumno;
begin
  rewrite(archivo_logico);
  writeln('Ingrese el dni del alumno (-1 para finalizar).');
  readln(a.dni);
  while(a.dni <> -1) do begin
    writeln('Ingrese el codigo de la carrera a la que se inscribio el alumno.');
    readln(a.codC);
    writeln('Ingrese el monto total de la carrera pagado por el alumno.');
    readln(a.totPagado);
    write(archivo_logico, a);
    writeln('Ingrese el dni del alumno (-1 para finalizar).');
    readln(a.dni);
  end;
  close(archivo_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure crearArchivoDetalle (var archivo_logico: file of pago);
var
  p: pago;
begin
  rewrite(archivo_logico);
  writeln('Ingrese el dni del alumno (-1 para finalizar).');
  readln(p.dni);
  while(p.dni <> -1) do begin
    writeln('Ingrese el codigo de la carrera a pagar.');
    readln(p.codC);
    writeln('Ingrese el monto a pagar.');
    readln(p.monto);
    write(archivo_logico, p);
    writeln('Ingrese el dni del alumno (-1 para finalizar).');
    readln(p.dni);
  end;
  close(archivo_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure leer (var archivo_logico: file of pago; var reg: pago);
begin
  if (not EOF(archivo_logico)) then
    read (archivo_logico, reg)
  else begin
    reg.dni:= valoralto; reg.codC:= valoralto;
  end;
end;

procedure minimo (var vec_det: arch_pagos; var min: pago; var vec_reg: arch_regDet);
var
  i, posMin, dniminimo, codCminimo: integer;
begin
  posMin:= 0;
  dniminimo:= 999; codCminimo:= 999;
  for i:= 1 to dimF do begin
    if (vec_det[i].dni < dniminimo) then begin
      dniminimo:= vec_det[i].dni;
      codCminimo:= vec_det[i].codC;
      posMin:= i;
    end
    else if (vec_det[i].dni = dniminimo) then
      if (vec_det[i].codC <= codCminimo) then begin
        dniminimo:= vec_det[i].dni;
        codCminimo:= vec_det[i].codC;
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
    min.dni:= valoralto;
    min.codC:= valoralto;
    min.monto:= 0;
  end;
end;

procedure merge (var maestro_logico: arch_alumnos; var vec_reg: arch_regDet; var vec_det: arch_pagos);
var
  regM: alumno;
  i: integer;
  min: pago;
begin
  for i:= 1 to dimF do begin
    reset (vec_reg[i]);
    writeln('se hizo reset del reg ',i); //
    readln();                            //
    leer (vec_reg[i], vec_det[i]);
    //guardo el primer detalle de cada registro en su pos correspondiente el vector de detalles
    writeln('primer detalle del reg ',i,' guardado');  //
    writeln('vec_det[',i,'].dni: ',vec_det[i].dni);    //
    writeln('vec_det[',i,'].codC: ',vec_det[i].codC);//
    readln();                                          //
  end;
  writeln('enter para hacer reset a maestro');//
  readln();                                     //
  reset(maestro_logico);
  writeln('se hizo reset del maestro'); //
  readln();                               //
  minimo (vec_det, min, vec_reg);
  writeln('minimo obtenido: ',min.dni,' ',min.codC,' ',min.monto); //
  readln();                                                            //
  while (min.dni <> valoralto) do begin
    writeln('entro al while');//
    readln();                 //
    read(maestro_logico, regM);
    writeln('maestro obtenido: ',regM.dni,' ',regM.codC);//
    readln();                                           //
    while (regM.dni <> min.dni) and (regM.codC <> min.codC) do begin
      read(maestro_logico, regM);
      writeln('maestro obtenido: ',regM.dni,' ',regM.codC);//
      readln();                                            //
    end;
    while ((min.dni = regM.dni) and (min.codC = regM.codC)) do begin
      regM.totPagado:= regM.totPagado + min.monto;
      writeln('regM.totPagado actualizado: ',regM.totPagado); //
      readln();                                               //
      minimo (vec_det, min, vec_reg);
      writeln('minimo obtenido: ',min.dni,' ',min.codC,' ',min.monto); //
      readln();                                                        //
    end;
    seek(maestro_logico, filepos(maestro_logico)-1);
    write(maestro_logico, regM);
    writeln('se actualizo en maestro');//
    readln();                          //
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

procedure exportMaestro (var archivo_logico: arch_alumnos; var texto_logico: Text);
var
  a: alumno;
begin
  reset(archivo_logico);
  rewrite(texto_logico);
  while (not EOF(archivo_logico)) do begin
    read (archivo_logico, a);
    writeln(texto_logico,'DNI Alumno: ',a.dni,' | Carrera: ',a.codC,' | Total Pagado: ',a.totPagado);
    writeln(texto_logico,'---------------------------------------------------------------');
  end;
  close(archivo_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure exportMorosos (var archivo_logico: arch_alumnos; var texto_logico: Text);
var
  a: alumno;
begin
  reset(archivo_logico);
  rewrite(texto_logico);
  while (not EOF(archivo_logico)) do begin
    read (archivo_logico, a);
    if (a.totPagado = 0) then
      writeln(texto_logico,a.dni,' ',a.codC,' Alumno Moroso');
  end;
  close(archivo_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

var
  master: arch_alumnos;
  arrayReg: arch_regDet;
  arrayDet: arch_pagos;
  textoMaster, textoMorosos: Text;
  nom, aux: String;
  i: integer;
begin
  writeln('ENTER para crear archivo maestro de alumnos.');
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
    nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\Rapipago'+aux;
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
  writeln('ENTER para generar un reporte de los alumnos que tienen materias sin pagar.');
  readln();
  writeln('Ingrese el nombre fisico del archivo de texto a crear');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom+'.txt';
  assign(textoMorosos, nom);
  exportMorosos(master, textoMorosos);
  writeln();
  writeln('ENTER para finalizar.');
  readln();
end.
