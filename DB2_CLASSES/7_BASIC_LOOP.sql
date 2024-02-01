SPOOL c:\bd2\F_7_spool.txt
SELECT to_char(sysdate, 'Day DD Month Year HH:MI:SS') FROM dual;
SET SERVEROUTPUT ON
--Menu du jour
-- LOOP 3 kind of loop in PL/SQL
-- 1/  BASIC LOOP
--     Syntax:
--           LOOP
--             statement ;
--           EXIT WHEN condition;
--           END LOOP;

--     The statement is executed until the condition is evaluated to TRUE

-- Example 1: Create a procedure to display number 0 to 10 on the screen
--            using BASIC LOOP

CREATE OR REPLACE PROCEDURE feb7_ex1 AS
  v_counter NUMBER := 0;
BEGIN
   DBMS_OUTPUT.PUT_LINE('BASIC LOOP');
  LOOP
    DBMS_OUTPUT.PUT_LINE(v_counter);
    v_counter := v_counter + 1;
  EXIT WHEN v_counter > 10;
  END LOOP;
END;
/

exec feb7_ex1
SPOOL OFF;