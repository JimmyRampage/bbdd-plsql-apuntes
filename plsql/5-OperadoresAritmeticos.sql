DECLARE
v_op1 NUMBER(2) := 10;
v_op2 NUMBER(2) := 5;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Suma ' || (v_op1 + v_op2));
    DBMS_OUTPUT.PUT_LINE('Resta ' || (v_op1 - v_op2));
    DBMS_OUTPUT.PUT_LINE('Multiplicación ' || (v_op1 * v_op2));
    DBMS_OUTPUT.PUT_LINE('División ' || (v_op1 / v_op2));
    DBMS_OUTPUT.PUT_LINE('Potencia ' || (v_op1 ** v_op2));
END;