SPOOL BRUNO_PROJECT_PART_8_SPOOL.txt
SELECT TO_CHAR(SYSDATE, 'DD Month Year Day HH:MI:SS Am') from dual;
SET SERVEROUTPUT ON;
-- Question 1: (use script 7clearwater)

-- Modify the package order_package (Example of lecture on PACKAGE) by adding 
-- function, procedure to verify the quantity on hand before insert a row in 
-- table order_line and to update also the quantity on hand of table inventory.

-- Test your package with different cases.
CREATE OR REPLACE PACKAGE order_package IS
     global_quantity NUMBER;
     global_inv_id   NUMBER;
     PROCEDURE create_new_order(p_customer_id NUMBER, p_meth_pmt VARCHAR2, p_os_id NUMBER);
     PROCEDURE create_new_order_line(p_order_id NUMBER);
     FUNCTION HAS_ENOUGH_ITENS RETURN BOOLEAN;
   END;
   /

CREATE OR REPLACE PACKAGE BODY order_package IS
  FUNCTION HAS_ENOUGH_ITENS RETURN BOOLEAN AS
  V_INV_QOH NUMBER;
  BEGIN
    select INV_QOH into V_INV_QOH from inventory where inv_id = global_inv_id;
    return V_INV_QOH >= global_quantity;
  END;
     PROCEDURE create_new_order(p_customer_id NUMBER,
       p_meth_pmt VARCHAR2, p_os_id NUMBER) AS
         v_order_id NUMBER;
     BEGIN
       SELECT order_sequence.NEXTVAL
       INTO v_order_id
       FROM  dual ;
       INSERT INTO orders
       VALUES(v_order_id, sysdate, p_meth_pmt, 
              p_customer_id, p_os_id);
       COMMIT;
       if HAS_ENOUGH_ITENS then
        create_new_order_line(v_order_id);
       end if;
     END create_new_order;

     PROCEDURE create_new_order_line(p_order_id NUMBER) AS
     BEGIN
       INSERT INTO order_line
       VALUES(p_order_id, global_inv_id, global_quantity);
       update inventory set inv_qoh = (inv_qoh - global_quantity) where inv_id = global_inv_id;
       COMMIT;
     END create_new_order_line;
   END;
   /

BEGIN
  order_package.global_quantity := 100;
  order_package.global_inv_id := 2;
END;
/
BEGIN
  order_package.create_new_order(2,'CASH',1);
END;
/
BEGIN
  order_package.global_quantity := 10;
  order_package.global_inv_id := 2;
END;
/
BEGIN
  order_package.create_new_order(2,'CASH',1);
END;
/

select INV_QOH from inventory where inv_id = 2;
select * from order_line;




spool of;