SPOOL bruno_project_part_4.txt
SELECT TO_CHAR(SYSDATE, 'DD Month Year Day HH:MI:SS Am') from dual;
SET SERVEROUTPUT ON;
-- Question 1:
-- Create a procedure that accepts 3 parameters, the first two are of mode IN with number as 
-- their datatype and the third one is of mode OUT in form of Varchar2. The procedure will 
-- compare the first two numbers and output the result as EQUAL, or DIFFERENT.
-- Create a second procedure called L8Q1 that accepts the two sides of a rectangle. The 
-- procedure will calculate the area and the perimeter of the rectangle. Use the procedure 
-- created previously to display if the shape is a square or a rectangle. The following are the 
-- example on how we execute the procedure and the expected output.
-- SQL > exec L4Q1(2,2)
-- The area of a square size 2 by 2 is 4. It`s perimeter is 8
create or replace procedure compare(p_w number, p_h number, p_flag_out out varchar2) AS
begin
	if p_w = p_h then
		p_flag_out := 'EQUAL';
	else
		p_flag_out := 'DIFFERENT';
	end if;
end;
/
create or replace procedure l4q1(p_w number, p_h number) AS
v_square_or_retangle varchar2(10);
v_area number;
v_perimeter number;
begin
	compare(p_w, p_h, v_square_or_retangle);
	if v_square_or_retangle = 'EQUAL' then
		v_square_or_retangle := 'square';
	else
		v_square_or_retangle := 'rectangle';
	end if;
	v_area := p_h * p_w;
	v_perimeter := (2 * p_h) + (2 * p_w);
	DBMS_OUTPUT.PUT_LINE('The area of a '|| v_square_or_retangle ||' size ' || p_w || ' by ' || p_h || ' is ' || v_area ||'. It`s perimeter is ' || v_perimeter);
end;
/
exec l4q1(2,2);
exec l4q1(2,3);
-- Question 2:
-- Create a pseudo function called pseudo_fun that accepts 2 parameters represented the 
-- height and width of a rectangle. The pseudo function should return the area and the 
-- perimeter of the rectangle.
-- Create a second procedure called L4Q2 that accepts the two sides of a rectangle. The 
-- procedure will use the pseudo function to display the shape, the area and the perimeter.
-- SQL > exec L4Q2(2,2)
-- The area of a square size 2 by 2 is 4. It`s perimeter is 8
create or replace procedure calculate(p_w number, p_h number, p_area out number, p_perimeter out number) AS
begin
	p_area := p_h * p_w;
	p_perimeter := (2 * p_h) + (2 * p_w);
end;
/
create or replace procedure l4q2(p_w number, p_h number) AS
v_square_or_retangle varchar2(10);
v_area number;
v_perimeter number;
begin 
	if p_w = p_h then
		v_square_or_retangle := 'square';
	else
		v_square_or_retangle := 'rectangle';
	end if;
	calculate(p_w,p_h,v_area,v_perimeter);
	DBMS_OUTPUT.PUT_LINE('The area of a '|| v_square_or_retangle ||' size ' || p_w || ' by ' || p_h || ' is ' || v_area 
    ||'. It`s perimeter is ' || v_perimeter);
end;
/
exec l4q2(2,2);
exec l4q2(2,3);


-- Question 3:
-- Create a pseudo function that accepts 2 parameters represented the inv_id, and the 
-- percentage increase in price. The pseudo function should first update the database with 
-- the new price then return the new price and the quantity on hand.
create or replace procedure l4q3_aux(
  p_inv_id number, 
  p_increase_percentage number, 
  p_new_price out number, 
  p_quantity out number) as
begin
  update inventory 
  set inv_price = ROUND(INV_PRICE + ((INV_PRICE *  p_increase_percentage) / 100), 2) 
  where inv_id = p_inv_id; 
  commit;
	select inv_price, inv_qoh into p_new_price, p_quantity from inventory where inv_id = p_inv_id;
end;
/
-- Create a second procedure called L4Q3 that accepts the inv_id and the percentage 
-- increase in price. The procedure will use the pseudo function to display the new value of 
-- the inventory (hint: value = price X quantity on hand)
create or replace procedure l4q3(p_inv_id number, p_increase_percentage number) as
v_new_price number;
v_quantity number;
begin
  l4q3_aux(p_inv_id, p_increase_percentage, v_new_price, v_quantity);
  	DBMS_OUTPUT.PUT_LINE('The the inventory '|| p_inv_id || ', was updated.');
    DBMS_OUTPUT.PUT_LINE('Quantity: '|| v_quantity);
    DBMS_OUTPUT.PUT_LINE('New price: '|| v_new_price);
    DBMS_OUTPUT.PUT_LINE('New value: '|| v_quantity * v_new_price);
    
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('The the inventory '|| p_inv_id || ' does not exist, my friend.');
end;
/
exec l4q3(32,100);
exec l4q3(99999,100);
spool off