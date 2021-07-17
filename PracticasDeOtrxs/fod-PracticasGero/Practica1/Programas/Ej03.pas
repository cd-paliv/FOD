program ej3;
type
    empleado = record
      numE: integer;
      apellido: string;
      nombre: string;
      edad: integer;
      dni: string;
    end;

    archivo_empleados = file of empleado;
    archivo_texto = Text;

procedure cargarArchivo (var nombre_logico: archivo_empleados);
var
   e: empleado;
begin
  rewrite(nombre_logico);
  writeln('Ingrese el apellido del empleado');
  readln(e.apellido);
  while (e.apellido <> '') do begin
    writeln('Ingrese el nombre del empleado');
    readln(e.nombre);
    writeln('Ingrese la edad del empleado');
    readln(e.edad);
    writeln('Ingrese el dni del empleado');
    readln(e.dni);
    writeln('Ingrese el numero del empleado');
    readln(e.numE);
    write(nombre_logico, e);
    writeln('Ingrese el apellido del empleado');
    readln(e.apellido);
  end;
  close(nombre_logico);
end;

procedure buscarNoA (var nombre_logico: archivo_empleados);
var
   e: empleado; busqueda: string;
begin
  reset(nombre_logico);
  writeln('Ingrese el nombre o apellido del empleado del cual desea saber los datos');
  readln(busqueda);
  while (not EOF(nombre_logico))do begin
    read (nombre_logico, e);
    if ((e.apellido = busqueda) OR (e.nombre = busqueda)) then
       writeln(e.nombre,' ',e.apellido,' | Edad: ',e.edad,' | DNI: ',e.dni,' | Num: ',e.numE);
  end;
  writeln('------------------------------------------------------------------');
  close(nombre_logico);
end;

procedure mostrarEmpleados (var nombre_logico: archivo_empleados);
var
  e: empleado;
begin
  reset(nombre_logico);
  writeln('Empleados:');
  while (not EOF(nombre_logico))do begin
    read (nombre_logico, e);
    writeln(e.nombre,' ',e.apellido,' | Edad: ',e.edad,' | DNI: ',e.dni,' | Num: ',e.numE);
  end;
  writeln('------------------------------------------------------------------');
  close(nombre_logico);
end;

procedure buscarMayores (var nombre_logico: archivo_empleados);
var
   e: empleado;
begin
  reset(nombre_logico);
  writeln('Empleados proximos a jubilarse (mayores de 60 años):');
  while (not EOF(nombre_logico))do begin
    read (nombre_logico, e);
    if (e.edad>60) then
       writeln(e.nombre,' ',e.apellido,' | Edad: ',e.edad,' | DNI: ',e.dni,' | Num: ',e.numE);
  end;
  writeln('------------------------------------------------------------------');
  close(nombre_logico);
end;

//ej 04
procedure aniadirEmpleados (var nombre_logico: archivo_empleados);
var
   e: empleado;
begin
  reset(nombre_logico);
  seek(nombre_logico, filesize(nombre_logico));
  writeln('Ingrese el apellido del empleado');
  readln(e.apellido);
  while (e.apellido <> '') do begin
    writeln('Ingrese el nombre del empleado');
    readln(e.nombre);
    writeln('Ingrese la edad del empleado');
    readln(e.edad);
    writeln('Ingrese el dni del empleado');
    readln(e.dni);
    writeln('Ingrese el numero del empleado');
    readln(e.numE);
    write(nombre_logico, e);
    writeln('Ingrese el apellido del empleado');
    readln(e.apellido);
  end;
  close(nombre_logico);
end;

procedure modificarEdades (var nombre_logico: archivo_empleados);
var
   e: empleado; busqueda: integer;
