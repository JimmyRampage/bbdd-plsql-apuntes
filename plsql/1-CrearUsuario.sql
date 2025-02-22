CREATE USER maradb IDENTIFIED BY 123456;
GRANT ALL PRIVILEGES TO maradb;

ALTER SESSION SET CURRENT_SCHEMA = maradb; -- Te conecta a la db creada


GRANT CREATE PROCEDURE TO C##db_jimmy;
GRANT EXECUTE ANY PROCEDURE TO C##db_jimmy;


---------------------------------------------------------------------------------------------------
-- ELIMINAR USUARIO
CONNECT sys/password AS SYSDBA;

REVOKE ALL PRIVILEGES FROM JIMMYDB;

BEGIN
    FOR rec IN (SELECT object_name, object_type FROM all_objects WHERE owner = 'JIMMYDB') LOOP
        EXECUTE IMMEDIATE 'DROP ' || rec.object_type || ' ' || 'JIMMYDB.' || rec.object_name;
    END LOOP;
END;

DROP USER JIMMYDB CASCADE;
