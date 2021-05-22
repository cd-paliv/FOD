{2. Redefinir la estructura de datos del ejercicio anterior para un árbol B+ de orden M.}

{ARBOL BALANCEADO +}
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

	nodoBMas = record
		terminal: boolean //indica si es un nodo terminal o no.
		cant_claves: integer;
		case terminal of
			true: begin //si es terminal
				claves: array [1..orden-1] of t_elemento; //clave con NRR en el archivo
				siguiente: integer; //nrr del árbol
			end;
			false: begin //si no es terminal (es interno)
				claves: array [1..orden-1] of t_clave; //copias de las claves
				hijos: array [1..orden] of integer; //nrr del árbol
			end;
	end;

	arbolBMas = file of nodoBMas;



{a. ¿Cómo accede a la información para buscar al médico con dni 37.222.111?
    Crea un árbol B+ ordenado por dni, lo busca y al encontrarlo en un nodo
    terminal lee el NRR del archivo, hace seek() de ese entero y lo encuentra}

{b. ¿Cómo accede a la información para buscar al médico García Mariano?
    Ídem anterior pero crea un árbol ordenado por nombre.}

{c. Indique cuáles son las ventajas que ofrece este tipo de árbol para el caso de la
búsqueda planteada en el inciso b.
    En los B tengo que recorrer cada página en el peor caso, en los B+ tendría que hacer un seek
	al reg 0 del árbol y recorrer secuencialmente como si fuese una lista.
	
	Accede a los datos de forma secuencial O(log n)}
