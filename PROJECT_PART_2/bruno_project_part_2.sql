SPOOL C:\DB2\bruno_project_part_2.txt
SELECT TO_CHAR(SYSDATE, 'DD Month Year Day HH:MI:SS Am') from dual;
SET SERVEROUTPUT ON;
-- Question 1: Create a function that accepts 2 numbers to calculate the product of them. Test your function in SQL*Plus
create or replace function L2Q1(P_NUM_1_IN IN NUMBER, P_NUM_2_IN IN NUMBER) RETURN NUMBER AS
    BEGIN
        RETURN P_NUM_1_IN * P_NUM_2_IN;
    END;
    /
SELECT L2Q1(2,2) FROM DUAL ;

-- Question 2: Create a procedure that accepts 2 numbers and use the function created in question 1 to display the following
-- For a rectangle of size .x. by .y. the area is .z.
-- where x, y is the values supplied on run time by the user and z is the values calculated using the function of question 1.
-- Test your procedure in SQL*Plus and hand in code + result for 2cases.
CREATE OR REPLACE PROCEDURE L2Q2(P_NUM_1_IN IN NUMBER, P_NUM_2_IN IN NUMBER) AS
    V_RESULT NUMBER;
    BEGIN
        V_RESULT := L2Q1(P_NUM_1_IN, P_NUM_2_IN);
        DBMS_OUTPUT.PUT_LINE('For a rectangle of size ' || P_NUM_1_IN || ' by '|| P_NUM_2_IN || ' the area is ' || V_RESULT ||'.');
    END;
    /
EXEC L2Q2(2,2);
EXEC L2Q2(2,3);
-- Question 3: Modify procedure of question 2 to display “square” when x and y are equal in length.
CREATE OR REPLACE PROCEDURE L2Q3(P_NUM_1_IN IN NUMBER, P_NUM_2_IN IN NUMBER) AS
    V_RESULT NUMBER;
    V_TEXT VARCHAR2(9);
    BEGIN
        V_RESULT := L2Q1(P_NUM_1_IN, P_NUM_2_IN);
        IF P_NUM_1_IN = P_NUM_2_IN THEN
            V_TEXT := 'square';
        else
            V_TEXT := 'rectangle';
        END IF;
        DBMS_OUTPUT.PUT_LINE('For a ' || V_TEXT || ' of size ' || P_NUM_1_IN || ' by '|| P_NUM_2_IN || ' the area is ' || V_RESULT ||'.');
    END;
    /
EXEC L2Q3(2,2);
EXEC L2Q3(2,3);

-- Question 4: Create a procedure that accepts a number represent Canadian dollar and a letter represent the new currency. 
-- The procedure will convert the Canadian dollar to the new currency using the following exchange rate:
-- E EURO 1.50
-- Y YEN 100
-- V Viet Nam DONG 10 000
-- Z Endora ZIP 1 000 000
-- Display Canadian money and new currency in a sentence as the following:
-- For ``x`` dollars Canadian, you will have ``y`` ZZZ
-- Where x is dollars Canadian y is the result of the exchange ZZZ is the currency
-- EX: exec L2Q4 (2,’Y’)
-- For 2 dollars Canadian, you will have 200 YEN
CREATE OR REPLACE PROCEDURE Q2L4(P_CAD_DOLL_IN IN NUMBER, P_CHAR_IN IN VARCHAR2) AS
    V_RESULT NUMBER;
    V_FACTOR NUMBER;
    V_CURRENCY VARCHAR2(15);
    BEGIN
        IF UPPER(P_CHAR_IN) = 'E' THEN
            V_FACTOR := 1.50;
            V_CURRENCY := 'EURO';
        ELSIF UPPER(P_CHAR_IN) = 'Y' THEN
            V_FACTOR := 100;
            V_CURRENCY := 'YEN';
        ELSIF UPPER(P_CHAR_IN) = 'V' THEN
            V_FACTOR := 10000;
            V_CURRENCY := 'Viet Nam DONG';
        ELSIF UPPER(P_CHAR_IN) = 'Z' THEN
            V_FACTOR := 1000000;
            V_CURRENCY := 'Endora ZIP';
        ELSE
            V_FACTOR := 0;
            DBMS_OUTPUT.PUT_LINE('INVALID INPUT!');
        END IF;
        IF V_FACTOR != 0 THEN
            V_RESULT := ROUND(P_CAD_DOLL_IN * V_FACTOR, 2);
            DBMS_OUTPUT.PUT_LINE('For ' || P_CAD_DOLL_IN || ' dollars Canadian, you will have '|| V_RESULT || ' ' || V_CURRENCY);
        END IF;
    END;    
    /
EXEC Q2L4(2,'y');
EXEC Q2L4(1,'E');
EXEC Q2L4(1,'Y');
EXEC Q2L4(1,'V');
EXEC Q2L4(1,'Z');

