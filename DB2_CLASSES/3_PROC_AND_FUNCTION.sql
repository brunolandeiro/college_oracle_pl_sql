show user
SPOOL C:\BD2\j13_spool.txt
SELECT to_char(sysdate, 'DD Month Year Day HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE  pj10_ex2 AS
        BEGIN
          NULL;
        END;
        /
exec pj10_ex2



CREATE OR REPLACE PROCEDURE pjan10_ex3 AS
     v_num1 NUMBER ;
   BEGIN
     v_num1 := 10;
   END;
   /
   
   EXEC pjan10_ex3
   
   
   CREATE OR REPLACE PROCEDURE pjan10_ex4 AS
     v_num1 NUMBER ;
   BEGIN
     v_num1 := 10;
     DBMS_OUTPUT.PUT_LINE('The content of variable v_num1 is ' || v_num1);
   END;
   /
   exec Pjan10_ex4
   -- Ex5:Create a procedure that accepts a number
   -- to calculate and display 7 time the input value
   -- as follow:
   --  Seven time of X is Y !
   CREATE OR REPLACE PROCEDURE pj13_ex5 (p_num_in IN NUMBER) AS
     v_num_in NUMBER;
     v_result NUMBER;
   BEGIN
     v_num_in := p_num_in;
     v_result := v_num_in * 7;
     DBMS_OUTPUT.PUT_LINE('Seven time of ' || v_num_in || ' is ' ||
             v_result || ' !' );
  END;
  /
  exec pj13_ex5(35464654654064)
  -- Ex6: Create a function named f_7_time that accepts a number
  -- to return 7 time the input value to the calling environement.
  -- Syntax:  CREATE OR REPLACE FUNCTION name_of_function
  --       [ (name_of_parameter MODE datatype, ...) ]
  --  RETURN datatype AS
  --     BEGIN
  --        RETURN variable;
  --     END;
  --   /
  CREATE OR REPLACE FUNCTION f_7_time (p_num_in IN NUMBER)
  RETURN NUMBER AS
     v_num_in NUMBER;
     v_result NUMBER;
     BEGIN
       v_num_in := p_num_in;
       v_result := v_num_in * 7;
     RETURN v_result;
     END;
     /
     -- TO run a function do:
     -- SELECT name_of_function FROM dual;
     SELECT f_7_time(7) FROM dual;
     SELECT table_name FROM user_tables;
     DESCRIBE emp
     SELECT empno, ename, sal, f_7_time(sal) "Dream Salary" FROM emp;
SPOOL OFF