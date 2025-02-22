Los tipos compuestos en PL/SQL permiten agrupar varios valores en una sola estructura, lo que facilita la manipulación de datos complejos. Los principales tipos compuestos son:

### 1. **RECORD**
   - Es similar a una estructura en otros lenguajes de programación.
   - Se usa para almacenar múltiples valores de diferentes tipos en un solo objeto.
   - Los campos pueden estar basados en una tabla de la base de datos o definirse manualmente.
   - **Cuándo usarlo:** Cuando necesitas agrupar datos relacionados en una estructura única.

   **Ejemplo de uso:**
   ```sql
   DECLARE
       TYPE empleado_rec IS RECORD (
           emp_id NUMBER,
           nombre VARCHAR2(100),
           salario NUMBER(10,2)
       );
       emp empleado_rec;
   BEGIN
       emp.emp_id := 101;
       emp.nombre := 'Juan Pérez';
       emp.salario := 3500.00;
       
       DBMS_OUTPUT.PUT_LINE('Empleado: ' || emp.nombre || ', Salario: ' || emp.salario);
   END;
   /
   ```

---

### 2. **TABLE (Asociative Array o PL/SQL Table)**
   - Es similar a un array asociativo (diccionario en Python).
   - Se indexa por números o valores de otro tipo, como VARCHAR2.
   - No tiene un tamaño fijo y puede crecer dinámicamente.
   - **Cuándo usarlo:** Cuando necesitas una colección indexada de valores sin un límite predefinido.

   **Ejemplo de uso:**
   ```sql
   DECLARE
       TYPE empleados_tab IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
       empleados empleados_tab;
   BEGIN
       empleados(1) := 'Juan Pérez';
       empleados(2) := 'María Gómez';
       
       DBMS_OUTPUT.PUT_LINE('Empleado 1: ' || empleados(1));
   END;
   /
   ```

---

### 3. **VARRAY (Variable-Size Array)**
   - Es un array con tamaño fijo definido en su declaración.
   - Se almacena como un solo objeto en la base de datos.
   - A diferencia de TABLE, tiene un límite de elementos.
   - **Cuándo usarlo:** Cuando necesitas un array de tamaño conocido que no crezca más allá del límite establecido.

   **Ejemplo de uso:**
   ```sql
   DECLARE
       TYPE numeros_varray IS VARRAY(5) OF NUMBER;
       numeros numeros_varray := numeros_varray(10, 20, 30);
   BEGIN
       DBMS_OUTPUT.PUT_LINE('Primer número: ' || numeros(1));
   END;
   /
   ```

---

### **Diferencias y Límites**
| Tipo | Indexación | Tamaño | Se almacena en BD | Uso típico |
|------|-----------|--------|------------------|------------|
| RECORD | Campos con nombre | Fijo (definido por sus atributos) | No | Agrupar datos heterogéneos |
| TABLE | Índice (PLS_INTEGER o VARCHAR2) | Dinámico | No (a menos que sea una tabla anidada en BD) | Colecciones flexibles y sin tamaño fijo |
| VARRAY | Índice secuencial (1,2,3...) | Fijo (definido en la declaración) | Sí | Almacenar listas de tamaño conocido |

### **¿Cuándo usar cada uno?**
- **RECORD:** Para estructurar datos relacionados como si fueran un solo objeto.
- **TABLE:** Para manejar grandes conjuntos de datos en memoria sin límite predefinido.
- **VARRAY:** Para almacenar colecciones con un tamaño máximo predefinido y acceder a los datos secuencialmente.

Si necesitas más detalles o ejemplos específicos, dime en qué contexto los quieres usar. 🚀