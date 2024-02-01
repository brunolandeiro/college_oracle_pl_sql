SPOOL C:\BD2\j17_spool.txt
SELECT to_char(sysdate,'Day DD Month Year HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON
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
     SELECT f_7_time (23) FROM dual;
     CREATE OR REPLACE FUNCTION f_7_timeB (p_num_in IN NUMBER)
  RETURN NUMBER AS
     v_num_in NUMBER := p_num_in;
     v_result NUMBER;
     BEGIN
       v_result := v_num_in * 7;
     RETURN v_result;
     END;
     /

SELECT f_7_timeB (2) FROM dual;

CREATE OR REPLACE FUNCTION f_7_timeC (p_num_in IN NUMBER)
  RETURN NUMBER AS
     v_result NUMBER;
     BEGIN
       v_result := P_num_in * 7;
     RETURN v_result;
     END;
     /

SELECT f_7_timeC (3) FROM dual;

CREATE OR REPLACE FUNCTION f_7_timeD (p_num_in IN NUMBER)
  RETURN NUMBER AS
     BEGIN
       RETURN  P_num_in * 7;
     END;
     /
SELECT f_7_timeD (7) FROM dual;
----------------------
--Menu du jour
 -- How to use function in a procedure
 -- The IF statement
 -- Funtion which return a BOOLEAN datatype
  
-- Ex1: Create a procedure named pj17_ex1 that accepts a number and use
-- the function f_7_time to display exactly the following:
  -- Seven time of X is Y !
  -- where X is the input value and Y is the value returned by the function
  CREATE OR REPLACE PROCEDURE pj17_ex1(p_num_in IN NUMBER) AS
    v_result NUMBER;
    BEGIN
      v_result := f_7_time(p_num_in);
      DBMS_OUTPUT.PUT_LINE('Seven time of ' || p_num_in || ' is ' ||
              v_result || ' !');
    END;
    /



EXEC pj17_ex1(7)
