SPOOL bruno_q1bonus.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;

-- Question 1: (use script 7clearwater)
-- Create a view containing item description, item_id, price, color, inventory_id, size of all the inventory of clearwater database.
-- Can we UPDATE, INSERT directly TO the view? If NOT, can you provide a solution?
CREATE OR REPLACE VIEW INV_VIEW AS
    SELECT I.ITEM_DESC, INV.ITEM_ID, INV.INV_PRICE, INV.COLOR, INV.INV_ID, INV.INV_SIZE
    FROM ITEM I, INVENTORY INV
    WHERE INV.ITEM_ID = I.ITEM_ID;

SELECT * FROM INV_VIEW;

    UPDATE INV_VIEW
    SET INV_PRICE = 1000
    WHERE ITEM_ID = 1 AND INV_ID = 26;
    
    UPDATE INV_VIEW
    SET INV_SIZE = 'M'
    WHERE ITEM_ID = 1 AND INV_ID = 23;
-- OK

-- INSERT INTO INV_VIEW VALUES ('T-shirt', 9, 2000, 'White', 50, 'L');
-- NOT OK

-- INSTEAD OF TRIGGER
  CREATE OR REPLACE TRIGGER INV_VIEW_TRIGGER
  INSTEAD OF INSERT ON INV_VIEW
  FOR EACH ROW
    BEGIN
      INSERT INTO ITEM (ITEM_DESC, ITEM_ID)
      VALUES (:NEW.ITEM_DESC, :NEW.ITEM_ID);

      INSERT INTO INVENTORY (ITEM_ID, INV_PRICE, COLOR, INV_ID, INV_SIZE)
      VALUES (:NEW.ITEM_ID, :NEW.INV_PRICE, :NEW.COLOR, :NEW.INV_ID, :NEW.INV_SIZE);
    END;
   /

INSERT INTO INV_VIEW VALUES ('T-shirt', 9, 2000, 'White', 50, 'L');
-- OK

SPOOL OFF