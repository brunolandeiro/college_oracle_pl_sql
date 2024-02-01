SPOOL project_part10_bruno.txt
SELECT to_char (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;

-- Question 1
-- (use schemas des02 with script 7clearwater)
-- We need to know WHO and WHEN the table CUSTOMER is modified.
-- Create table, sequence, and trigger to record the needed information.
-- Test your trigger!
DROP TABLE customer_audit;
CREATE TABLE customer_audit (row_id NUMBER, updating_user VARCHAR2(30), updating_time DATE);

DROP SEQUENCE customer_audit_sequence;
CREATE SEQUENCE customer_audit_sequence;

    CREATE OR REPLACE TRIGGER customer_audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON customer
    BEGIN
        INSERT INTO customer_audit
        VALUES(customer_audit_sequence.NEXTVAL, USER, sysdate);
    END;
    /


SELECT * FROM customer_audit;
INSERT INTO customer(c_id, c_last, c_first, c_city) VALUES (999,'Landeiro','Bruno', 'MTL');
UPDATE customer SET c_last = 'Lemos' WHERE c_id = 6;
DELETE FROM customer WHERE c_id = 999;
COMMIT;

SELECT row_id, updating_user, to_char(updating_time, 'DD Month Year HH:MI:SS') FROM customer_audit;

-- Question 2:
-- Table ORDER_LINE is subject to INSERT, UPDATE, and DELETE, create a trigger
-- to record who, when, and the action performed on the table order_line in a table called order_line_audit.
-- (hint: use UPDATING, INSERTING, DELETING to verify for action performed. For example: IF UPDATING THEN …)
-- Test your trigger!
DROP TABLE order_line_audit;
CREATE TABLE order_line_audit (row_id NUMBER, updating_user VARCHAR2(30), updating_time DATE, action_performed VARCHAR2(25));

DROP SEQUENCE order_line_audit_sequence;
CREATE SEQUENCE order_line_audit_sequence;

CREATE OR REPLACE TRIGGER order_line_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON order_line
BEGIN
    IF inserting THEN
        INSERT INTO order_line_audit VALUES (order_line_audit_sequence.NEXTVAL, USER, sysdate, 'INSERT');
	ELSIF updating THEN
        INSERT INTO order_line_audit VALUES (order_line_audit_sequence.NEXTVAL, USER, sysdate, 'UPDATE');
	ELSIF deleting THEN
        INSERT INTO order_line_audit VALUES (order_line_audit_sequence.NEXTVAL, USER, sysdate, 'DELETE');
	END IF;
END;
/

SELECT * FROM order_line;
SELECT * FROM order_line_audit;

INSERT INTO order_line(o_id, inv_id, ol_quantity)
VALUES (35, 25, 4);

UPDATE order_line
SET ol_quantity = 20
WHERE o_id = 35 AND inv_id = 25;

DELETE FROM order_line
WHERE o_id = 35 AND inv_id = 25;

COMMIT;

SELECT * FROM order_line_audit;


-- Question 3:
-- (use script 7clearwater)
-- Create a table called order_line_row_audit to record who, when, 
-- and the OLD value of ol_quantity every time the data of table ORDER_LINE is updated.
-- Test your trigger!
DROP TABLE order_line_row_audit;
CREATE TABLE order_line_row_audit (row_id NUMBER, updating_user VARCHAR2(30), updating_time DATE, old_ol_quantity NUMBER);

DROP SEQUENCE order_line_row_audit_sequence;
CREATE SEQUENCE order_line_row_audit_sequence;

CREATE OR REPLACE TRIGGER order_line_row_audit_trigger
AFTER UPDATE ON order_line FOR EACH ROW
BEGIN
	INSERT INTO order_line_row_audit VALUES (order_line_row_audit_sequence.NEXTVAL, USER, sysdate, :OLD.ol_quantity);
END;
/

SELECT * FROM order_line_row_audit;
UPDATE order_line SET ol_quantity = 40 WHERE o_id = 32 AND inv_id = 2;
COMMIT;

SELECT * FROM order_line_row_audit;

SPOOL OFF
