SET SERVEROUTPUT ON;

-----------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PRUEBA(N1 NUMBER, N2 NUMBER) IS

    --N1 NUMBER := 10;
    --N2 NUMBER := 15;

    FUNCTION RESTA(A NUMBER, B NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN A - B;
    END;

    FUNCTION SUMA(A NUMBER, B NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN A + B;
    END;

BEGIN
    DBMS_OUTPUT.PUT_LINE(SUMA(N1, N2));
    DBMS_OUTPUT.PUT_LINE(RESTA(N1, N2));
END;
-----------------------------------------------------------------------------------
BEGIN
    PRUEBA(10, 40);
END;
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
DROP FUNCTION MENSUALIDAD;
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE TABLA_AMORTIZACION(VCAPITAL NUMBER, VIANUAL NUMBER, VANNOS NUMBER) IS

    CVIVO NUMBER := VCAPITAL;
    IMENSUAL NUMBER := VIANUAL/1200;
    MESES NUMBER := VANNOS*12;
    MENSUA NUMBER;
    AC NUMBER;
    IC NUMBER;
    SUMAAC NUMBER := 0;
    SUMAIC NUMBER := 0;

    FUNCTION MENSUALIDAD(C NUMBER, INTERES NUMBER, NCUOTAS NUMBER) RETURN NUMBER IS

        RESULTADO NUMBER := ROUND((C*INTERES)/(1-POWER(1+INTERES, -NCUOTAS)), 2);

    BEGIN
        RETURN RESULTADO;
    END;

BEGIN

    MENSUA := MENSUALIDAD(VCAPITAL, IMENSUAL, MESES);
    DBMS_OUTPUT.ENABLE(2000000);

    FOR I IN 1..MESES LOOP
        IC := CVIVO * IMENSUAL;
        AC := MENSUA - IC;
        SUMAIC := SUMAIC + IC;
        SUMAAC := SUMAAC + AC;
        DBMS_OUTPUT.PUT(TO_CHAR('-->'));
        DBMS_OUTPUT.PUT(TO_CHAR(I, '999') || ' ');
        DBMS_OUTPUT.PUT(TO_CHAR(CVIVO, '999,999.00') || ' ');
        DBMS_OUTPUT.PUT(TO_CHAR(IC, '999,999.00') || ' ');
        DBMS_OUTPUT.PUT(TO_CHAR(AC, '999,999.00') || ' ');
        DBMS_OUTPUT.PUT(TO_CHAR(SUMAIC, '999,999.00') || ' ');
        DBMS_OUTPUT.PUT(TO_CHAR(SUMAAC, '999,999.00') || ' ');
        DBMS_OUTPUT.NEW_LINE;
        CVIVO := CVIVO - AC;
    END LOOP;

END;
-----------------------------------------------------------------------------------
BEGIN
    TABLA_AMORTIZACION(150000, 3, 25);
END;
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

--IN OUT INOUT---------------------------------------------------------------------

--VARIABLES DE OUT-----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PRUEBA_OUT(N1 NUMBER, N2 NUMBER, SALIDA OUT NUMBER) IS
BEGIN
    SALIDA:= N1 + N2;
END;
-----------------------------------------------------------------------------------
DECLARE
    VSALIDA NUMBER;
BEGIN
    PRUEBA_OUT(10, 20, VSALIDA);
    DBMS_OUTPUT.PUT_LINE(VSALIDA);
END;
-----------------------------------------------------------------------------------
--VARIABLES IN OUT-----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PRUEBA_OUT(N1 NUMBER, N2 NUMBER, SALIDA IN OUT NUMBER) IS
BEGIN
    SALIDA:= SALIDA + N1 + N2;
END;
-----------------------------------------------------------------------------------
DECLARE
    VSALIDA NUMBER := 300;
BEGIN
    PRUEBA_OUT(10, 20, VSALIDA);
    DBMS_OUTPUT.PUT_LINE(VSALIDA);
END;
-----------------------------------------------------------------------------------

--RELLENANDO UNA TABLA CON PL/SQL--------------------------------------------------
CREATE TABLE FECHAS(FECHA DATE, MES VARCHAR2(40));

DECLARE

    F DATE;
    ANNO NUMBER := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'));

BEGIN

    DELETE FROM FECHAS;

    FOR I IN 1..12 LOOP
        F := TO_DATE('1-' || I || '-' || ANNO, 'DD-MM-YYYY');
        F := NEXT_DAY(LAST_DAY(F) - 7, 'FRIDAY');
        INSERT INTO FECHAS VALUES(F, TO_CHAR(F, 'MONTH'));
    END LOOP;

END;

SELECT * FROM FECHAS;
-----------------------------------------------------------------------------------
--VARIABLES DEL TIPO REGISTROS / PAGINA 218----------------------------------------

SELECT ENAME, NVL(SAL + COMM, SAL) RETRI, DNAME FROM EMP A NATURAL JOIN DEPT B;

DECLARE

    TYPE EMPLEADO IS RECORD
    (
        NOMBRE EMP.ENAME%TYPE,
        RETRIBUCION NUMBER,
        DEPARTAMENTO DEPT.DNAME%TYPE
    );

    V EMPLEADO;

BEGIN
    FOR I IN (SELECT ENAME, NVL(SAL + COMM, SAL) RETRI, DNAME FROM EMP A NATURAL JOIN DEPT B) LOOP

        V.NOMBRE := I.ENAME;
        V.RETRIBUCION := I.RETRI;
        V.DEPARTAMENTO := I.DNAME;

        DBMS_OUTPUT.PUT_LINE(V.NOMBRE || ' ' || V.RETRIBUCION || ' ' || V.DEPARTAMENTO);
    END LOOP;
END;

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
