DECLARE
    v_n1 NUMBER := 1;
    v_n2 NUMBER := 1;
    v_n3 NUMBER := 3;
BEGIN
    IF v_n1 > v_n2 THEN
        DBMS_OUTPUT.PUT_LINE(v_n1 || ' es mayor que ' || v_n2);
    ELSIF v_n1 < v_n2 THEN
        DBMS_OUTPUT.PUT_LINE(v_n1 || ' es menor que ' || v_n2);
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_n1 || ' es igual que ' || v_n2);
    END IF;

END;

DECLARE
    v_n1 NUMBER := 1;
    v_n2 NUMBER := 2;
    v_n3 NUMBER := 3;
BEGIN
    -- <> / != : Corresponde a distinto
    IF v_n1 <> v_n2 THEN
        DBMS_OUTPUT.PUT_LINE(v_n1 || ' es distinto que ' || v_n2);
    END IF;

END;

DECLARE
    v_n1 NUMBER := 5;
    v_n2 NUMBER := 2;
    v_n3 NUMBER := 3;
BEGIN
    IF v_n1 > v_n2  and v_n1 > v_n3 THEN
        DBMS_OUTPUT.PUT_LINE(v_n1 || ' es mayor que ' || v_n2 || ' y ' || v_n3);
    END IF;

END;