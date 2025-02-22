DECLARE
v_op1 NUMBER(2) := &operando1;
v_op2 NUMBER(2) := &operando2;
v_sum NUMBER(3);

BEGIN
    v_sum := v_op1 + v_op2;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;