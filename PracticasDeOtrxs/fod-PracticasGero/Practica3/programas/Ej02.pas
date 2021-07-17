program ej3;
type
  empleado = record
    cod: integer;
    apellido: String;
    nombre: String;
    direccion: String;
    telefono: integer;
    dni: integer;
    fecha: integer;
  end;

  arch_empleados = file of empleado;

procedure crearArchivo(var archivo_logico: arch_empleados);
var
  e: empleado;
begin
  rewrite(archivo_logico);
  writeln('Ingrese el codigo de empleado (-1 para finalizar).');
  readln(e.cod);
  while (e.cod <> -1) do begin
    writeln('Ingrese el apellido del empleado.');
    readln(e.apellido);
    writeln('Ingrese el nombre del empleado.');
    readln(e.nombre);
    writeln('Ingrese la direccion del empleado.');
    readln(e.direccion);
    writeln('Ingrese el telefono del empleado.');
    readln(e.telefono);
    writeln('Ingrese el dni del empleado.');
    readln(e.dni);
    writeln('Ingrese la fecha de nacimiento del empleado.');
    readln(e.fecha);
    write(archivo_logico, e);
    writeln('Ingrese el codigo de empleado (-1 para finalizar).');
    readln(e.cod);
  end;
  close(archivo_logico);
  writeln('Archivo guardado correctamente en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica3\archivos');
end;

procedure bajaLogica (var archivo_logico: arch_empleados);
var
  e: empleado;
begin
  reset(archivo_logico);
  while (not EOF(archivo_logico)) do begin
    read(archivo_logico, e);
    if (e.dni < 5000000) then begin
      e.nombre:= '*'+e.nombre;
      seek(archivo_logico, filepos(archivo_logico)-1);
      write(archivo_logico, e);
    end;
  end;
  close(archivo_logico);
  writeln('Archivo actualizado.');
end;

procedure mostrarEmpleados (var nombre_logico: arch_empleados);
var
  e: empleado;
begin
  reset(nombre_logico);
  writeln('Empleados:');
  while (not EOF(nombre_logico))do begin
    read (nombre_logico, e);
    if (e.nombre[1] <> '*') then
      writeln(e.nombre,' ',e.apellido,' | Telefono: ',e.telefono,' | DNI: ',e.dni,' | Cod: ',e.cod);
  end;
  writeln('------------------------------------------------------------------');
  close(nombre_logico);
end;

var
  empleados: arch_empleados;
  nom: String;
begin
  writeln('Ingrese el nombre fisico del archivo de empleados.');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica3\archivos\'+nom;
  assign(empleados, nom);
  crearArchivo(empleados);
  writeln();
  mostrarEmpleados(empleados);
  writeln();
  writeln('ENTER para eliminar los empleados con dni menor a 5000000.');
  readln();
  bajaLogica(empleados);
  mostrarEmpleados(empleados);
  readln();
end.



