DECLARE
    v_dia NUMBER(1) := &dia;
BEGIN
    CASE v_dia
        WHEN 1 THEN DBMS_OUTPUT.PUT_LINE('Lunes');
        WHEN 2 THEN DBMS_OUTPUT.PUT_LINE('Martes');
        WHEN 3 THEN DBMS_OUTPUT.PUT_LINE('Miercoles');
        WHEN 4 THEN DBMS_OUTPUT.PUT_LINE('Jueves');
        WHEN 5 THEN DBMS_OUTPUT.PUT_LINE('Viernes');
        WHEN 6 THEN DBMS_OUTPUT.PUT_LINE('Sabado');
        WHEN 7 THEN DBMS_OUTPUT.PUT_LINE('Domingo');
        ELSE DBMS_OUTPUT.PUT_LINE('Debes introducir un valor entre 1 y 7');
    END CASE;
END;