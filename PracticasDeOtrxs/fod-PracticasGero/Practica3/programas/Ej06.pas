program ej6;
type
  prenda = record
    cod: integer;
    desc: String;
    colores: String;
    tipo: String;
    stock: integer;
    precio: integer;
  end;

  arch_prendas = file of prenda;
  arch_obsoletas = file of integer;

procedure crearArchivoPrendas (var archivo_logico: arch_prendas);
var
  p: prenda;
begin
  rewrite(archivo_logico);
  writeln('Ingrese el codigo de la prenda (-1 para finalizar).');
  readln(p.cod);
  while (p.cod <> -1) do begin
    writeln('Ingrese la descripcion de la prenda.');
    readln(p.desc);
    writeln('Ingrese los colores de la prenda.');
    readln(p.colores);
    writeln('Ingrese el tipo de prenda.');
    readln(p.tipo);
    writeln('Ingrese la cantidad de unidades en stock.');
    readln(p.stock);
    writeln('Ingrese el precio por unidad.');
    readln(p.precio);
    write(archivo_logico, p);
    writeln('Ingrese el codigo de la prenda (-1 para finalizar).');
    readln(p.cod);
  end;
  close(archivo_logico);
  writeln('Archivo guardado con exito en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica3\archivos');
end;

procedure crearArchivoObsoletas (var archivo_logico: arch_obsoletas);
var
  aux: integer;
begin
  rewrite(archivo_logico);
  writeln('Ingrese el codigo de la prenda a descartar (-1 para finalizar).');
  readln(aux);
  while (aux <> -1) do begin
    write(archivo_logico, aux);
    writeln('Ingrese el codigo de la prenda a descartar (-1 para finalizar).');
    readln(aux);
  end;
  close(archivo_logico);
  writeln('Archivo guardado con exito en C:\Users\USUARIO\Desktop\FOD\Practicas\Practica3\archivos');
end;

procedure bajaLogica (var prendas: arch_prendas; var obsoletas: arch_obsoletas);
var
  auxP: prenda;
  auxO: integer;
begin
  reset(prendas); reset(obsoletas);
  while (not EOF(obsoletas)) do begin
    read(obsoletas, auxO);
    seek(prendas, 0);
    while (not EOF(prendas)) do begin
      read(prendas, auxP);
      if (auxP.cod = auxO) then begin
        auxP.stock:= auxP.stock * -1;
        seek(prendas, filepos(prendas)-1);
        write(prendas, auxP);
      end;
    end;
  end;
  close(prendas); close(obsoletas);
  writeln('Prendas descartadas.');
end;

procedure compactar (var viejo: arch_prendas; var nuevo: arch_prendas);
var
  p: prenda;
begin
  reset(viejo); rewrite(nuevo);
  while(not EOF(viejo)) do begin
    read(viejo, p);
    if (p.stock >= 0) then
      write(nuevo, p);
  end;
  close(viejo); close(nuevo);
  writeln('Archivo actualizado.');
end;

procedure mostrar (var archivo_logico: arch_prendas);
var
  p: prenda;
begin
  reset(archivo_logico);
  while(not EOF(archivo_logico)) do begin
    read(archivo_logico, p);
    writeln(p.tipo,' cod. ',p.cod,': ',p.desc,'(Colores: ',p.colores,') | Precio: $',p.precio,' | Stock: ',p.stock);
    writeln('------------------------------------------------------------------');
  end;
  close(archivo_logico);
end;

var
  prendas1,prendas2: arch_prendas;
  obsoletas: arch_obsoletas;
  nom, auxNom: String;
begin
  writeln('ENTER para crear el archivo de prendas.');
  readln();
  writeln('Ingrese el nombre fisico que tendrá el archivo.');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica3\archivos\'+nom;
  auxNom:= nom;
  assign(prendas1, nom);
  crearArchivoPrendas(prendas1);
  writeln();
  mostrar(prendas1);
  writeln;
  writeln('ENTER para crear el archivo de prendas obsoletas.');
  readln();
  writeln('Ingrese el nombre fisico que tendrá el archivo.');
  readln(nom);
  nom:= 'C:\Users\USUARIO\Desktop\FOD\Practicas\Practica3\archivos\'+nom;
  assign(obsoletas, nom);
  crearArchivoObsoletas(obsoletas);
  writeln();
  writeln('ENTER para actualizar el archivo de prendas.');
  readln();
  assign(prendas2, 'archivoNuevo');
  bajaLogica(prendas1, obsoletas); //hago las bajas logicas en el viejo
  compactar(prendas1, prendas2); //compacto con el nuevo
  writeln();
  erase(prendas1); //elimino el archivo viejo
  rename(prendas2, auxNom); //renombro el archivo nuevo
  writeln();

  //nom:= auxNom +'OLD';
  //rename(prendas1, nom); //le cambio el nombre al archivo viejo
  //assign(prendas2, auxNom); //al nuevo le asigno el nombre del viejo
  //bajaLogica(prendas1, obsoletas); //hago las bajas logicas en el viejo
  //compactar(prendas1, prendas2); //compacto con el nuevo
  //writeln();

  mostrar(prendas2);
  writeln;
  readln();
end.





