program ej2;
uses sysutils;
const valoralto = 9999;
type
  alumno = record
    cod: integer;
    nombre: String;
    apellido: String;
    cursadas: integer;
    finales: integer;
  end;

  detalle = record
    cod: integer;
    materia: String; // qué aprobó
    matName: String; //nombre de la materia
  end;

  archivo_alumnos = file of alumno;
  archivo_detalle = file of detalle;
  texto = Text;

procedure crearArchivoMaestro (var archivo_logico: archivo_alumnos; var texto_logico: texto);
var
  a: alumno;
  nom: String;
begin
  writeln('Ingrese el nombre fisico del archivo maestro');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom;
  assign(archivo_logico, nom);
  rewrite(archivo_logico); reset(texto_logico);
  while(not EOF(texto_logico)) do begin
    readln(texto_logico,a.cod,a.cursadas,a.nombre);
    readln(texto_logico,a.finales,a.apellido);
    a.nombre:= Trim(a.nombre); a.apellido:= Trim(a.apellido);
    write(archivo_logico, a);
  end;
  close(archivo_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure crearArchivoDetalle (var archivo_logico: archivo_detalle; var texto_logico: texto);
var
  d: detalle;
  nom: String;
begin
  writeln('Ingrese el nombre fisico del archivo detalle');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom;
  assign(archivo_logico, nom);
  rewrite(archivo_logico); reset(texto_logico);
  while(not EOF(texto_logico)) do begin
    readln(texto_logico,d.cod,d.materia);
    readln(texto_logico,d.matName);
    d.matName:= Trim(d.matName);
    d.materia:= AnsiLowerCase(Trim(d.materia)); //lo pone en lower y sin espacios
    write(archivo_logico, d);
  end;
  close(archivo_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure exportMaestro (var archivo_logico: archivo_alumnos; var texto_logico: texto);
var
  a: alumno;
begin
  reset(archivo_logico);
  rewrite(texto_logico);
  while (not EOF(archivo_logico)) do begin
    read (archivo_logico, a);
    writeln(texto_logico,'Cod: ',a.cod,' | Nombre: ',a.nombre,' | Apellido: ',a.apellido);
    writeln(texto_logico,'Cursadas sin Final: ',a.cursadas,' | Cursadas con final: ', a.finales);
    writeln(texto_logico,'---------------------------------------------------------------');
  end;
  close(archivo_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure exportDetalle (var archivo_logico: archivo_detalle; var texto_logico: texto);
var
  d: detalle;
begin
  reset(archivo_logico);
  rewrite(texto_logico);
  while (not EOF(archivo_logico)) do begin
    read (archivo_logico, d);
    writeln(texto_logico,'Cod: ',d.cod,' | Materia: ',d.matName,' | Aprobó: ',d.materia);
    writeln(texto_logico,'---------------------------------------------------------------');
  end;
  close(archivo_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

procedure leer (var archivo_logico: archivo_detalle; var reg: detalle);
begin
  if (not EOF(archivo_logico)) then
    read (archivo_logico, reg)
  else
    reg.cod:= valoralto;
end;

procedure actualizarMaestro (var maestro_logico: archivo_alumnos; var detalle_logico: archivo_detalle);
var
  regDet: detalle;
  regMae: alumno;
  aux: integer;
  totalC, totalF: integer;
begin
  reset(maestro_logico); reset(detalle_logico);
  read(maestro_logico, regMae);
  leer(detalle_logico, regDet);
  while (regDet.cod <> valoralto) do begin
    aux:= regDet.cod;
    totalC:= 0; totalF:= 0;
    while (aux = regDet.cod) do begin
      if (regDet.materia = 'cursada') then
        totalC:= totalC + 1
      else
        if (regDet.materia = 'final') then
          totalF:= totalF + 1
        else
          writeln('Hay un error en la materia "',regDet.matName,'" del alumno ',regDet.cod);
      leer(detalle_logico, regDet);
    end;
    while (regMae.cod <> aux) do
      read (maestro_logico, regMae);
    regMae.cursadas:= regMae.cursadas + totalC;
    regMae.finales:= regMae.finales + totalF;
    seek(maestro_logico, filepos(maestro_logico)-1);
    write(maestro_logico, regMae);
    if (not EOF(maestro_logico)) then
      read(maestro_logico, regMae);
  end;
  close(maestro_logico); close(detalle_logico);
  writeln('Archivo actualizado con exito.');
end;

procedure exportMasCuatro (var archivo_logico: archivo_alumnos; var texto_logico: texto);
var
  a: alumno;
  nom: String;
begin
  writeln('Ingrese el nombre fisico del archivo de texto a crear');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\'+nom+'.txt';
  assign(texto_logico, nom);
  reset(archivo_logico); rewrite(texto_logico);
  while (not EOF(archivo_logico)) do begin
    read (archivo_logico, a);
    if ((a.cursadas > 4) and (a.finales = 0)) then begin
      writeln(texto_logico,'Cod: ',a.cod,' | Nombre: ',a.nombre,' | Apellido: ',a.apellido);
      writeln(texto_logico,'Cursadas sin Final: ',a.cursadas,' | Cursadas con final: ', a.finales);
      writeln(texto_logico,'---------------------------------------------------------------');
    end;
  end;
  close(archivo_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos');
end;

var
  maestro: archivo_alumnos;
  detail: archivo_detalle;
  textoM: texto;
  textoD: texto;
  reporteM: texto;
  reporteD: texto;
  expA: texto;
  nom: String;
  cod: integer;
begin
  assign(textoM, 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\alumnos.txt');
  assign(textoD, 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\detalle.txt');
  assign(reporteM, 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\reporteAlumnos.txt');
  assign(reporteD, 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica2\Archivos\reporteDetale.txt');

  writeln('Eliga una opcion del menu');
  writeln('1: Crear un archivo maestro de alumnos a partir de "alumnos.txt".');
  writeln('2: Crear un archivo detalle de materias a partir de "detalle.txt".');
  writeln('3: Listar el contenido del archivo maestro en "reporteAlumnos.txt".');
  writeln('4: Listar el contenido del archivo detalle en "reporteDetalle.txt".');
  writeln('5: Actualizar el archivo maestro con los datos del archivo detalle.');
  writeln('6: Listar en un archivo .txt a los alumnos que tengan mas de 4 materias aprobadas pero sin haber aprobado el final.');
  writeln('0: Salir.');
  readln(cod);
  while (cod <> 0) do begin
    case cod of
      1: begin
           crearArchivoMaestro(maestro, textoM);
           writeln();
         end;
      2: begin
           crearArchivoDetalle(detail, textoD);
           writeln();
         end;
      3: begin
           exportMaestro (maestro, reporteM);
           writeln();
         end;
      4: begin
           exportDetalle(detail, reporteD);
           writeln();
         end;
      5: begin
           actualizarMaestro(maestro, detail);
           writeln();
         end;
      6: begin
           exportMasCuatro(maestro, expA);
           writeln();
         end;
    else
      writeln('No existe esa opcion. Intentalo de nuevo');
    end;
    writeln('Eliga una opcion del menu');
    writeln('1: Crear un archivo maestro de alumnos a partir de "alumnos.txt".');
    writeln('2: Crear un archivo detalle de materias a partir de "detalle.txt".');
    writeln('3: Listar el contenido del archivo maestro en "reporteAlumnos.txt".');
    writeln('4: Listar el contenido del archivo detalle en "reporteDetalle.txt".');
    writeln('5: Actualizar el archivo maestro con los datos del archivo detalle.');
    writeln('6: Listar en un archivo .txt a los alumnos que tengan mas de 4 materias aprobadas pero sin haber aprobado el final.');
    writeln('0: Salir.');
    readln(cod);
  end;
end.


