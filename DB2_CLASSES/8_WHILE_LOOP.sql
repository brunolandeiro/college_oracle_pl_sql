SPOOL c:\bd2\F_7_spool.txt
SELECT to_char(sysdate, 'Day DD Month Year HH:MI:SS') FROM dual;
SET SERVEROUTPUT ON
--
-- 2/  WHILE LOOP
--     Syntax:
--           WHILE condition LOOP
--             statement ;
--           END LOOP;

--     The statement is executed when condition is evaluated to TRUE

-- Example 2: Create a procedure to display number 0 to 10 on the screen
--            using WHILE LOOP

CREATE OR REPLACE PROCEDURE feb7_ex2 AS
  v_counter NUMBER := 0;
BEGIN
 DBMS_OUTPUT.PUT_LINE('WHILE LOOP');
  WHILE v_counter <= 10 LOOP
    DBMS_OUTPUT.PUT_LINE(v_counter);
    v_counter := v_counter + 1;
  END LOOP;
END;
/

exec feb7_ex2
SPOOL OFF;