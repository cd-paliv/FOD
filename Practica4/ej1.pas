{1. Definir la estructura de datos correspondiente a un árbol B de orden M, que
almacenará información correspondiente a los médicos de un centro privado. De los
mismos deberá guardarse nombre y apellido, dni, matrícula y año de ingreso. ¿Cuál de
estos datos debería seleccionarse como clave de identificación para organizar los
elementos en el árbol? ¿Hay más de una opción? Justifique su elección.}

{ARBOL BALANCEADO}
program pr4;
const
	orden = M;
type
	t_clave = integer; //eligiría dni como clave de identificación xq es único y jamás se repitiría
	medico = record
		nomyape: String;
		dni: t_clave;
		matr: integer;
		anioIng: integer;
	end;

	t_elemento = record //registro que relaciona la clave elegida con el NRR en el archivo
		clave: t_clave;
		NRR: integer;
	end;

	nodo = record
		hijos: array[1..orden] of integer; //dirección de los nodos que son descendientes directos - funcionan como punteros (guardan los NRR)
		claves: array[1..orden-1] of t_elemento; //claves que forman el índice del árbol (los nodos terminales tienen como máximo M-1 elementos)
		nro_registros: integer; //cantidad de elementos del nodo
	end;

	arbolB = file of nodo;