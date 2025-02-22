DECLARE
    v_n1 NUMBER(2) := 1;
    v_n2 NUMBER(2) := 2;
    v_n3 NUMBER(2) := 3;
BEGIN
    IF v_n1 >= v_n2 and v_n1 >= v_n3 THEN
        DBMS_OUTPUT.PUT_LINE(v_n1 || ' es el mayor');
    ELSIF v_n2 >= v_n3 THEN
        DBMS_OUTPUT.PUT_LINE(v_n2 || ' es el mayor');
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_n3 || ' es el mayor');
    END IF;
END;