--Question 5: Create a function called YES_EVEN that accepts a number to determine if the number is EVEN or not. 
-- The function will return TRUE if the number inserted is EVEN otherwise the function will return FALSE
CREATE OR REPLACE FUNCTION YES_EVEN(P_NUM_IN IN NUMBER) RETURN BOOLEAN AS
BEGIN
    RETURN MOD(P_NUM_IN, 2) = 0;
END;
/
-- Question 6: Create a procedure that accepts a numbers and uses the function of question 5 to print out either the following:
-- Number … is EVEN OR Number … is ODD
-- EX: exec L2Q6 (6) Number 6 is EVEN
-- EX: exec L2Q6 (5) Number 5 is ODD
CREATE OR REPLACE PROCEDURE L2Q6(P_NUM_IN IN NUMBER) AS
V_RESULT VARCHAR(4);
BEGIN
    IF YES_EVEN(P_NUM_IN) THEN
        V_RESULT := 'EVEN';
    ELSE
        V_RESULT := 'ODD';
    END IF;
    DBMS_OUTPUT.PUT_LINE('Number ' || P_NUM_IN || ' is ' || V_RESULT);
END;
/
exec L2Q6 (6);
exec L2Q6 (5);

-- BONUS QUESTION
-- Modify question 4 to convert the money in any direction.
-- Ex:
-- exec L2Qbonus (2,’Y’,’V’)
-- For 2 YEN, you will have 200 Viet Nam DONG
-- exec L2Qbonus (20000,’V’,’C’)
-- For 20000 Viet Nam DONG, you will have 2 dollars Canadian

CREATE OR REPLACE TYPE CURRENCY AS OBJECT (
C_NAME VARCHAR2(30),
INICIAL VARCHAR2(1),
CAD_FACTOR NUMBER);
/
CREATE OR REPLACE FUNCTION GET_CURRENCY(P_CHAR_IN IN VARCHAR2) RETURN CURRENCY AS
BEGIN
    IF UPPER(P_CHAR_IN) = 'E' THEN
        RETURN CURRENCY('EURO', 'E', 1.50);
    ELSIF UPPER(P_CHAR_IN) = 'Y' THEN
       RETURN CURRENCY('YEN', 'Y', 100);
    ELSIF UPPER(P_CHAR_IN) = 'V' THEN
        RETURN CURRENCY('Viet Nam DONG', 'V', 10000);
    ELSIF UPPER(P_CHAR_IN) = 'Z' THEN
         RETURN CURRENCY('Endora ZIP', 'Z', 1000000);
    ELSIF UPPER(P_CHAR_IN) = 'C' THEN
        RETURN CURRENCY('dollars Canadian', 'C', 1);
    END IF;
    RETURN CURRENCY('','',0);
END;
/

CREATE OR REPLACE FUNCTION CONVERT_FROM_CAD(P_CAD_DOLL_IN IN NUMBER, P_CHAR_IN IN VARCHAR2) RETURN NUMBER AS
V_CURRENCY CURRENCY;
BEGIN
    V_CURRENCY := GET_CURRENCY(P_CHAR_IN);
    RETURN ROUND(P_CAD_DOLL_IN * V_CURRENCY.CAD_FACTOR, 2);
END;
/

CREATE OR REPLACE FUNCTION CONVERT_TO_CAD(P_VAL_IN IN NUMBER, P_CHAR_IN IN VARCHAR2) RETURN NUMBER AS
V_CURRENCY CURRENCY;
BEGIN
    V_CURRENCY := GET_CURRENCY(P_CHAR_IN);
    RETURN ROUND(P_VAL_IN / V_CURRENCY.CAD_FACTOR, 2);
END;
/

CREATE OR REPLACE PROCEDURE L2Qbonus(P_VAL_IN IN NUMBER, P_CURRENCY_FROM_IN IN VARCHAR2, P_CURRENCY_TO_IN IN VARCHAR2) AS
V_CAD_VAL NUMBER;
V_RESULT NUMBER;
V_CURRENCY_FROM CURRENCY;
V_CURRENCY_TO CURRENCY;
BEGIN
    V_CURRENCY_FROM := GET_CURRENCY(P_CURRENCY_FROM_IN);
    V_CURRENCY_TO := GET_CURRENCY(P_CURRENCY_TO_IN);
    V_CAD_VAL := CONVERT_TO_CAD(P_VAL_IN, V_CURRENCY_FROM.INICIAL);
    V_RESULT := CONVERT_FROM_CAD(V_CAD_VAL, V_CURRENCY_TO.INICIAL);
    DBMS_OUTPUT.PUT_LINE('For ' || P_VAL_IN || ' ' || V_CURRENCY_FROM.C_NAME || ', you will have ' || V_RESULT || ' ' || V_CURRENCY_TO.C_NAME);
END;
/
exec L2Qbonus (2,'Y','V');
exec L2Qbonus (20000,'V','C');
exec L2Qbonus (200,'V','Y');
exec L2Qbonus (1,'C','Y');
exec L2Qbonus (1,'C','V');
exec L2Qbonus (1,'Y','V');
SPOOL OF

