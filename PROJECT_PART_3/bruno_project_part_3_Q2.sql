SPOOL C:\DB2\PROJECT_PART_3\bruno_project_part_3_Q2.txt
SELECT TO_CHAR(SYSDATE, 'DD Month Year Day HH:MI:SS Am') from dual;
SET SERVEROUTPUT ON;

-- Question 2
-- Create a procedure that accepts an inv_id (inventory)
-- to display the item description, price, color, inv_qoh (inventory), and the value of that inventory.
-- Handle the error (use EXCEPTION)
-- Hint: value is the product of price and quantity on hand.
-- value = price * quantity on hand
CREATE OR REPLACE PROCEDURE P3Q2 (P_INV_ID IN NUMBER) AS
V_ITEM_DESC varchar2 (100);
V_INV_PRICE number;
V_COLOR varchar2 (100);
V_INV_QOH number;
V_VALUE number;
begin
    SELECT IT.ITEM_DESC, NVL(I.INV_PRICE,0), I.COLOR, NVL(I.INV_QOH,0)
    INTO V_ITEM_DESC, V_INV_PRICE, V_COLOR, V_INV_QOH
    FROM ITEM IT
    JOIN INVENTORY I ON IT.ITEM_ID = I.ITEM_ID
    WHERE I.INV_ID = P_INV_ID;
    V_VALUE := ROUND(V_INV_PRICE * V_INV_QOH, 2);
    DBMS_OUTPUT.PUT_LINE('Item description: ' || V_ITEM_DESC);
    DBMS_OUTPUT.PUT_LINE('Price: ' || V_INV_PRICE);
    DBMS_OUTPUT.PUT_LINE('Color: ' || V_COLOR);
    DBMS_OUTPUT.PUT_LINE('Quantity: ' || V_INV_QOH);
    DBMS_OUTPUT.PUT_LINE('Value: ' || V_VALUE);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('The inventory id ' || P_INV_ID || ' does not exist!');
END;
/

EXEC P3Q2(2)
EXEC P3Q2(99)


SPOOL OF