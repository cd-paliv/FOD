program ej8;
const
  valoralto = 9999;
  dimF = 15;
type
  horaExtra = record
    departamento: integer;
    division: integer;
    numEmp: integer;
    cat: integer;
    cantH: integer;
  end;

  cat = record
    num: integer;
    valor: integer;
  end;

  categorias = array [1..dimF] of integer;

  arch_horas = file of horaExtra;

procedure crearArchivoMaestro (var archivo_logico: arch_horas);
var
  h: horaExtra;
begin
  rewrite(archivo_logico);
  writeln('Ingrese el departamento en el que ejerce el empleado (-1 para finalizar).');
  readln(h.departamento);
  while(h.departamento <> -1) do begin
    writeln('Ingrese la division del empleado.');
    readln(h.division);
    writeln('Ingrese el numero de empleado.');
    readln(h.numEmp);
    writeln('Ingrese la categoria del empleado.');
    readln(h.cat);
    writeln('Ingrese la cantidad de horas extras que realizo el empleado.');
    readln(h.cantH);
    write(archivo_logico, h);
    writeln('Ingrese el departamento en el que ejerce el empleado (-1 para finalizar).');
    readln(h.departamento);
  end;
  close(archivo_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure leer (var archivo_logico: arch_horas; var reg: horaExtra);
begin
  if (not EOF(archivo_logico)) then
    read (archivo_logico, reg)
  else
    reg.departamento:= valoralto;
end;

procedure corteDeControl (var archivo_logico: arch_horas; cats: categorias);
var
  reg: horaExtra;
  auxDep, auxDiv, auxEmp, auxCat, totHDep, totMDep, totHDiv, totMDiv, totHEmp, importeEmp: integer;
begin
  reset(archivo_logico);
  leer(archivo_logico, reg);
  writeln('Departamento: ',reg.departamento);
  totHDep:= 0; totMDep:= 0;
  while (reg.departamento <> valorAlto) do begin
    writeln('Division: ',reg.division);
    writeln('Numero de Empleado    Total de Hs    Importe a cobrar');
    auxDep:= reg.departamento;
    auxDiv:= reg.division;
    totHDiv:= 0; totMDiv:= 0;
    while(reg.departamento = auxDep) and (reg.division = auxDiv) do begin
      auxEmp:= reg.numEmp;
      auxCat:= reg.cat;
      totHEmp:= 0;
      while (reg.departamento = auxDep) and (reg.division = auxDiv) and (reg.numEmp = auxEmp) do begin
        totHEmp:= totHEmp + reg.cantH;
        leer(archivo_logico,reg);
      end;
      importeEmp:= totHEmp * cats[auxCat];
      totHDiv:= totHDiv + totHEmp;
      totMDiv:= totMDiv + importeEmp;
      writeln(auxemp,'                      ',totHEmp,'                      ',importeEmp);
    end;
    totHDep:= totHDep + totHDiv;
    totMDep:= totMDep + totMDiv;
    writeln();
    writeln('Total de horas division: ',totHDiv);
    writeln('Monto total por division: ',totMDiv);
    writeln();
    if (auxDep <> reg.departamento) then begin
      writeln('Total horas departamento: ',totHDep);
      writeln('Monto total departamento: ',totMDep);
      writeln('---------------------------------------------------------------');
      writeln();
      if (reg.departamento <> valoralto) then begin
        writeln('Departamento: ',reg.departamento);
        totHDep:= 0; totMDep:= 0;
      end;
    end;
  end;
  close(archivo_logico);
end;

var
  categ: categorias;
  master: arch_horas;
  nom: String;
  textCat: Text;
  aux: cat;
  i: integer;
begin
  writeln('Ingrese el nombre fisico del archivo de texto que contiene los valores de horas extra por categoria');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom+'.txt';
  assign(textCat, nom);
  writeln('se asigno el archivo de texto');//
  readln();                                //
  reset(textCat);
  for i:= 1 to dimF do begin
    writeln('enter para leer text cat, linea ',i);//
    readln();                                     //
    readln(textCat, aux.num, aux.valor);
    categ[i]:= aux.valor;
    writeln('se guardo ',categ[i],' en categ[',i,']');//
    readln();                                         //
  end;
  close(textCat);
  writeln('ENTER para crear el archivo de horas extra.');
  readln();
  writeln('Ingrese el nombre fisico del archivo a crear.');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom;
  assign(master, nom);
  //crearArchivoMaestro(master);
  writeln();
  writeln('ENTER para mostrar en pantalla el reporte de horas extra por empleado.');
  readln();
  corteDeControl(master, categ);
  readln();
end.



