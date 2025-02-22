-- SCOTT --
SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION TRIMESTRE(FECHA DATE) RETURN NUMBER IS
N NUMBER := TRUNC((TO_NUMBER(TO_CHAR(FECHA, 'MM')) -1) / 3 ) + 1;

BEGIN
    RETURN N;
END;
/
-----------------------------------------------------------------------------------
SELECT TRIMESTRE(SYSDATE) FROM DUAL;
-----------------------------------------------------------------------------------

SELECT ENAME, HIREDATE, TRIMESTRE(HIREDATE) TRIMESTRE FROM EMP;

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION NOTA_VALORACION(NOTA NUMBER) RETURN VARCHAR2 IS
    TEXTO VARCHAR2(20);
BEGIN
    IF NOTA >= 0 AND NOTA < 5 THEN
        TEXTO := 'SUSPENSO';
    ELSIF NOTA < 7 THEN
        TEXTO := 'APROBADO';
    ELSIF NOTA < 9 THEN
        TEXTO := 'NOTABLE';
    ELSIF NOTA <= 10 THEN
        TEXTO := 'SOBRESALIENTE';
    ELSE
        TEXTO := 'FUERA DE RANGO';
    END IF;

    RETURN TEXTO;
END;
/
-----------------------------------------------------------------------------------
SELECT NOTA_VALORACION(9) FROM DUAL;
-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION NOTA_PROFE(N NUMBER) RETURN VARCHAR2 IS
    RESPUESTA VARCHAR(20) := 'FUERA RANGO';
BEGIN
    SELECT CASE
        WHEN N >= 0 AND N < 5 THEN 'SUSPENSO'
        WHEN N >= 5 AND N < 6 THEN 'APROBADO'
        WHEN N >= 6 AND N < 7 THEN 'BIEN'
        WHEN N >= 7 AND N < 9 THEN 'NOTABLE'
        WHEN N >= 9 AND N <= 10 THEN 'SOBRESALIENTE'
    END CASE
        INTO RESPUESTA FROM DUAL;
    RETURN RESPUESTA;
END NOTA_PROFE;
/
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION MENSUALIDAD(CAPITAL NUMBER,IANUAL NUMBER, ANNOS NUMBER) RETURN NUMBER IS
IMENSUAL NUMBER:= IANUAL/1200;
MESES NUMBER:= ANNOS*12;
RESULTADO NUMBER;

BEGIN
    RESULTADO:= ROUND((CAPITAL*IMENSUAL)/(1-POWER(1+IMENSUAL,-MESES)),2);
    RETURN RESULTADO;
END;
-----------------------------------------------------------------------------------
-- CREACION DE TABLA NOTA CON INSERCION DE VALORES
-----------------------------------------------------------------------------------
CREATE TABLE NOTAS(NOTA NUMBER, NOTA_LETRA VARCHAR2(40));
INSERT INTO NOTAS(NOTA) VALUES(7.5);
INSERT INTO NOTAS(NOTA) VALUES(5.9);
INSERT INTO NOTAS(NOTA) VALUES(3.2);
INSERT INTO NOTAS(NOTA) VALUES(9.4);
INSERT INTO NOTAS(NOTA) VALUES(10);
INSERT INTO NOTAS(NOTA) VALUES(1.4);
INSERT INTO NOTAS(NOTA) VALUES(2.8);
INSERT INTO NOTAS(NOTA) VALUES(8.3);
-----------------------------------------------------------------------------------
-- ACTUALIZAR NOTA_LETRAS CON LA FUNCION


-----------------------------------------------------------------------------------
DROP TABLE NOTAS;
-----------------------------------------------------------------------------------
SELECT NOTAS, (NOTA_VALORACION(NOTAS)) FROM NOTAS;
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION MENSUALIDAD(CAPITAL NUMBER,IANUAL NUMBER, ANNOS NUMBER) RETURN NUMBER IS
IMENSUAL NUMBER:= IANUAL/1200;
MESES NUMBER:= ANNOS*12;
RESULTADO NUMBER;

BEGIN
    RESULTADO:= ROUND((CAPITAL*IMENSUAL)/(1-POWER(1+IMENSUAL,-MESES)),2);
    RETURN RESULTADO;
END;

