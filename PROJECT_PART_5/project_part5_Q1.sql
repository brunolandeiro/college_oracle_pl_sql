SPOOL bruno_project_part_5_Q1.txt
SELECT TO_CHAR(SYSDATE, 'DD Month Year Day HH:MI:SS Am') from dual;
SET SERVEROUTPUT ON;

-- Question 1 :
-- Run script 7northwoods.
-- Using cursor to display many rows of data, create a procedure to display the all the rows of table term.

CREATE OR REPLACE PROCEDURE p5q1 AS
-- STEP 1
CURSOR TERM_CURR IS
  SELECT TERM_ID, TERM_DESC, STATUS
  FROM "TERM";
V_TERM_ID "TERM".TERM_ID%TYPE;
V_TERM_DESC "TERM".TERM_DESC%TYPE;
V_STATUS "TERM".STATUS%TYPE;
BEGIN
  -- SETP 2 OPEN
  OPEN TERM_CURR;
  LOOP
    -- STEP 3 FETCH
    FETCH TERM_CURR INTO V_TERM_ID, V_TERM_DESC, V_STATUS;
    IF TERM_CURR%FOUND THEN
      DBMS_OUTPUT.PUT_LINE(V_TERM_ID ||', ' || V_TERM_DESC || ', ' || V_STATUS);
    END IF;
  EXIT WHEN NOT(TERM_CURR%FOUND);
  END LOOP;
  -- STEP 4: CLOSE
  CLOSE TERM_CURR;
END;
/
EXEC P5Q1;



spool off