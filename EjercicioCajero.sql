-- ENCENDER LA SALIDA
SET SERVEROUTPUT ON
---------------------------------------------------------------------------------------------------
-- ELIMINAR LA TABLA CAJERO SI EXISTE
DROP TABLE IF EXISTS CAJERO;

-- CREAR LA TABLA CAJERO
CREATE TABLE CAJERO(
    MONEDA FLOAT PRIMARY KEY,
    CANTIDAD INTEGER CHECK (CANTIDAD >= 0)
);

---------------------------------------------------------------------------------------------------
-- TABLE -> Es como un diccionario de python
-- NUMBER -> Es el contenido (v)
-- INDEX BY -> Define la (k)
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

---------------------------------------------------------------------------------------------------
-- CREAR UN BK DE LA TABLA CAJERO
CREATE TABLE CAJERO_BK AS SELECT * FROM CAJERO;

SELECT * FROM CAJERO;
SELECT * FROM CAJERO_BK;

---------------------------------------------------------------------------------------------------
-- CHECKEAR QUE LA MONEDA EXISTA
CREATE OR REPLACE FUNCTION CHECK_COIN(P_MONEDA NUMBER) RETURN BOOLEAN IS
    N NUMBER;
BEGIN
    SELECT COUNT(*) INTO N FROM CAJERO WHERE MONEDA = P_MONEDA; -- SELECT INTO TOMA UN CONTENIDO Y LO ALMACENA EN UNA VARIABLE, ESTE CASO N
    IF N = 0 THEN
        RETURN FALSE; -- CAMBIAR A FALSE
    END IF;
    RETURN TRUE; -- CAMBIAR A TRUE
END;
/

SELECT CHECK_COIN(10) FROM DUAL; -- LAS CONSULTAS NO DEVUELVEN BOOLEANOS

-- SE PUEDE USAR EN UN BLOQUE ANÓNIMO
DECLARE
    resultado BOOLEAN;
BEGIN
    resultado := CHECK_COIN(25);
    IF resultado THEN
        DBMS_OUTPUT.PUT_LINE('Existe');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe');
    END IF;
END;
/
---------------------------------------------------------------------------------------------------
-- RECIBIR UN MONTO Y DESCOMPONERLO EN FORMATO -> cant-tipo-#cant-tipo-#
CREATE OR REPLACE FUNCTION DESCOMPONER_MONTO(MONTO2 NUMBER) RETURN VARCHAR2 IS
    CURSOR C1 IS SELECT * FROM CAJERO ORDER BY MONEDA DESC;
    v_moneda CAJERO.MONEDA%TYPE;
    v_cantidad CAJERO.CANTIDAD%TYPE;
    v_monto_descompuesto VARCHAR2(100) := '';
    v_resto NUMBER := 0;
    MONTO NUMBER := MONTO2;
BEGIN
    OPEN C1;
    LOOP
        FETCH C1 INTO v_moneda, v_cantidad;
        EXIT WHEN C1%NOTFOUND;
        IF v_moneda <= MONTO AND v_cantidad > 0 THEN
            v_resto := FLOOR(MONTO / v_moneda);
            MONTO := MONTO - (v_resto * v_moneda);
            v_monto_descompuesto := (v_monto_descompuesto || v_resto || '-' || v_moneda || '#');
        END IF;
    END LOOP;
    CLOSE C1;
    RETURN v_monto_descompuesto;
END;
/

DECLARE
    RES VARCHAR2(100);
BEGIN
    RES := DESCOMPONER_MONTO(185); -- debiera dar 1-200#1-50#
    DBMS_OUTPUT.PUT_LINE(RES);
END;
/

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- PROBANDO INSTR -> INSTR(cadena, subcadena)
DECLARE
    v_monto VARCHAR2(100) := '1-200#3-50#2-2#';
BEGIN
    DBMS_OUTPUT.PUT_LINE(INSTR(v_monto, '#')); -- Buscando la primera coinsidencia
END;
/

-- PROBANDO SUBSTR -> SUBSTR(cadena, inicio, longitud)
DECLARE
    v_monto VARCHAR2(100) := '1-200#3-50#2-2#';
BEGIN
    DBMS_OUTPUT.PUT_LINE(SUBSTR(v_monto, 1, 6 -1)); -- recortando el string
