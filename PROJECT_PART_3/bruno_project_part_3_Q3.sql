SPOOL C:\DB2\PROJECT_PART_3\bruno_project_part_3_Q3.txt
SELECT TO_CHAR(SYSDATE, 'DD Month Year Day HH:MI:SS Am') from dual;
SET SERVEROUTPUT ON;

-- Question 3: (use schemas des03, and script 7northwoods)
-- Create a function called find_age that accepts a date and return a number.
-- The function will use the sysdate and the date inserted to calculate the age of the person with the birthdate inserted.
-- Create a procedure that accepts a student number to display his name, his birthdate, and his age using the function find_age created above.
-- Handle the error ( use EXCEPTION)
CREATE OR REPLACE FUNCTION find_age(P_BD IN DATE) RETURN NUMBER AS
BEGIN
    RETURN TRUNC (MONTHS_BETWEEN(SYSDATE,P_BD) / 12);
END;
/

SELECT find_age(TO_DATE('18/02/1993', 'DD/MM/YYYY')) FROM DUAL;

SELECT S_LAST, S_DOB FROM student;
CREATE OR REPLACE PROCEDURE P3Q3(P_S_ID IN NUMBER) AS
V_S_LAST VARCHAR2(100);
V_S_DOB DATE;
V_AGE NUMBER;
BEGIN
    SELECT S_LAST, S_DOB INTO V_S_LAST, V_S_DOB FROM student WHERE S_ID = P_S_ID;
    V_AGE := FIND_AGE(V_S_DOB);
    DBMS_OUTPUT.PUT_LINE('Name: ' || V_S_LAST);
    DBMS_OUTPUT.PUT_LINE('Birthdate: ' || V_S_DOB);
    DBMS_OUTPUT.PUT_LINE('Age: ' || V_AGE);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('The STUDENT id ' || P_S_ID || ' does not exist!');
END;
/
EXEC P3Q3(1);
EXEC P3Q3(1111111111111111);
EXEC P3Q3(2);
EXEC P3Q3(3);
EXEC P3Q3(4);
SPOOL OF