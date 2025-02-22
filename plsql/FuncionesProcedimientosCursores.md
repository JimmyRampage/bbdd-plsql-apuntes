# Introduccion a PL/SQL

## ¿Qué es PL/SQL?

PL/SQL (Procedural Language/SQL) es una extensión de SQL utilizada en Oracle para escribir bloques de código que incluyen estructuras de programación como variables, ciclos y condicionales. Esto permite realizar operaciones más avanzadas en bases de datos.

## Estructura de un bloque PL/SQL

* Todos los programas en PL/SQL siguen esta estructura básica:

```sql
DECLARE  -- (Opcional) Declaración de variables
    v_variable NUMBER;
BEGIN    -- Bloque ejecutable
    v_variable := 10;
    DBMS_OUTPUT.PUT_LINE('El valor es: ' || v_variable);
EXCEPTION  -- (Opcional) Manejo de excepciones
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error');
END;
```

* DECLARE: Se usa para definir variables (opcional).
* BEGIN: Aquí va el código principal.
* EXCEPTION: Manejo de errores (opcional).
* END;: Finaliza el bloque.

## Funciones y Procedimientos

¿Qué son y para qué sirven?
	•	Funciones (FUNCTION): Devuelven un valor y se usan dentro de consultas SQL.
	•	Procedimientos (PROCEDURE): Ejecutan una serie de acciones pero no devuelven valores directamente.

Ejemplo de función

```sql
CREATE OR REPLACE FUNCTION obtener_sueldo (p_id NUMBER) RETURN NUMBER IS
    v_sueldo NUMBER;
BEGIN
    SELECT sueldo INTO v_sueldo FROM empleados WHERE id = p_id;
    RETURN v_sueldo;
END obtener_sueldo;
```

Uso:
```sql
SELECT obtener_sueldo(101) FROM dual;
```

### Ejemplo de procedimiento

```sql
CREATE OR REPLACE PROCEDURE actualizar_sueldo (p_id NUMBER, p_nuevo_sueldo NUMBER) IS
BEGIN
    UPDATE empleados SET sueldo = p_nuevo_sueldo WHERE id = p_id;
    COMMIT;
END actualizar_sueldo;
```

Uso:

```sql
BEGIN
    actualizar_sueldo(101, 5000);
END;
```

* Diferencia clave: Usamos `RETURN` en una función, mientras que en un procedimiento simplemente realizamos una acción.

## Cursores

Los cursores permiten recorrer registros obtenidos de una consulta SQL dentro de PL/SQL.

Tipos de cursores
1. Cursores implícitos: Oracle los maneja automáticamente con SELECT INTO.
2. Cursores explícitos: Necesitamos declararlos, abrirlos, recorrerlos y cerrarlos manualmente.

Ejemplo de cursor explícito

```sql
DECLARE
    CURSOR c_empleados IS SELECT id, nombre FROM empleados;
    v_id empleados.id%TYPE;
    v_nombre empleados.nombre%TYPE;
BEGIN
    OPEN c_empleados;
    LOOP
        FETCH c_empleados INTO v_id, v_nombre;
        EXIT WHEN c_empleados%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Empleado: ' || v_id || ' - ' || v_nombre);
    END LOOP;
    CLOSE c_empleados;
END;
```

Nota: FETCH extrae una fila por vez, EXIT WHEN c_empleados%NOTFOUND detiene el ciclo cuando no hay más filas.

## Ciclos en PL/SQL

Existen varios tipos de ciclos para recorrer datos o repetir acciones.

1. Ciclo LOOP (infinito, hasta que se use EXIT)

```sql
DECLARE
    v_num NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('Número: ' || v_num);
        v_num := v_num + 1;
        EXIT WHEN v_num > 5;
    END LOOP;
END;
```

2. Ciclo WHILE (se ejecuta mientras la condición sea verdadera)

```sql
DECLARE
    v_num NUMBER := 1;
BEGIN
    WHILE v_num <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE('Número: ' || v_num);
        v_num := v_num + 1;
    END LOOP;
END;
```

3. Ciclo FOR (con límite de iteraciones)

```sql
BEGIN
    FOR v_num IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE('Número: ' || v_num);
    END LOOP;
END;
```

Diferencias:

* LOOP: Necesita EXIT WHEN para salir.
* WHILE: Se ejecuta mientras la condición sea TRUE.
* FOR: Se ejecuta un número fijo de veces.

Resumen: Cuándo y por qué usar cada uno

Concepto: Cuándo usarlo

* Funciones: Cuando necesitas calcular un valor y usarlo en consultas SQL.
* Procedimientos: Para ejecutar acciones como INSERT, UPDATE, DELETE.
* Cursores: Cuando necesitas recorrer múltiples filas de una consulta dentro de PL/SQL.
* Ciclos: Para repetir una acción varias veces (útil con cursores).
