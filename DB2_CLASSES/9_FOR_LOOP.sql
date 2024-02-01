SPOOL c:\bd2\F_7_spool.txt
SELECT to_char(sysdate, 'Day DD Month Year HH:MI:SS') FROM dual;
SET SERVEROUTPUT ON
--
-- 3/  FOR LOOP
--     Syntax:
--           FOR index IN low_end .. high_end LOOP
--             statement ;
--           END LOOP;

--     The statement is executed from the low_end to the high_end .  No need to declare and increment the index

-- Example 3: Create a procedure to display number 0 to 10 on the screen
--            using FOR LOOP

CREATE OR REPLACE PROCEDURE feb7_ex3 AS
BEGIN
 DBMS_OUTPUT.PUT_LINE('FOR LOOP');
  FOR ciro IN 0 .. 10 LOOP
    DBMS_OUTPUT.PUT_LINE(ciro);
  END LOOP;
END;
/

exec feb7_ex3



-- Example 4: Create a procedure to display number 10 to 0 on the screen
--            using FOR LOOP

CREATE OR REPLACE PROCEDURE feb7_ex4 AS
BEGIN
 DBMS_OUTPUT.PUT_LINE('FOR LOOP in REVERSE');
  FOR ciro IN REVERSE 0 .. 10 LOOP
    DBMS_OUTPUT.PUT_LINE(ciro);
  END LOOP;
END;
/

exec feb7_ex4
-- EXPLICIT CURSOR
-- BONUS QUESTION
-- Continue with Project Part 4

--  Implicit Cursor  in SQL
--  EXPLICIT CURSOR  in PL/SQL  -- Manipulate multiples rows in PL/SQL
--  We must follow 4 steps

-- Step 1:  DECLARATION
--        is done in the declaration section
--        Syntax:
--        CURSOR  name_of_cursor IS
--        SELECT statement ;

--    Ex:   CURSOR dept_curr IS
--          SELECT deptno, dname FROM dept;

-- Step 2:  OPEN
--        is done in the executable section
--        Syntax:    OPEN name_of_cursor ;

--    Ex:    OPEN dept_curr;
--  RESULT:  - The select statement is executed
--           - The result of the select statement if exist will be
--            send to the memory area named ACTIVE SET
--           - The cursor attribute %ISOPEN is set to TRUE

-- Step 3:  FETCH
--        is done in the executable section
--        Syntax:  FETCH name_of_cursor INTO variables;

--    Ex: FETCH dept_curr INTO v_deptno, v_dname ;
--  RESULT:  There are 2 possibilities
--   - Successfull fetch (data exist in the ACTIVE SET)
--   - The currsor attribute %FOUND is set to TRUE
--   - The currsor attribute %NOTFOUND is set to FALSE
--   - The currsor attribute %ROWCOUNT is increased by 1

--   - UN-Successfull fetch (NO data in the ACTIVE SET)
--   - The currsor attribute %FOUND is set to FALSE
--   - The currsor attribute %NOTFOUND is set to TRUE
--   - The currsor attribute %ROWCOUNT remained the same previous value

-- Step 4  CLOSE
--         is done in the executable section
--         Syntax:  CLOSE name_of_cursor;
--
--     Ex:   Close dept_curr;
--   RESULT:
--        -- The momory occupied by the ACTIVE SET is returned to the system
--        - The cursor attribute %ISOPEN is set to FALSE
------------------------------------------------------------------------
-- Example 5:  Create a procedure named feb7_ex5 to display, calculate and update the salary of all employees using
-- the scale below:
--   >= 5000      5%
--   4000 - 4999  10%
--   3000 - 3999  15%
--   2000 - 2999  20%
--   1000 - 1999  25%
--   0 - 999      100%
--       Display the output as follow:
--   Employee number X is Y.  With M% increase in salary his/her salary was changing from $O to $N !
--  where:  X = empno, Y = ename  M = percent increase,  O = old salary,  N = new salary.

CREATE OR REPLACE PROCEDURE feb7_ex5 AS
  -- step 1
  CURSOR emp_curr IS
  SELECT empno, ename, sal 
  FROM   emp;
  v_empno emp.empno%TYPE;
  v_ename emp.ename%TYPE;
  v_sal emp.sal%TYPE;
  v_percent NUMBER;
  v_new_sal NUMBER;
BEGIN
  -- step 2
  OPEN  emp_curr;
  -- step 3
  FETCH emp_curr INTO v_empno, v_ename, v_sal  ;
  WHILE emp_curr%FOUND LOOP
    IF v_sal >= 5000 THEN
      v_percent := 5;
    ELSIF v_sal >= 4000 THEN
      v_percent := 10;
      ELSIF v_sal >= 3000 THEN
      v_percent := 15;
      ELSIF v_sal >= 2000 THEN
      v_percent := 20;
      ELSIF v_sal >= 1000 THEN
      v_percent := 25;
      ELSIF v_sal >= 0 THEN
      v_percent := 100;
   END IF;
      v_new_sal := v_sal + v_sal * v_percent/100;
      UPDATE emp SET sal = v_new_sal WHERE empno = v_empno;
      DBMS_OUTPUT.PUT_LINE('Employee number '|| v_empno || ' is ' || v_ename || '. With '|| v_percent ||
      '%  increase in salary, his/her salary was changing from $'|| v_sal || ' to $' || v_new_sal ||'!');
   FETCH emp_curr INTO v_empno, v_ename, v_sal  ;
   END LOOP;
   -- step 4
   CLOSE emp_curr;
  COMMIT;
END;
/

exec feb7_ex5
SPOOL OFF;