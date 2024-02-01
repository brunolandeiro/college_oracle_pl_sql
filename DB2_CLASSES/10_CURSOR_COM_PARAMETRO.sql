SPOOL c:\bd2\F_14_spool.txt
SELECT to_char(sysdate, 'Day DD Month Year HH:MI:SS') FROM dual;
SET SERVEROUTPUT ON
--Menu du jour
-- CURSOR WITH PARAMETER
-- CURSOR FOR UPDATE
-- Continue with Part 5
-- Example 1:  Create a procedure to display all departments.

CREATE OR REPLACE PROCEDURE feb14_ex1 AS
  -- step 1
  CURSOR dept_curr IS
    SELECT deptno, dname, loc
    FROM  dept;
    v_deptno dept.deptno%TYPE;
    v_dname  dept.dname%TYPE;
    v_loc    dept.loc%TYPE;

BEGIN
  -- step 2
   OPEN dept_curr;
  -- step 3
   FETCH dept_curr INTO v_deptno, v_dname, v_loc;
     WHILE dept_curr%FOUND LOOP
       DBMS_OUTPUT.PUT_LINE('Deparment number '|| v_deptno ||
       ' is ' || v_dname || ' located in the city of '||
         v_loc || '.' );
      FETCH dept_curr INTO v_deptno, v_dname, v_loc;
     END LOOP;
  -- step 4
   CLOSE dept_curr;
END;
/
-- Example 2:  Modify the procedure of example 1 to display
-- under EACH department all the employees working in it.
-- (hint: use CURSOR WITH PARAMETER)

--  Syntax:   
--CURSOR name_of_cursor (name_of_parameter DATATYPE) IS
--   SELECT name_of_column
--   FROM   name_of_table
--   WHERE  name_of_column = name_of_parameter ;

--   OPEN name_of_cursor (value);
exec feb14_ex1

CREATE OR REPLACE PROCEDURE feb14_ex1 AS
  -- step 1
  CURSOR dept_curr IS
    SELECT deptno, dname, loc
    FROM  dept;
    v_deptno dept.deptno%TYPE;
    v_dname  dept.dname%TYPE;
    v_loc    dept.loc%TYPE;
    
    CURSOR emp_curr (pc_deptno dept.deptno%TYPE) IS
       SELECT empno, ename, job , sal 
       FROM   emp
       WHERE  deptno = pc_deptno;
    v_empno emp.empno%TYPE;
    v_ename emp.ename%TYPE;
    v_job emp.job%TYPE;
    v_sal emp.sal%TYPE;

BEGIN
  -- step 2
   OPEN dept_curr;
  -- step 3
   FETCH dept_curr INTO v_deptno, v_dname, v_loc;
     WHILE dept_curr%FOUND LOOP
     DBMS_OUTPUT.PUT_LINE('---------------------------------');
       DBMS_OUTPUT.PUT_LINE('Deparment number '|| v_deptno ||
       ' is ' || v_dname || ' located in the city of '||
         v_loc || '.' );
            -- inner cursor
            OPEN emp_curr(v_deptno);
            FETCH emp_curr INTO v_empno, v_ename, v_job , v_sal;
            WHILE emp_curr%FOUND LOOP
              DBMS_OUTPUT.PUT_LINE('Employee number '|| v_empno ||
              ' is ' || v_ename || '. He/she is a '|| v_job || ' earning a salary of ' || v_sal ||' a month.' );
              FETCH emp_curr INTO v_empno, v_ename, v_job , v_sal;
            END LOOP;
            CLOSE emp_curr; 
      FETCH dept_curr INTO v_deptno, v_dname, v_loc;
     END LOOP;
  -- step 4
   CLOSE dept_curr;
END;
/
exec feb14_ex1
SPOOL OFF;