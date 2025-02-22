SET SERVEROUTPUT ON;

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-- VARIABLES DEL TIPO REGISTRO
-- -- pag 218 --gestiondebasesdedatos
DECLARE
    DEPARTAMENTO DEPT%ROWTYPE; -- VARIABLES TIPO REGISTRO
BEGIN
    SELECT * INTO DEPARTAMENTO FROM DEPT WHERE DEPTNO = 10;
    DBMS_OUTPUT.PUT_LINE(DEPARTAMENTO.DNAME || ' ' || DEPARTAMENTO.LOC);
END;

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-- VARIABLES DEL TIPO TABLA
-- -- Pagina 33 --PL/SQL

DECLARE
    TYPE TABLA IS TABLE OF VARCHAR2(40) INDEX BY BINARY_INTEGER;
    ALUMNOS TABLA;
    I BINARY_INTEGER;
BEGIN
    ALUMNOS(10) := 'Jesus';
    ALUMNOS(22) := 'Antonio';
    ALUMNOS(36) := 'Maria';
    ALUMNOS(455) := 'Laura';

    DBMS_OUTPUT.PUT_LINE('Los nombres de la tabla son');
    DBMS_OUTPUT.PUT_LINE('--------------------');

    I := ALUMNOS.FIRST;
    WHILE I <= ALUMNOS.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('Alumnos' || I || ALUMNOS(I));
        I:= ALUMNOS.NEXT(I);
    END LOOP;
END;

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-- RECORRER 
DECLARE
    TYPE TABLA IS TABLE OF VARCHAR2(40) INDEX BY BINARY_INTEGER;
    ALUMNOS TABLA;
    I BINARY_INTEGER;
BEGIN
    FOR I IN (SELECT * FROM DEPT) LOOP
        ALUMNOS(I.DEPTNO) := I.DENAME;
    END LOOP;

    I := ALUMNOS.FRIST;
    WHILE I <= ALUMNOS.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('Alumnos' || I || ALUMNOS(I))
        I:= ALUMNOS.NEXT(I):
    END LOOP;
END;

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-- NO FUNCIONA
DECLARE
    TYPE REG IS RECORD (
        DEPARTAMENTO DEPT.DNAME%TYPE,
        NEMPLEADOS NUMBER,
        SUMARETRIBUCIONES NUMBER
    );

    TYPE TABLA IS TABLE OF REG INDEX BY BINARY_INTEGER;
    TB TABLA;
    I BINARY_INTEGER;

BEGIN
    FOR I IN (SELECT * FROM EMP) LOOP
        IF TB.EXISTS(I.DEPTNO) THEN
            TB(I.DEPTNO).NEMPLEADOS := TB(I.DEPTNO).NEMPLEADO + 1;
            TB(I.DEPTNO).SUMARETRIBUCIONES := TB(I.DEPTNO).SUMARETRIBUCIONES + NVL(I.SAL + I.COMM, I.SAL);
        ELSE
            SELECT DNAME INTO TB(I.DEPTNO).DEPARTAMENTO FROM DEPT WHERE DEPTNO = I.DEPTNO;
            TB(I.DEPTNO).NEMPLEADOS := 1;
            TB(I.DEPTNO).SUMARETRIBUCIONES := NVL(I.SAL + I.COMM, I.SAL);
        END IF;
    END LOOP;

    I := TB.FIRST
    WHILE I <= TB.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(TB(I).DEPARTAMENTO || ' ' || TB(I).NEMPLEADO || ' ' || TB(I).SUMARETRIBUCIONES);
        I := TB.NEXT(I);
    END LOOP;
END;
/
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
DECLARE
    TYPE REG IS RECORD (
        DEPARTAMENTO DEPT.DNAME%TYPE,
        NEMPLEADOS NUMBER,
        SUMARETRIBUCIONES NUMBER
    );

    TYPE TABLA IS TABLE OF REG INDEX BY BINARY_INTEGER;
    TB TABLA;
    I BINARY_INTEGER;

BEGIN

    FOR I IN (SELECT * FROM DEPT) LOOP

        TB(I.DEPTNO).DEPARTAMENTO := I.DENAME;
        TB(I.DEPTNO).NEMPLEADOS := 0;
        TB(I.DEPTNO).SUMARETRIBUCIONES := 0;

    END LOOP;

    FOR I IN (SELECT * FROM EMP) LOOP
            TB(I.DEPTNO).NEMPLEADOS := TB(I.DEPTNO).NEMPLEADO + 1;
            TB(I.DEPTNO).SUMARETRIBUCIONES := TB(I.DEPTNO).SUMARETRIBUCIONES + NVL(I.SAL + I.COMM, I.SAL);
    END LOOP;

    I := TB.FIRST
    WHILE I <= TB.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(TB(I).DEPARTAMENTO || ' ' || TB(I).NEMPLEADO || ' ' || TB(I).SUMARETRIBUCIONES);
        I := TB.NEXT(I);
    END LOOP;
END;
/
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------