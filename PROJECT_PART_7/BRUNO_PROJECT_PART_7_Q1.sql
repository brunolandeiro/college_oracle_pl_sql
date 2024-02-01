SPOOL BRUNO_PROJECT_PART_7_Q1_SPOOL.txt
SELECT TO_CHAR(SYSDATE, 'DD Month Year Day HH:MI:SS Am') from dual;
SET SERVEROUTPUT ON;

-- Question 1:
-- Run script 7northwoods in schemas des03
-- Using CURSOR FOR LOOP syntax 1 in a procedure to display all the 
-- faculty member (f_id, f_last, f_first, f_rank), under each faculty member, 
-- display all the student advised by that faculty member
-- (s_id, s_last, s_first, birthdate, s_class).
CREATE OR REPLACE PROCEDURE P7Q1 AS 
  CURSOR FAC_CURR IS SELECT F_ID,F_LAST, F_FIRST, F_RANK FROM FACULTY;
  CURSOR STD_CURR(P_F_ID STUDENT.F_ID%TYPE) IS SELECT S_ID, S_LAST, S_FIRST, S_DOB, S_CLASS FROM STUDENT WHERE F_ID = P_F_ID;
  BEGIN
    FOR FAC IN FAC_CURR LOOP
      DBMS_OUTPUT.PUT_LINE('');
      DBMS_OUTPUT.PUT_LINE('--------------FACULTY--------------');
      DBMS_OUTPUT.PUT_LINE(FAC.F_ID ||', '|| FAC.F_LAST ||', '|| FAC.F_FIRST ||', '|| FAC.F_RANK ||'.');
      DBMS_OUTPUT.PUT_LINE('-------------STUDENTS-------------');
      FOR STD IN STD_CURR(FAC.F_ID) LOOP
         DBMS_OUTPUT.PUT_LINE(STD.S_ID ||', '|| STD.S_LAST ||', '|| STD.S_FIRST ||', '|| STD.S_DOB ||', '|| STD.S_CLASS ||'.');
      END LOOP;
    END LOOP;
  END;
/
EXEC P7Q1;


SPOOL OFF;