-- Jan 10
connect sys/sys as sysdba;
SPOOL C:\BD2\j10_spool.txt;
SELECT to_char(sysdate,'DD Month YYYY Day HH:MI:SS Am') FROM dual;
-- PL/SQL is a block language
--  BEGIN
--     executable statement ;
--  END;
--  /
-- Ex1:  Create an anonimous block that does nothing

   BEGIN
     NULL;
   END;
   /
DROP USER jan10;
CREATE USER jan10 IDENTIFIED BY jan10;
GRANT connect, resource TO jan10;
connect jan10/jan10;
show user;
--  Ex2: Create a procedure named pj10_ex2 that does nothing
-- Syntax:
--  CREATE OR REPLACE PROCEDURE name_of_procedure
--                         [ (name_of_parameter MODE datatype, ...)] AS
--  BEGIN
--     executable statement ;
--  END;
--  /   
      CREATE OR REPLACE PROCEDURE  pj10_ex2 AS
        BEGIN
          NULL;
        END;
        /
-- To run or execute a procedure do:
--  EXECUTE name_of_procedure  OR  exec name_of_procedure

  exec pj10_ex22
  SELECT object_name, object_type FROM user_objects;
  SELECT text FROM user_source;
-- Ex3:  Create a procedure named pjan10_ex3 which has a variable named
-- v_num1 of type NUMBER. Assign number 10 to the variable in the executable section of
-- the procedure. (hint:  declare the variable between the key word AS and
-- BEGIN.  Assign a value using the assigning operator := )

   CREATE OR REPLACE PROCEDURE pjan10_ex3 AS
     v_num1 NUMBER ;
   BEGIN
     v_num1 := 10;
   END;
   /
-- Ex4: Modify the procedure of example 3 to display the content of the v_num1
-- on the screen as follow:
--   The content of variable v_num1 is  X.
-- (hint:  Use function PUT_LINE of DBMS_OUTPUT package to display text and
-- variable. Use concatenation operator || to join the text and variable togheter)

   CREATE OR REPLACE PROCEDURE pjan10_ex3 AS
     v_num1 NUMBER ;
   BEGIN
     v_num1 := 10;
     DBMS_OUTPUT.PUT_LINE('The content of variable v_num1 is ' || v_num1);
   END;
   /
-- We have to turn on the package with the following command
  SET SERVEROUTPUT ON
  exec pjan10_ex3

SPOOL OFF;