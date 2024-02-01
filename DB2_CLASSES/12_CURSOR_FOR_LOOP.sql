----------------------- CURSOR FOR LOOP
-- Syntax 1:
-- We only need step 1, step 2,3,4 will be done automatically using
-- the CURSOR FOR LOOP as follow:

  -- FOR index IN name_of_cursor LOOP
        -- use . dot notation to access the column of the SELECT.
  -- END LOOP;
  -- note that index need not to be declared.
  -- Example 1:  Using schema scott, Create a procedure to display 
  --  all departments using CURSOR FOR LOOP Syntax 1 as follow:
  
     -- Department number X is Y located in the city of Z.
-- where X = deptno , Y = dname , Z = loc

CREATE OR REPLACE PROCEDURE feb21_ex1 AS
  -- step 1
  CURSOR dept_curr IS
  SELECT deptno, dname, loc
  FROM   dept;
BEGIN
  DBMS_OUTPUT.PUT_LINE('------------- Syntax 1 -------------' );
  FOR ciro IN dept_curr LOOP
    DBMS_OUTPUT.PUT_LINE('Department number ' || ciro.deptno ||
    ' is ' || ciro.dname || ' located in the city of ' || ciro.loc ||'.');
  END LOOP;
END;
/
exec feb21_ex1

  -- Syntax 2:
-- step 1,2,3,4 will be done automatically using
-- the CURSOR FOR LOOP as follow:

  -- FOR index IN (SELECT statement) LOOP
        -- use . dot notation to access the column of the SELECT.
  -- END LOOP;
  -- note that index need not to be declared.
  -- Example 2:  Using schema scott, Create a procedure to display 
  --  all departments using CURSOR FOR LOOP Syntax 2 as follow:
  
     -- Department number X is Y located in the city of Z.
-- where X = deptno , Y = dname , Z = loc

CREATE OR REPLACE PROCEDURE feb21_ex2 AS
BEGIN
  DBMS_OUTPUT.PUT_LINE('------------- Syntax 2 -------------' );
  FOR ciro IN (SELECT deptno, dname, loc FROM  dept) LOOP
    DBMS_OUTPUT.PUT_LINE('Department number ' || ciro.deptno ||
    ' is ' || ciro.dname || ' located in the city of ' || ciro.loc ||'.');
  END LOOP;
END;
/
exec feb21_ex2

  