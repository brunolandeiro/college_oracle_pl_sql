SPOOL C:\DB2\PROJECT_PART_3\bruno_project_part_3_Q1.txt
SELECT TO_CHAR(SYSDATE, 'DD Month Year Day HH:MI:SS Am') from dual;
SET SERVEROUTPUT ON;
-- Question 1: (user scott)
-- Create a procedure that accepts an employee number 
-- to display the name of the department where he works, his name, his annual salary (do not forget his one time commission)
-- Note that the salary in table employee is monthly salary.
-- Handle the error (use EXCEPTION)
-- hint: the name of the department can be found from table dept.
CREATE OR REPLACE PROCEDURE P3Q1(P_EMPNO IN NUMBER) AS
V_DNAME VARCHAR2 (100);
V_DLOC VARCHAR2 (100);
V_ENAME VARCHAR2 (100);
V_ESAL NUMBER;
V_ECOMM NUMBER;
V_ANNUAL_SAL NUMBER;
BEGIN
    SELECT D.DNAME, D.LOC, E.ENAME, E.SAL, E.COMM
    INTO V_DNAME, V_DLOC, V_ENAME, V_ESAL, V_ECOMM
    FROM DEPT D
    JOIN EMP E ON E.DEPTNO = D.DEPTNO
    WHERE E.EMPNO = P_EMPNO;
    V_ECOMM := NVL(V_ECOMM, 0);
    V_ESAL := NVL(V_ESAL, 0);
	V_ANNUAL_SAL := ROUND((V_ESAL * 12) + V_ECOMM, 2);
	DBMS_OUTPUT.PUT_LINE('Department''s name: ' || V_DNAME);
    DBMS_OUTPUT.PUT_LINE('Work location: ' || V_DLOC);
    DBMS_OUTPUT.PUT_LINE('Employee''s name: ' || V_ENAME);
    DBMS_OUTPUT.PUT_LINE('Annual salary: ' || V_ANNUAL_SAL);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee number ' || P_EMPNO || ' does not exist!');
END;
/

EXEC p3q1(7902)
EXEC p3q1(7499)
EXEC p3q1(99)


SPOOL OF