SPOOL BRUNO_PROJECT_PART_6_Q2_Q5_SPOOL.txt
SELECT TO_CHAR(SYSDATE, 'DD Month Year Day HH:MI:SS Am') from dual;
SET SERVEROUTPUT ON;
-- Question 2:
-- Run script 7software in schemas des04
-- Create a procedure to display all the consultants. 
-- Under each consultant display all his/her skill (skill description) and the status of the skill (certified or not)
CREATE OR REPLACE PROCEDURE P6_Q2 AS
CURSOR CONSULTANT_CURR IS SELECT C_ID, C_LAST, C_FIRST FROM CONSULTANT;
CURSOR CONSULTANT_SKILL_CURR(P_C_ID CONSULTANT.C_ID%TYPE) IS 
  SELECT s.SKILL_DESCRIPTION, 
    DECODE(upper(CS.CERTIFICATION), 'Y', 'CERTIFIED', 'N', 'NOT CERTIFIED') AS CERT
    FROM SKILL S 
    JOIN CONSULTANT_SKILL CS ON S.skill_id = CS.skill_id 
    WHERE CS.C_ID = P_C_ID;
BEGIN
  FOR CONS IN CONSULTANT_CURR LOOP
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('-----CONSULTANT-----');
    DBMS_OUTPUT.PUT_LINE(CONS.C_ID ||', '|| CONS.C_LAST ||', '|| CONS.C_FIRST);
    DBMS_OUTPUT.PUT_LINE('-----SKILLS-----');
    FOR S_INDEX IN CONSULTANT_SKILL_CURR(CONS.C_ID) LOOP
        DBMS_OUTPUT.PUT_LINE(S_INDEX.SKILL_DESCRIPTION ||', '|| S_INDEX.CERT);
    END LOOP;
  END LOOP;
END;
/
EXEC P6_Q2;

-- Question 5:
-- Run script 7software in schemas des04
-- Create a procedure that accepts a consultant id, and a character used to 
-- update the status (certified or not) of all the SKILLs belonged to the 
-- consultant inserted. 
-- Display 4 information about the consultant such as id, name, … Under each 
-- consultant display all his/her skill (skill description) and the OLD and NEW 
-- status of the skill (certified or not).

CREATE OR REPLACE PROCEDURE P6_Q5(P_C_ID NUMBER, P_CERTIFIED VARCHAR2) AS
NEW_STATUS VARCHAR2(20) := 'NOT CERTIFIED';
CURSOR CONSULTANT_CURR(P_C_ID CONSULTANT.C_ID%TYPE) IS 
  SELECT C_ID, C_LAST, C_FIRST, C_CITY  
  FROM CONSULTANT 
  WHERE C_ID = P_C_ID;
CURSOR CONSULTANT_SKILL_CURR(P_C_ID CONSULTANT.C_ID%TYPE) IS 
  SELECT s.SKILL_DESCRIPTION, CS.C_ID, CS.SKILL_ID,
    DECODE(upper(CS.CERTIFICATION), 'Y', 'CERTIFIED', 'N', 'NOT CERTIFIED') AS CERT
    FROM SKILL S 
    JOIN CONSULTANT_SKILL CS ON S.skill_id = CS.skill_id 
    WHERE CS.C_ID = P_C_ID 
    FOR UPDATE OF CS.CERTIFICATION;
BEGIN
  IF P_CERTIFIED = 'Y' OR P_CERTIFIED = 'N' THEN
    IF P_CERTIFIED = 'Y' THEN 
      NEW_STATUS := 'CERTIFIED'; 
    END IF;
    FOR CONS IN CONSULTANT_CURR(P_C_ID) LOOP
      DBMS_OUTPUT.PUT_LINE('');
      DBMS_OUTPUT.PUT_LINE('-----CONSULTANT-----');
      DBMS_OUTPUT.PUT_LINE(CONS.C_ID ||', '|| CONS.C_LAST ||', '|| CONS.C_FIRST ||', '|| CONS.C_CITY);
      DBMS_OUTPUT.PUT_LINE('-----SKILLS-----');
      FOR S_INDEX IN CONSULTANT_SKILL_CURR(CONS.C_ID) LOOP
          DBMS_OUTPUT.PUT_LINE(S_INDEX.SKILL_DESCRIPTION ||', OLD STATUS: '|| S_INDEX.CERT ||', NEW STATUS: ' || NEW_STATUS);
          UPDATE CONSULTANT_SKILL SET CERTIFICATION = P_CERTIFIED WHERE C_ID = S_INDEX.C_ID AND SKILL_ID = S_INDEX.SKILL_ID;
      END LOOP;
      COMMIT;
    END LOOP;
    ELSE
      DBMS_OUTPUT.PUT_LINE('PLEASE Y OR N!');
    END IF;
END;
/
EXEC P6_Q5(100, 'Y');
EXEC P6_Q5(100, 'N');
EXEC P6_Q5(100, 'D');
EXEC P6_Q5(10000000, 'Y');


SPOOL OFF;