-- IF statement
-- Syntax:
--   IF condition1 THEN
--      statement1;
--   END IF;
--  statement1 will be executed when the condition1 is evaluated to TRUE.
--
--  IF condition1 THEN
--      statement1;
--  ELSE
--      statement2;
--  END IF;
--  statement1 will be executed when the condition1 is evaluated to TRUE,
-- otherwise statement2 will be executed
-- We can have NESTED IF
--  IF condition1 THEN
--      statement1;
--  ELSE
--      IF condition2 THEN
--         statement2;
--      END IF;
--      IF condition3 THEN
--         statement3;
--      ESLE
--        ...
--      END IF;
--     ...
--  END IF;
--  statement1 will be executed when the condition1 is evaluated to TRUE,
-- otherwise condition2 will be evaluated. Statement2 will be executed when
-- the result is TRUE,...
--  We can join the ELSE and IF toghether to remove the END IF as follow:
--  IF condition1 THEN
--      statement1;
--  ELSIF condition2 THEN
--      statement2;
--  ELSIF condition3 THEN
--      statement3;
--  END IF;
--  Ex2: Create a procedure named p_grade_convert that accepts a numerical
-- mark to convert in to letter GRADE using the follwing scale:
--  >= 90     A
--  80 - 89   B
--  70 - 79   C
--  60 - 69   D
--  < 60      'See you again my friend!'
CREATE OR REPLACE PROCEDURE p_grade_convert (p_mark IN NUMBER) AS
  v_grade VARCHAR2(40);
BEGIN
 IF p_mark > 100 OR p_mark < 0 THEN
   DBMS_OUTPUT.PUT_LINE('Please insert mark between 0 and 100!');
 ELSE
  IF p_mark >= 90 THEN
    v_grade := ' an A';
  ELSIF p_mark >= 80 THEN
    v_grade := 'a B';
  ELSIF p_mark >= 70 THEN
    v_grade := 'a C';
  ELSIF p_mark >= 60 THEN
    v_grade := 'a D';
  ELSE 
    v_grade := 'to repeat the course';
  END IF;
  DBMS_OUTPUT.PUT_LINE('For a mark of '|| p_mark || ', you will have '||
     v_grade ||'.');
 END IF;    
END;
/

EXEC p_grade_convert(55)
--  FUNCTION that returns a BOOLEAN datatype
-- Ex3:  Create a function name f_if_equal that accepts two numbers to return TRUE
-- if they are equal, otherwise return FALSE.
  CREATE OR REPLACE FUNCTION f_if_equal (P_num1 IN NUMBER, p_num2 IN NUMBER)
  RETURN BOOLEAN AS
    v_result BOOLEAN := FALSE;
  BEGIN
    IF p_num1 = p_num2 THEN
      v_result := TRUE;
    END IF;
  RETURN v_result;
  END;
  /
  SELECT f_if_equal(2,3) FROM dual;
  -- EX4:  Create a procedure name pj17_ex4 that accepts 2 numbers to use the
  -- function f_if_equal to display either:
  --  The 2 number X and Y are EQUAL  or
  --  The 2 numbers X and Y are NOT EQUAL.
  CREATE OR REPLACE PROCEDURE PJ17_EX4 (P1 IN NUMBER, P2 IN NUMBER) AS
    v1 NUMBER := P1;
    V2 number := p2;
    V_result VARCHAR2(20) := 'NOT EQUAL';
    BEGIN
      IF f_if_equal(v1,v2) THEN
        v_result := 'EQUAL';
      END IF;
   DBMS_OUTPUT.PUT_LINE('The two numbers '|| v1 || ' and ' || v2 || ' are ' ||
                         v_result  || '.');
    END;
    /
   EXEC pj17_ex4(1,2)  
   EXEC pj17_ex4(2,2) 
SPOOL OFF