-----------------------------------------------------------------------------------
-- TABLA DE AMORTIZACION
-- C, I, T -> M
-- M = IC + AC
-- Cvivo * IM
-- capital = 150.000
-- Ianual = 3%
-- años = 25
-- MENSUALIDAD 711.32
-- mes | interes | AmortizacionCapital
-- 100% | 5000 |
-----------------------------------------------------------------------------------
DECLARE
    CAPITAL NUMBER := 150000;
    INTERES_ANUAL NUMBER := 3;
    ANNOS NUMBER := 25;
    --
    INTERES_MENSUAL NUMBER := INTERES_ANUAL / 1200;
    MESES NUMBER := ANNOS * 12;
    CAPITAL_VIVO NUMBER := CAPITAL;

    INTERES_CAPITAL NUMBER;
    AMORTIZACION_CAPITAL NUMBER;
    SUMAIC NUMBER := 0;
    SUMAAC NUMBER := 0;

    PAGO NUMBER := MENSUALIDAD(CAPITAL, INTERES_ANUAL, ANNOS);
BEGIN
    DBMS_OUTPUT.ENABLE(2000000);
    FOR I IN 1..MESES LOOP
        INTERES_CAPITAL := CAPITAL_VIVO * INTERES_MENSUAL;
        AMORTIZACION_CAPITAL := PAGO - INTERES_CAPITAL;
        SUMAIC := SUMAIC + INTERES_CAPITAL;
        SUMAAC := SUMAAC + AMORTIZACION_CAPITAL;

        DBMS_OUTPUT.PUT('-->');
        DBMS_OUTPUT.PUT(TO_CHAR(I, '999'));
        DBMS_OUTPUT.PUT(TO_CHAR(CAPITAL_VIVO, '999,999.00'));
        DBMS_OUTPUT.PUT(TO_CHAR(INTERES_CAPITAL, '999,999.00'));
        DBMS_OUTPUT.PUT(TO_CHAR(AMORTIZACION_CAPITAL, '999,999.00'));
        DBMS_OUTPUT.PUT(TO_CHAR(SUMAIC, '999,999.00'));
        DBMS_OUTPUT.PUT(TO_CHAR(SUMAAC, '999,999.00'));
        DBMS_OUTPUT.NEW_LINE;
        CAPITAL_VIVO := CAPITAL_VIVO - AMORTIZACION_CAPITAL;
    END LOOP;
END;
/

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-- FUNCION DECIMAL A BINARIO
CREATE OR REPLACE FUNCTION DEC_TO_BIN(NUMERO NUMBER) RETURN VARCHAR2 IS
    BINARIO VARCHAR2(200):= '';
    RESTO NUMBER;
    NUMERO_COPY NUMBER := NUMERO;

BEGIN
    WHILE NUMERO_COPY != 0 LOOP
        RESTO := MOD(NUMERO_COPY, 2); -- ALTERNATIVA -> SELECT MOD(NUMERO_COPY, 2) INTO RESTO FROM DUAL
        BINARIO := TO_CHAR(RESTO) || BINARIO;
        NUMERO_COPY := FLOOR(NUMERO_COPY / 2);
    END LOOP;

    RETURN LPAD(BINARIO, 8, '0');
END;
/
-----------------------------------------------------------------------------------
SELECT DEC_TO_BIN(10) FROM DUAL;
-----------------------------------------------------------------------------------
BEGIN
    FOR I IN 0..255 LOOP
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(I, '999') || ' ' ||DEC_TO_BIN(I));
    END LOOP;
END;
/
-----------------------------------------------------------------------------------
-- FUNCION BINARIO A DECIMAL
-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION BIN_TO_DEC(BINARIO VARCHAR2) RETURN NUMBER IS
    BINARIO_NUMBER NUMBER := TO_NUMBER(BINARIO);
    DIGITO_BIN VARCHAR2(2);
    SUMA NUMBER := 0;
    CONTADOR NUMBER := 0;
BEGIN
    FOR I IN REVERSE 1..LENGTH(BINARIO) LOOP
        DIGITO_BIN := SUBSTR(BINARIO, I, 1);
        SUMA := SUMA + (2**(CONTADOR))*TO_NUMBER(DIGITO_BIN);
        CONTADOR := CONTADOR +1;
    END LOOP;
    RETURN SUMA;
END;
/
-----------------------------------------------------------------------------------
SELECT BIN_TO_DEC('11111111') FROM DUAL;
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
SELECT TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS') FROM DUAL; -- MUESTA DÍA. MES, AÑO, HORA, MINUTO, SEGUNDO ACTUAL
SELECT TO_CHAR(ROUND(SYSDATE), 'DD-MM-YYYY HH24:MI:SS') FROM DUAL; -- SI HORA ES MAYOR A 12:00 ENTONCES TOMA EL DÍA SIGUIENTE
SELECT TO_CHAR(TRUNC(SYSDATE), 'DD-MM-YYYY HH24:MI:SS') FROM DUAL; -- QUITA LAS HORAS Y DEJA EN 00:00
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
