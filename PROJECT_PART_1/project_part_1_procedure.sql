SPOOL C:\DB2\project_part_1_procedure.txt
SELECT TO_CHAR(SYSDATE, 'DD Month Year Day HH:MI:SS Am') from dual;
SET SERVEROUTPUT ON;
-- Question 1: 
--  Create a procedure that accept a number to display the triple of its value to the screen as follow:
--  The triple of ... is ...
-- Ex:
--  Exec L1q1 (2)
-- The triple of 2 is 6.

CREATE OR REPLACE PROCEDURE L1q1(P_NUM IN NUMBER) AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('triple of ' || P_NUM || ' is ' || (P_NUM * 3));
    END;
    /
Exec L1q1 (2);

-- Question 2:
--  Create a procedure that accepts a number which represent the temperature in Celsius. 
--  The procedure will convert the temperature into Fahrenheit using the following formula:
--      Tf = (9/5) * Tc + 32
--  Then display the following:
--      ... degree in C is equivalent to ... in F
-- Test your procedure for 3 different temperature.  
CREATE OR REPLACE PROCEDURE L1q2(P_TC IN NUMBER) AS 
    V_TF NUMBER;
    BEGIN
        V_TF := (((9/5) * P_TC) + 32);
        V_TF := ROUND(V_TF, 2);
        DBMS_OUTPUT.PUT_LINE(P_TC || ' degree in C is equivalent to ' || V_TF || ' in F');
    END;
    /
Exec L1q2 (0);  
Exec L1q2 (10);   
Exec L1q2 (20);


--Question 3:
--	Create a procedure that accept a number which represent the temperature in Fahrenheit. 
--  The procedure will convert the temperature into Celsius using the following formula:
--	Tc = (5/9) * (Tf - 32)
--	Then display the following:
--	... degree in F is equivalent to ... in C
--	Test run your procedure for 3 different temperatures.
--	Use the procedure of question 2 to check for the accuracy of your procedure.
CREATE OR REPLACE PROCEDURE L1q3(P_TF IN NUMBER) AS
    V_TC NUMBER;
    BEGIN
        V_TC := ((5/9) * (P_TF - 32));
        V_TC := ROUND(V_TC, 2);
        DBMS_OUTPUT.PUT_LINE(P_TF || ' degree in F is equivalent to ' || V_TC || ' in C');
    END;
    /
Exec L1q3 (32);  
Exec L1q3 (50);   
Exec L1q3 (68);
EXEC L1q2(20);

-- Question 4:
-- Create a procedure that accepts a number used to calculate the
-- 5% GST, 9.98 % QST, the total of the 2 tax, the grand total, 
-- and to display EVERY THING to the screen as follow:
--  For the price of $...
--  You will have to pay $... GST
--  $ ... QST for a total of $...
--  The GRAND TOTAL is $ ...
--  Ex:
--  SQL> Exec L1q4 (100)
-- For the price of $100
-- You will have to pay $5 GST
-- $ 9.98 QST for a total of $14.98
-- The GRAND TOTAL is $ $114.98
CREATE OR REPLACE PROCEDURE L1q4(P_VAL IN NUMBER) AS
    V_GST NUMBER;
    V_QST NUMBER;
    V_GST_QST NUMBER;
    V_TOTAL NUMBER;
    BEGIN
        V_GST := (P_VAL * (5/100));
        V_GST := ROUND(V_GST, 2);
        V_QST := (P_VAL * (9.98/100));
        V_QST := ROUND(V_QST, 2);
        V_GST_QST := V_GST + V_QST;
        V_TOTAL := P_VAL + V_GST_QST;
        DBMS_OUTPUT.PUT_LINE('For the price of $ ' || P_VAL);
        DBMS_OUTPUT.PUT_LINE('You will have to pay $ ' || V_GST || ' GST');
        DBMS_OUTPUT.PUT_LINE('$ '|| V_QST ||' QST for a total of $ ' || V_GST_QST);
        DBMS_OUTPUT.PUT_LINE('The GRAND TOTAL is $ '|| V_TOTAL);
    END;
    /
Exec L1q4 (100);

-- Question 5:
-- Create a procedure that accepts 2 numbers represented the width and
-- height of a rectangular shape. The procedure will calculate the
-- area and the perimeter using the following formula:
-- Area = Width X Height
-- Perimeter = (Width + Height) X 2
-- display EVERY THING to the screen as follow:
--  The area of a ... by ... is .... It's parameter is ...
-- Ex: SQL> Exec L1q5 (2,3)
-- The area of a 2 by 3 rectangle is 6 It's parameter is 10.

CREATE OR REPLACE PROCEDURE L1q5(p_width IN NUMBER, p_height IN NUMBER) AS
    V_AREA NUMBER;
    V_PERIMETER NUMBER;
    BEGIN
        V_AREA := (p_width * p_height);
        V_PERIMETER := (p_width + p_height) * 2;
        DBMS_OUTPUT.PUT_LINE('The area of a '|| p_width ||' by ' || p_height 
            || ' rectangle is ' || V_AREA || ' Its perImeter is ' || v_perimeter);
    END;
    /
Exec L1q5 (2,3);

-- Question 6:
-- Use the formula of question 2, create a function that accepts the temperature in Celsius to
-- convert it into temperature in Fahrenheit. Test your function at least 3 times with 3 different temperature.
CREATE OR REPLACE FUNCTION L1q6(P_TC IN NUMBER) RETURN NUMBER AS 
    V_TF NUMBER;
    BEGIN
        V_TF := (((9/5) * P_TC) + 32);
        RETURN ROUND(V_TF, 2);
    END;
    /
SELECT L1q6(0) FROM DUAL;
SELECT L1q6(-10) FROM DUAL;
SELECT L1q6(10) FROM DUAL;

-- Question 7:
-- Use the formula of question 3, create a function that accepts the temperature in Fahrenheit to
-- convert it into temperature in Celsius. Test your function at least 3 times with 3 different temperatures.
CREATE OR REPLACE FUNCTION L1q7(P_TF IN NUMBER) RETURN NUMBER AS
    V_TC NUMBER;
    BEGIN
        V_TC := ((5/9) * (P_TF - 32));
        RETURN ROUND(V_TC, 2);
    END;
    /
SELECT L1q7(32) FROM DUAL;
SELECT L1q7(14) FROM DUAL;
SELECT L1q7(50) FROM DUAL;

SPOOL OF

