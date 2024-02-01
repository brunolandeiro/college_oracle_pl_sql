SPOOL bruno_Project_part_8_2_spool.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 2: (use script 7software)
-- Create a package with a procedure that accepts the consultant id, skill id, and a
-- letter to insert a new row into table consultant_skill.
-- After the record is inserted, display the consultant last and first name, 
-- skill description and the status of the certification as CERTIFIED or Not Yet Certified.
-- Do not forget to handle the errors such as: Consultant, skill does not exist and 
-- the certification is different than 'Y' or 'N'.
-- Test your package at least 2 times!

CREATE OR REPLACE PACKAGE CS_PACKAGE IS
    global_c_last CONSULTANT.C_LAST%TYPE;
    global_c_first CONSULTANT.C_FIRST%TYPE;
    global_skill_desc SKILL.SKILL_DESCRIPTION%TYPE;
    global_consult_check BOOLEAN;
    global_skill_check BOOLEAN;
        PROCEDURE new_consultant (p_c_id NUMBER, p_skill_id NUMBER, p_status VARCHAR2);
        PROCEDURE check_consultant (p_c_id NUMBER);
        PROCEDURE check_skill (p_skill_id NUMBER);
END;
/


CREATE OR REPLACE PACKAGE BODY CS_PACKAGE IS 
    PROCEDURE new_consultant(p_c_id NUMBER, p_skill_id NUMBER, p_status VARCHAR2) AS
v_certification CONSULTANT_SKILL.CERTIFICATION%TYPE;
    BEGIN
    IF p_status = 'Y' OR p_status = 'N' THEN
            check_consultant(p_c_id);
            check_skill(p_skill_id);
	
        IF global_consult_check AND global_skill_check THEN
            SELECT CERTIFICATION
            INTO   v_certification
            FROM   CONSULTANT_SKILL
            WHERE  C_ID = p_c_id AND SKILL_ID = p_skill_id;

                IF v_certification = p_status THEN
                    DBMS_OUTPUT.PUT_LINE('Consultant number:' ||p_c_id ||'. Name: ' || global_c_first ||' '|| global_c_last ||
                                            '. Skill is ' || global_skill_desc || '. Certification: ' || v_certification || '. No need of update.');
                
                ELSE
                    UPDATE CONSULTANT_SKILL SET CERTIFICATION = p_status
                    WHERE  C_ID = p_c_id AND SKILL_ID = p_skill_id;
                    COMMIT;
                        DBMS_OUTPUT.PUT_LINE('Consultant number: ' ||p_c_id ||'. Name: ' || global_c_first ||' '|| global_c_last ||          '. Skill: ' ||
                                                global_skill_desc || '. Status changed from ' ||v_certification || ' to ' || p_status || '.');
                END IF;  
    END IF; 
       
     	ELSE
       	   DBMS_OUTPUT.PUT_LINE('Y or N.');
    	END IF;

      EXCEPTION 
      WHEN NO_DATA_FOUND THEN
        INSERT INTO CONSULTANT_SKILL VALUES(p_c_id, p_skill_id, p_status);
        COMMIT;
            DBMS_OUTPUT.PUT_LINE('Consultant number: ' ||p_c_id ||'. Name ' || global_c_first ||' ' || global_c_last ||
                                    '. Skill: ' || global_skill_desc || '. Status ' || p_status ||' inserted.');
    END new_consultant;


    PROCEDURE check_consultant(p_c_id NUMBER) AS
    BEGIN
        SELECT C_LAST, C_FIRST
        INTO   global_c_last, global_c_first
        FROM   CONSULTANT
        WHERE  C_ID = p_c_id;
        global_consult_check := TRUE;
      
        EXCEPTION WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Consultant number ' ||p_c_id ||' dont exist.');
        global_consult_check := FALSE;
    END check_consultant;


    PROCEDURE check_skill(p_skill_id NUMBER) AS
    BEGIN
        SELECT SKILL_DESCRIPTION
        INTO   global_skill_desc
        FROM   SKILL
        WHERE  SKILL_ID = p_skill_id;
        global_skill_check := TRUE;

        EXCEPTION WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Skill number ' ||p_skill_id ||' dont exist.');
        global_skill_check := FALSE;
        END check_skill;
END;
/

-- test for status
EXEC CS_PACKAGE.new_consultant(100, 1, 'X')

-- test for c_id
EXEC CS_PACKAGE.new_consultant(999, 1, 'Y')

-- test for skill_id
EXEC CS_PACKAGE.new_consultant(100, 88, 'Y')

-- test for combination c_id, skill_id NO change
EXEC CS_PACKAGE.new_consultant(100, 1, 'Y')

-- test for combination c_id, skill_id Exist , Update needed
EXEC CS_PACKAGE.new_consultant(100, 3, 'Y')

-- test for combination c_id, skill_id NOT Exist, insert needed
EXEC CS_PACKAGE.new_consultant(100, 5, 'N')

-- update
EXEC CS_PACKAGE.new_consultant(100, 5, 'Y')

SELECT * FROM CONSULTANT_SKILL;

SPOOL OFF