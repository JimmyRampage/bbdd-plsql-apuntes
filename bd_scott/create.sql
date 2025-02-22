
-- en oracle las bases de datos se organizan en esquemas dentro de un usuario
-- Por lo que hay que crear el usuario

CREATE USER bd_scott_jo IDENTIFIED BY SCOTT;
GRANT CONNECT, RESOURCE TO bd_scott_jo;

ALTER USER bd_scott_jo QUOTA UNLIMITED ON users;

ALTER SESSION SET CURRENT_SCHEMA = bd_scott_jo;

-- Creamos la tabla depto
CREATE TABLE dept (
    DEPTNO NUMBER(4) PRIMARY KEY,
    DNAME VARCHAR2(45 CHAR) NOT NULL,
    LOC VARCHAR2(45 CHAR)
);

-- Insercion de datos en depto
INSERT INTO dept (DEPTNO, DNAME, LOC) VALUES (10, 'VENTAS', 'MADRID');
INSERT INTO dept (DEPTNO, DNAME, LOC) VALUES (20, 'PRODUCCION', 'BARCELONA');
INSERT INTO dept (DEPTNO, DNAME, LOC) VALUES (30, 'CENTRAL', 'MADRID');
INSERT INTO dept (DEPTNO, DNAME, LOC) VALUES (40, 'RRHH', 'MADRID');
COMMIT;

----------------------------------
-- Creamos la tabla emp
CREATE TABLE emp (
    EMPNO NUMBER(4) PRIMARY KEY,
    ENAME VARCHAR2(45 CHAR),
    JOB VARCHAR2(9 CHAR),
    MGR NUMBER(4),
    SAL NUMBER(10,2),
    COMM NUMBER(10,2),
    DEPTNO NUMBER(4),
    HIREDATE DATE,
    CONSTRAINT fk_emp_dept FOREIGN KEY (DEPTNO) REFERENCES dept(DEPTNO) ON DELETE CASCADE
);

-- insercion de datos
INSERT INTO emp VALUES (7369, 'SMITH', 'CLERK', 7902, 6666, 500, 30, TO_DATE('2044-04-02', 'YYYY-MM-DD'));
INSERT INTO emp VALUES (7499, 'ALLEN', 'SALESMAN', 7698, 1760, 300, 20, TO_DATE('2044-08-10', 'YYYY-MM-DD'));
INSERT INTO emp VALUES (7521, 'WARD', 'SALESMAN', 7698, 1375, 500, 10, TO_DATE('2044-09-01', 'YYYY-MM-DD'));
-- Agrega los demás registros aquí...
COMMIT;

---------------------------------
-- Creamos la tabla salgrade
CREATE TABLE salgrade (
    NIVEL NUMBER(2),
    LOSAL NUMBER(10,2),
    HISAL NUMBER(10,2)
);

-- insercion de datos
INSERT INTO salgrade VALUES (1, 0, 1500);
INSERT INTO salgrade VALUES (2, 1501, 3000);
INSERT INTO salgrade VALUES (3, 3001, 15000);
COMMIT;

----------------------------------
-- Creacion de vistas
CREATE VIEW v01 AS
SELECT e.ENAME AS EMPLEADO, d.DNAME AS DEPARTAMENTO
FROM emp e JOIN dept d ON e.DEPTNO = d.DEPTNO;
