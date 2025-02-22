-- ENCENDER LA SALIDA
SET SERVEROUTPUT ON

-- ELIMINAR LA TABLA CAJERO SI EXISTE
DROP TABLE IF EXISTS CAJERO;

-- CREAR LA TABLA CAJERO
CREATE TABLE CAJERO(
    MONEDA FLOAT PRIMARY KEY,
    CANTIDAD INTEGER CHECK (CANTIDAD >= 0)
);

-- Esto define el tipo de la coleccion TABLA, se conoce como plsql array asosiativo (o una tabla plsql)
-- Esto almacena elementos de typo NUMBER
-- INDEX BY BINARY_INTEGER: es una indexacion como un array, pero no necesariamente secuencial
-- TB TABLA: Declaramos la variable TB de tipo TABLA. por lo que TB es un array asociativo
DECLARE
    TYPE TABLA IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    TB TABLA;
BEGIN
    --
    TB(1):=5; -- El valor en el index 1 se setea en 5
    TB(2):=2; -- Acá a el 2 en 2
    TB(3):=1; -- Acà el valor en el indice 3 es 1
    FOR I IN REVERSE -2..2 LOOP -- Va de -2 a 2 de uno en uno
        FOR J IN 1..3 LOOP
            INSERT INTO CAJERO VALUES(POWER(10, I) * TB(J), 100);
        END LOOP;
    END LOOP;
END;
/

SELECT * FROM CAJERO;

-- crear una funcion que al pasarle una moneda, vea si existe

CREATE OR REPLACE FUNCTION CHECK_COIN(MONEDA NUMBER) RETURN BOOLEAN IS

BEGIN
    SELECT COUNT(*) INTO C FROM CAJERO WHERE MONEDA = MONEDA;
    IF N = 0 THEN
        RETURN FALSE;
    END IF;
    RETURN TRUE;
END;
/
-- PROBANDO LA FUNCIÓN
DECLARE
    MONEY NUMBER := 200;
BEGIN
    IF CHECK_COIN(MONEY) THEN
        DBMS_OUTPUT.PUT_LINE('Existe');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe');
    END IF;
END;
/

-- FUNCION PARA SABER SI UN NUMERO ES NATURAL
CREATE OR REPLACE FUNCTION ISNATURAL(N NUMBER) RETURN BOOLEAN IS
BEGIN
    IF TRUNC(N) = N AND N >= 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
/

SELECT * FROM CAJERO;

/*
Que es la expresion TB(50):=1
*/

/*
 * INSTR
 * Esta funcion busca en una cadena y devuelve la posicion de la primera ocurrencia en la cadena
 */
 
/* SUBSTR
 * Recorta una cadena de la cual se extraera
*/
SELECT INSTR('1-200#1-100#1-50', '#') FROM DUAL;

SELECT SUBSTR('1-200#1-100#1-50', 7) FROM DUAL;