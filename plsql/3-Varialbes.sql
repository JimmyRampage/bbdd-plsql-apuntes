DECLARE
    v_num NUMERIC(2) := 10;
    v_cadena VARCHAR(10) := 'Jimmy';
    v_fecha DATE := SYSDATE;
BEGIN
    v_num := 15;
    DBMS_OUTPUT.PUT_LINE('El valor del numero es: ' || v_num);
    DBMS_OUTPUT.PUT_LINE('El valor de la cadena es: '|| v_cadena);
    DBMS_OUTPUT.PUT_LINE('El valor de la fecha es: '|| v_fecha);
END;
/