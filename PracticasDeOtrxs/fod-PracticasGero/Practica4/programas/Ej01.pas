program ej1;
const M = 5;
type
  medico = record
    nombre: String;
    apellido: String;
    dni: integer;
    matricula: integer;
    ano: integer;
  end;

  nodo = record
    cant_claves: integer;
    claves: array [1..M-1] of medico; //la matricula seria la clave principal
    hijos: array [1..M] of integer; //NRR de los hijos
  end;

  arbolB = file of nodo;