END;
/

-- USANDO AMBOS

DECLARE
    v_monto VARCHAR2(100) := '1-200#3-50#2-2#';
    v_corte NUMBER(10) := 0;
    
    -- VARIABLES MONTO TOTAL Y VUELTO
    v_monto_total_recibido NUMBER(10) := 0;
    v_vuelto NUMBER(10) := 0;

    -- VARIABLES AUXILIARES
    v_monto_aux VARCHAR2(100);
    v_cantidad_aux NUMBER(10);
    v_denominacion_aux NUMBER(10);

    -- VARIABLES PARA CONSULTA
BEGIN
    WHILE LENGTH(v_monto) > 0 LOOP
        -- SEPARAMOS cantidad-denominacion
        v_corte := INSTR(v_monto, '#');
        v_monto_aux := SUBSTR(v_monto, 1, v_corte - 1); -- recortando el string -> 1-200
        v_monto := SUBSTR(v_monto, v_corte + 1); -- se reasigna el valor nuevo al monto -> 3-50#2-2#

        -- AHORA QUITAMOS EL '-'
        v_corte := INSTR(v_monto_aux ,'-');
        v_cantidad_aux := TO_NUMBER(SUBSTR(v_monto_aux, 1, v_corte - 1));
        v_denominacion_aux := TO_NUMBER(SUBSTR(v_monto_aux, v_corte +1));


        IF CHECK_COIN(v_denominacion_aux) THEN
            DBMS_OUTPUT.PUT_LINE('Moneda existe');
            DBMS_OUTPUT.PUT_LINE(v_monto_aux);
            DBMS_OUTPUT.PUT_LINE(v_cantidad_aux);
            DBMS_OUTPUT.PUT_LINE(v_denominacion_aux);
            v_monto_total_recibido := v_monto_total_recibido + (v_cantidad_aux * v_denominacion_aux);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Moneda no existe');
        END IF;

    END LOOP;

    DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_monto_total_recibido) || '€');

END;
/
select * from CAJERO;

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

DECLARE
    TYPE TABLA_RECIBIDO IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
/

CREATE OR REPLACE PROCEDURE crear_table(p_tabla OUT TABLA_RECIBIDO, v_monto2 VARCHAR2) IS

    v_monto VARCHAR2(100) := v_monto2;
    -- VARIABLE PARA HACER LOS CORTES DEL SUBSTRING
    v_corte NUMBER(10) := 0;
    -- VARIABLES MONTO TOTAL Y VUELTO
    v_monto_total_recibido NUMBER(10) := 0;
    v_vuelto NUMBER(10) := 0;

    -- VARIABLES AUXILIARES
    v_monto_aux VARCHAR2(100);
    v_cantidad_aux NUMBER(10);
    v_denominacion_aux NUMBER(10);

BEGIN
    p_tabla.DELETE; -- PARA LIMPIAR LA TABLA
    WHILE LENGTH(v_monto) > 1 LOOP
        v_corte := INSTR(v_monto, '#');
        v_monto_aux := SUBSTR(v_monto, 1, v_corte - 1); -- recortando el string -> 1-200
        v_monto := SUBSTR(v_monto, v_corte + 1); -- se reasigna el valor nuevo al monto -> 3-50#2-2#

        v_corte := INSTR(v_monto_aux ,'-');
        v_cantidad_aux := TO_NUMBER(SUBSTR(v_monto_aux, 1, v_corte - 1));
        v_denominacion_aux := TO_NUMBER(SUBSTR(v_monto_aux, v_corte +1));

        IF CHECK_COIN(v_denominacion_aux) THEN
            p_tabla(v_denominacion_aux) := v_cantidad_aux;
            v_monto_total_recibido := v_monto_total_recibido + (v_cantidad_aux * v_denominacion_aux);

        ELSE
            EXIT; -- GENERAR UNA EXCEPCION
        END IF;

    END LOOP;
END;
/

-- probando el procedimiento
DECLARE
    TYPE TABLA_RECIBIDO IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    tb_r TABLA_RECIBIDO;

BEGIN
    crear_table(tb_r, '1-200#3-50#2-2#');

    FOR I IN tb_r.FIRST..tb_r.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(i || ' ' || tb_r(i));
    END LOOP;
END;
/
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
