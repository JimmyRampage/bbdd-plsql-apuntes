SET SERVEROUTPUT ON;

-- empno ename job mgr hiderate sal comm deptno
select * from emp;

DECLARE
    CURSOR C_EMPLEADOS IS SELECT ENAME, SAL, COMM FROM EMP;
    v_ename emp.ename%TYPE;
    v_sal emp.sal%TYPE;
    v_comm emp.comm%TYPE;
BEGIN
    OPEN C_EMPLEADOS;
    LOOP
        FETCH C_EMPLEADOS INTO v_ename, v_sal, v_comm;
        EXIT WHEN C_EMPLEADOS%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_ename || v_sal || v_comm);
    END LOOP;
    CLOSE C_EMPLEADOS;
END;
/


DECLARE
    CURSOR C1 IS SELECT * FROM EMP;
    CC1 C1%ROWTYPE;
BEGIN
    OPEN C1;
    LOOP
        FETCH C1 INTO CC1;
        EXIT WHEN C1%NOTFOUND;
        IF CC1.ENAME = 'JAMES' THEN
            DBMS_OUTPUT.PUT_LINE(CC1.ENAME || ' Like you');
        ELSE
            DBMS_OUTPUT.PUT_LINE(CC1.ENAME);
        END IF;
    END LOOP;
    CLOSE C1;
END;
/

-------------------------------------------------------
-------------------------------------------------------
-- CURSOR CON EL PROFE
-- AUMENTAR EL SUELDO UN 10% CONSIDERANDO LA MEDIA DEL DEPTO
CREATE TABLE EMP_BK AS SELECT * FROM EMP;

DECLARE
    TYPE REG IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    TB REG;
    CURSOR C1 IS SELECT * FROM EMP;
    CC1 C1%ROWTYPE;
    v_nombre EMP.ENAME%TYPE;
    NUMERO NUMBER;
BEGIN
    FOR I IN (SELECT AVG(SAL) MEDIA, DEPTNO FROM EMP GROUP BY DEPTNO) LOOP
        TB (I.DEPTNO) := I.MEDIA;
    END LOOP;
    OPEN C1;
    LOOP
        FETCH C1 INTO CC1;
        EXIT WHEN C1%NOTFOUND;
        UPDATE EMP SET SAL = SAL + (TB(CC1.DEPTNO) * 0.1) WHERE EMPNO = CC1.EMPNO;
    END LOOP;
    CLOSE C1;
END;
/
-- revovinando los cambios
UPDATE EMP A SET A.SAL =
(SELECT B.SAL FROM EMP_BK B WHERE A.EMPNO = B.EMPNO);

SELECT * FROM EMP;
-- b es respaldo
-- a es el nuevo
SELECT a.ename, a.DEPTNO, a.sal salario_nuevo, b.sal salario_antes, ROUND(a.sal - b.sal, 1) diferencia
FROM emp a, emp_bk b
WHERE a.EMPNO = b.EMPNO
ORDER BY a.DEPTNO ASC;