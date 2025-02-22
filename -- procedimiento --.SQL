-- procedimiento, le pasamos el depto y nos tiene que mostrar por pantalla los primeros dos empleados que más ganan

CREATE OR REPLACE PROCEDURE DEPTO_MAX_SAL(N INTEGER, POSI INTEGER DEFAULT 2) IS

    CURSOR C1(ND DEPT.DEPTNO%TYPE) IS SELECT * FROM EMP WHERE DEPTNO = ND ORDER BY NVL(SAL + COMM, SAL) DESC;
    CC1 C1%ROWTYPE;

    NOMBRE VARCHAR2(40):='';
BEGIN
    DBMS_OUTPUT.ENABLE(2000000);
    SELECT DNAME INTO NOMBRE FROM DEPT WHERE DEPTNO = N;
    DBMS_OUTPUT.PUT_LINE(NOMBRE);
    DBMS_OUTPUT.PUT_LINE(RPAD('', LENGTH(NOMBRE), '*'));
    OPEN C1(N);

    LOOP
        FETCH C1 INTO CC1;
        EXIT WHEN C1%NOTFOUND OR C1%ROWCOUNT = POSI + 1;
        DBMS_OUTPUT.PUT_LINE(C1%ROWCOUNT || ' - ' || CC1.ENAME || ' ' || NVL(CC1.SAL + CC1.COMM, CC1.SAL));
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    CLOSE C1;

END;
/
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
EXECUTE DEPTO_MAX_SAL(20, 2)
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------