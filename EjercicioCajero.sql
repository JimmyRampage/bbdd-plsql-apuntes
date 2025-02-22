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
CREATE OR REPLACE FUNCTION CHECK_COIN(P_MONEDA NUMBER) RETURN NUMBER IS
    N NUMBER;
BEGIN
    SELECT COUNT(*) INTO N FROM CAJERO WHERE MONEDA = P_MONEDA; -- SELECT INTO TOMA UN CONTENIDO Y LO ALMACENA EN UNA VARIABLE, ESTE CASO N
    IF N = 0 THEN
        RETURN 0; -- CAMBIAR A FALSE
    END IF;
    RETURN 1; -- CAMBIAR A TRUE
END;
/

SELECT CHECK_COIN(10) FROM DUAL;
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