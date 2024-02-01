SPOOL bruno_project_part_9_q2_spool.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 2: des03, script 7northwoods
-- Create a package with OVERLOADING procedure used to insert a new student. The user has the choice of providing either
-- a/ Student id, last name, birthdate
-- b/ Last Name, birthdate
-- c/ Last Name, address
-- d/ Last Name, First Name, birthdate, faculty id
-- In case no student id is provided, please use a number from a sequence called student_sequence.
-- Make sure that the package with the overloading procedure is user friendly enough to handle error such as:
-- Faculty id does not exist
-- Student id provided already existed
-- Birthdate is in the future
-- Please test for all cases and hand in spool file.

CREATE OR REPLACE PACKAGE STUDENT_PACKAGE IS
    PROCEDURE STUDENT_INSERT(P_S_ID NUMBER, P_S_LAST VARCHAR2, P_S_DOB DATE);
    PROCEDURE STUDENT_INSERT(P_S_LAST VARCHAR2, P_S_DOB DATE);
    PROCEDURE STUDENT_INSERT(P_S_LAST VARCHAR2, P_S_ADDRESS VARCHAR2);
    PROCEDURE STUDENT_INSERT(P_S_LAST VARCHAR2, P_S_FIRST VARCHAR2, P_S_DOB DATE, P_F_ID NUMBER);
END;
/


DROP SEQUENCE STUDENT_SEQUENCE;

CREATE SEQUENCE STUDENT_SEQUENCE START WITH 7 NOCACHE;


CREATE OR REPLACE PACKAGE BODY STUDENT_PACKAGE IS
    PROCEDURE STUDENT_INSERT(P_S_ID NUMBER, P_S_LAST VARCHAR2, P_S_DOB DATE) AS
    v_s_id NUMBER;
    BEGIN
        SELECT S_ID
        INTO v_s_id
        FROM STUDENT
        WHERE S_ID = P_S_ID;
        DBMS_OUTPUT.PUT_LINE('Student id provided ' || P_S_ID || ' already existed.');
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            IF P_S_DOB > SYSDATE THEN
                DBMS_OUTPUT.PUT_LINE('Birthdate ' || P_S_DOB || ' is in the future.');
            ELSE
                INSERT INTO STUDENT(S_ID, S_LAST, S_DOB)
                VALUES (P_S_ID, P_S_LAST, P_S_DOB);
                COMMIT;
            END IF;
    END ;

    PROCEDURE STUDENT_INSERT(P_S_LAST VARCHAR2, P_S_DOB DATE) AS
    BEGIN
        IF P_S_DOB > SYSDATE THEN
            DBMS_OUTPUT.PUT_LINE('Birthdate ' || P_S_DOB || ' is in the future.');
        ELSE
            INSERT INTO student(S_ID, S_LAST, S_DOB)
            VALUES (student_sequence.NEXTVAL, P_S_LAST, P_S_DOB);
            COMMIT;
        END IF;
    END ;
    
    PROCEDURE STUDENT_INSERT(P_S_LAST VARCHAR2, P_S_ADDRESS VARCHAR2) AS
    BEGIN
        INSERT INTO student(S_ID, S_LAST, S_ADDRESS)
        VALUES (student_sequence.NEXTVAL, P_S_LAST, P_S_ADDRESS);
        COMMIT;
    END ;

    PROCEDURE STUDENT_INSERT(P_S_LAST VARCHAR2, P_S_FIRST VARCHAR2, P_S_DOB DATE, P_F_ID NUMBER) AS
    v_f_id NUMBER;
    BEGIN
        IF P_S_DOB > SYSDATE THEN
            DBMS_OUTPUT.PUT_LINE('Birthdate ' || P_S_DOB || ' is in the future.');
        ELSE
            SELECT F_ID
            INTO v_f_id
            FROM STUDENT
            WHERE F_ID = P_F_ID;
            INSERT INTO STUDENT(S_ID, S_LAST, S_FIRST, S_DOB, F_ID)
            VALUES (student_sequence.NEXTVAL, P_S_LAST, P_S_FIRST, P_S_DOB, P_F_ID);
            COMMIT;
        END IF;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Faculty id ' || P_F_ID || ' does not exist.');   
    END ;
END;
/

EXEC STUDENT_PACKAGE.STUDENT_INSERT(30, 'Levesque', TO_DATE('1976-11-20', 'YYYY-MM-DD'));
EXEC STUDENT_PACKAGE.STUDENT_INSERT('Jean', TO_DATE('2003-01-02', 'YYYY-MM-DD'));
EXEC STUDENT_PACKAGE.STUDENT_INSERT('LaSalle', '2000 Saint-Catherine');
EXEC STUDENT_PACKAGE.STUDENT_INSERT('Landeiro', 'Bruno', TO_DATE('1993-02-18', 'YYYY-MM-DD'), 2);

-- handle error
EXEC STUDENT_PACKAGE.STUDENT_INSERT('Landeiro', 'Bruno', TO_DATE('1993-02-18', 'YYYY-MM-DD'), 10);
EXEC STUDENT_PACKAGE.STUDENT_INSERT(30, 'Levesque', TO_DATE('1976-11-20', 'YYYY-MM-DD'));
EXEC STUDENT_PACKAGE.STUDENT_INSERT('Jean', TO_DATE('2050-01-02', 'YYYY-MM-DD'));

SPOOL OFF