SET SERVEROUTPUT ON;

DECLARE
    NUMERO_DEP EMP.EMPNO%TYPE;
    NOMBRE EMP.ENAME%TYPE;
    TRABAJO EMP.JOB%TYPE;
BEGIN
    SELECT EMPNO, ENAME, JOB INTO NUMERO_DEP, NOMBRE, TRABAJO FROM EMP WHERE EMPNO = 7369; -- FUNCIONA PORQUE TRAIGO SOLO UN DATO
    DBMS_OUTPUT.PUT_LINE(NUMERO_DEP || ' ' || NOMBRE || ' ' ||TRABAJO);
END;
/

----------------------------------

DECLARE
    CURSOR C1(ID_DEPTO NUMBER) IS SELECT * FROM EMP WHERE DEPTNO = ID_DEPTO;
    CC1 C1%ROWTYPE;
BEGIN
    OPEN C1(10);

        LOOP
            FETCH C1 INTO CC1;
            EXIT WHEN C1%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(C1%ROWCOUNT);
            DBMS_OUTPUT.PUT_LINE(RPAD('*', 20, '*'));
            DBMS_OUTPUT.PUT_LINE(CC1.ENAME || CC1.JOB);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(C1%ROWCOUNT);

    CLOSE C1;

END;
/


DECLARE
    CURSOR C1 IS SELECT * FROM EMP;
    CC1 C1%ROWTYPE;
    NOMBRE_EMP EMP.ENAME%TYPE;

BEGIN
    OPEN C1;

    FETCH C1 INTO CC1;

    WHILE C1%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE(CC1.ENAME);
    END LOOP;

    CLOSE C1;
END;
/


----------------------------------------------
-- EXISTEN LOS PROCEDIMIENTOS LOCALES E INCORPORADOS
-- LOCAL -> DENTRO DE UN BLOQUE ANÓNIMO
-- INCORPORADO -> SE AGREGA AL DICCIONARIO DE DATOS

-- CREANDO UN INCORPORADO
CREATE OR REPLACE PROCEDURE OBTENER_TOTAL_SUELDOS_DE(JOB_BUSCADO VARCHAR2) IS
-- ACÁ HARIA LAS DECLARACIONES
    TOTAL NUMBER := 0;
    CURSOR C1(JOB_BUSCADO VARCHAR2) IS SELECT SAL, COMM FROM EMP WHERE JOB = JOB_BUSCADO;
    CC1 C1%ROWTYPE;

BEGIN
    OPEN C1(JOB_BUSCADO);
        LOOP
            FETCH C1 INTO CC1;
            EXIT WHEN C1%NOTFOUND;
            TOTAL := TOTAL + CC1.SAL + NVL(CC1.COMM, 0);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('TOTAL TRABAJADORES ' || C1%ROWCOUNT);
    CLOSE C1;
    DBMS_OUTPUT.PUT_LINE('MONTO TOTAL ' || TOTAL);
END;
/

EXEC OBTENER_TOTAL_SUELDOS_DE('CLERK'); -- CLERK, SALESMAN, MANAGER, PRESIDENT

BEGIN
    OBTENER_TOTAL_SUELDOS_DE('CLERK'); -- CLERK, SALESMAN, MANAGER, PRESIDENT
END;
/



DECLARE
  TYPE TABLA IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
  TB TABLA;
  I NUMBER;
BEGIN
    FOR I IN (SELECT DEPTNO,AVG(SAL) MEDIA  FROM EMP GROUP BY DEPTNO) LOOP
       TB(I.DEPTNO):=I.MEDIA;
    END LOOP;

I:=TB.FIRST;
WHILE I<=TB.LAST LOOP
DBMS_OUTPUT.PUT_LINE(I||' '|| TB(I));

I:=TB.NEXT(I);
END LOOP;

END;