begin
  reset(nombre_logico);
  writeln('Ingrese el numero del empleado del cual desea modificar la edad (-1 para finalizar)');
  readln(busqueda);
  while (busqueda <> -1) do begin
    while (not EOF(nombre_logico)) do begin
      read (nombre_logico, e);
      if (e.numE = busqueda) then begin
         writeln('Ingrese la nueva edad');
         readln(e.edad);
         seek(nombre_logico, (filePos(nombre_logico)-1));
         write(nombre_logico, e);
         writeln('Datos actualizados:');
         writeln(e.nombre,' ',e.apellido,' | Edad: ',e.edad,' | DNI: ',e.dni,' | Num: ',e.numE);
         writeln('------------------------------------------------------------------');
       end;
    end;
    seek(nombre_logico, 0);
    writeln('Ingrese el numero del empleado del cual desea modificar la edad (-1 para finalizar)');
    readln(busqueda);
  end;
  close(nombre_logico);
end;

procedure exportEmpleados (var nombre_logico: archivo_empleados; var texto_logico: archivo_texto);
var
  e: empleado;
begin
  reset(nombre_logico);
  rewrite(texto_logico);
  while (not EOF(nombre_logico)) do begin
    read (nombre_logico, e);
    writeln(texto_logico,'Empleado: ',e.nombre,' ',e.apellido,' | Edad: ',e.edad,' | DNI: ',e.dni,' | Num: ',e.numE);
  end;
  close(nombre_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop');
end;

procedure exportDNI (var nombre_logico: archivo_empleados; var texto_logico: archivo_texto);
var
  e: empleado;
begin
  reset(nombre_logico);
  rewrite(texto_logico);
  while (not EOF(nombre_logico)) do begin
    read (nombre_logico, e);
    if (e.dni = '00') then
       writeln(texto_logico,'Empleado: ',e.nombre,' ',e.apellido,' | Edad: ',e.edad,' | DNI: ',e.dni,' | Num: ',e.numE);
  end;
  close(nombre_logico); close(texto_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop');
end;

var
  empleados: archivo_empleados;
  nombre_fisico: string;
  texto1: archivo_texto;
  texto2: archivo_texto;
  cod: integer;
begin
  assign(texto1, 'C:\Users\USUARIO\Desktop\empleados.txt');
  assign(texto2, 'C:\Users\USUARIO\Desktop\faltaDNI.txt');
  writeln('Ingrese el nombre fisico del archivo');
  readln(nombre_fisico);
  nombre_fisico:= 'C:\Users\USUARIO\Desktop\' + nombre_fisico;
  assign(empleados, nombre_fisico);
  writeln('Enter para comenzar a agregar datos al archivo');
  readln();
  cargarArchivo(empleados);
  writeln('Eliga una opcion del menu');
  writeln('1: Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
  writeln('2: Listar en pantalla los empleados de a uno por linea.');
  writeln('3: Listar en pantalla empleados mayores de 60 años, proximos a jubilarse.');
  //ej 04
  writeln('4: Añadir una o mas empleados al final del archivo.');
  writeln('5: Modificar edad a una o mas empleados.');
  writeln('6: Exportar el contenido del archivo a un archivo de texto.');
  writeln('7: Exportar a un archivo de texto a los empleados que no tengan cargado el DNI (DNI en 00).');
  writeln('0: Salir.');
  readln(cod);
  while (cod <> 0) do begin
    case cod of
      1: buscarNoA(empleados);
      2: mostrarEmpleados(empleados);
      3: buscarMayores(empleados);
      4: aniadirEmpleados(empleados);
      5: modificarEdades(empleados);
      6: exportEmpleados(empleados, texto1);
      7: exportDNI(empleados, texto2);
    else
     writeln('No existe esa opcion. Intentalo de nuevo');
    end;
    writeln('Eliga una opcion del menu');
    writeln('1: Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
    writeln('2: Listar en pantalla los empleados de a uno por linea.');
    writeln('3: Listar en pantalla empleados mayores de 60 años, próximos a jubilarse.');
    writeln('4: Añadir una o mas empleados al final del archivo.');
    writeln('5: Modificar edad a una o mas empleados.');
    writeln('6: Exportar el contenido del archivo a un archivo de texto.');
    writeln('7: Exportar a un archivo de texto a los empleados que no tengan cargado el DNI (DNI en 00).');
    writeln('0: Salir.');
    readln(cod);
  end;
end.





