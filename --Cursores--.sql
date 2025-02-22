SET SERVEROUTPUT ON;

DECLARE

    CURSOR C1 IS SELECT * FROM EMP WHERE DEPTNO = 20;
    CC1 C1%ROWTYPE;

BEGIN

    OPEN C1;
    LOOP
        FETCH C1 INTO CC1;
    EXIT WHEN C1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(CC1.EMPNO || ' ' || CC1.ENAME || ' ' || CC1.JOB);
    END LOOP;
    CLOSE C1;

END;
/

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
    -- EN ESTA MODIFICACION SE LE PUEDE ENTREGAR UN PARAMETRO A C1
DECLARE

    CURSOR C1(NUMERO EMP.DEPTNO%TYPE) IS SELECT * FROM EMP WHERE DEPTNO = NUMERO;
    CC1 C1%ROWTYPE;

BEGIN

    OPEN C1(20);
    LOOP
        FETCH C1 INTO CC1;
    EXIT WHEN C1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(CC1.EMPNO || ' ' || CC1.ENAME || ' ' || CC1.JOB);
    END LOOP;
    CLOSE C1;

END;
/
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

DECLARE
    CURSOR C1(N DEPT.DEPTNO%TYPE) IS SELECT * FROM EMP WHERE DEPTNO = N ORDER BY NVL(SAL + COMM, SAL) DESC;
    CC1 C1%ROWTYPE;
BEGIN
    FOR I IN (SELECT * FROM DEPT ORDER BY DEPTNO) LOOP
        DBMS_OUTPUT.PUT_LINE(I.DNAME);
        DBMS_OUTPUT.PUT_LINE(RPAD('*', LENGTH(I.DNAME), '*'));
        OPEN C1(i.DEPTNO);
        LOOP
            FETCH C1 INTO CC1;
            EXIT WHEN C1%NOTFOUND OR C1%ROWCOUNT = 4;
            DBMS_OUTPUT.PUT_LINE(C1%ROWCOUNT || CC1.ENAME || ' ' || NVL(CC1.SAL + CC1.COMM, CC1.SAL));
        END LOOP;
        DBMS_OUTPUT.NEW_LINE;
        CLOSE C1;
    END LOOP;
END;
/
    -- rpAD -> EMPAQUETA UNA CADENA HASTA UNA LONGITUD DADA
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------