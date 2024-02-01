SPOOL c:\bd2\F_14_spool.txt
SELECT to_char(sysdate, 'Day DD Month Year HH:MI:SS') FROM dual;
SET SERVEROUTPUT ON
--------------------------------------------------------------- -- CURSOR FOR UPDATE
  -- Syntax:  
  --         CURSOR name_of_cursor IS
  --         SELECT name_of_column1, name_of_column2
  --         FROM   name_of_table
  --         FOR UPDATE OF name_of_column ;
  
  -- Example 3:  Create a procedure that accepts a number represent the percentage increase in salary.  The procedure
  --  will LOCK and update the salary with the new salary calcualted using the percentage inserted on run time.
  
     CREATE OR REPLACE PROCEDURE feb14_ex3(p_percent NUMBER) AS
       CURSOR emp_curr IS
         SELECT ename, sal
         FROM   emp
         FOR UPDATE OF sal;
         
         v_ename emp.ename%TYPE;
         v_sal   emp.sal%TYPE;
         v_new_sal NUMBER;
         
     BEGIN
       OPEN emp_curr;
       FETCH emp_curr INTO v_ename, v_sal;
       WHILE emp_curr%FOUND LOOP
         v_new_sal := v_sal + v_sal*p_percent/100;
         UPDATE emp SET sal = v_new_sal
         WHERE CURRENT OF emp_curr;
         DBMS_OUTPUT.PUT_LINE('The salary of Mr. '|| v_ename || ' has been changed from ' || v_sal || ' to ' ||
            v_new_sal ||' my friend Ciro!');
         FETCH emp_curr INTO v_ename, v_sal;
        END LOOP;
      CLOSE emp_curr;
      COMMIT;
END;
/

EXEC feb14_ex3(-10)
SPOOL OFF;