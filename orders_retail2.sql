-- 7. Write a query to display carton id, (len*width*height) as carton_vol 
-- and identify the optimum carton (carton with the least volume 
-- whose volume is greater than the total volume of all items (len * width * height * product_quantity)) 
-- for a given order whose order id is 10006, 

-- Assume all items of an order are packed into one single carton (box). 

select 	carton_id,
		c.len*c.width*c.height as carton_vol
from 
		carton c
where
		(c.len*c.width*c.height) >= 
				(select sum(p.len*p.width*p.height*oi.product_quantity) TOTAL_PROD_VOL
				from product p
				inner join order_items oi
				on p.product_id=oi.product_id
				where order_id=10006)
order by
		carton_vol asc limit 1;
		
-- =================================================================================

-- 8. Write a query to display details (customer id,customer fullname,order id,product
-- quantity) of customers who bought more than ten (i.e. total order qty) products per shipped
-- order.

select	oc.customer_id,
		concat(oc.customer_fname, ' ', oc.customer_lname) customer_fullname,
        oi.order_id,
        sum(product_quantity) as total_prod_qty
from
		online_customer oc
inner join
		order_header oh
        on oc.customer_id=oh.customer_id
inner join
		order_items oi
        on oh.order_id=oi.order_id
where
        oh.order_status like '%Ship%'
group by 
		oi.order_id
having
		sum(oi.product_quantity) > 10
order by
		total_prod_qty;

-- =================================================================================
        
-- 9. Write a query to display the order_id, customer id and cutomer full name of customers 
-- along with (product_quantity) as total quantity of products shipped for order ids > 10060.

select 	oi.order_id,
		oc.customer_id,
		concat(oc.customer_fname, ' ', oc.customer_lname) customer_fullname,
        sum(product_quantity) as total_qty_of_products
from 
		online_customer oc
inner join
		order_header oh
        on oc.customer_id=oh.customer_id
inner join
		order_items oi
        on oh.order_id=oi.order_id
where
		oh.order_status like '%Ship%'
group by
		oh.order_id
having
		oh.order_id > 10060;
        
-- =================================================================================

-- 10. Write a query to display product class description ,total quantity
-- (sum(product_quantity),Total value (product_quantity * product price) and show which class
-- of products have been shipped highest(Quantity) to countries outside India other than USA?
-- Also show the total value of those items

select 	pc.product_class_desc,
		sum(oi.product_quantity) total_prod_qty,
        sum(oi.product_quantity * p.product_price) as total_value
from
		product_class pc
inner join
		product p
		on pc.product_class_code=p.product_class_code
inner join
		order_items oi
        on p.product_id=oi.product_id
inner join
		order_header oh
        on oi.order_id=oh.order_id
inner join
		online_customer oc
        on oh.customer_id=oc.customer_id
inner join
		address a
        on oc.address_id=a.address_id
where
		oh.order_status like '%Ship%'
        and
        a.country not in ('India', 'USA')
group by
		pc.product_class_desc
order by
		total_prod_qty desc limit 1;

-- --------------- END OF PROJECT BY CHETAN DUDHANE ---------------
        
        
