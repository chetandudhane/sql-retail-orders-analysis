-- 1. Write a query to Display the product details (product_class_code, product_id, product_desc, 
-- product_price,) as per the following criteria and sort them in descending order of category:
		-- a. If the category is 2050, increase the price by 2000
		-- b. If the category is 2051, increase the price by 500
		-- c. If the category is 2052, increase the price by 600.

SELECT PRODUCT_CLASS_CODE, 
			PRODUCT_ID, 
			PRODUCT_DESC, 
			PRODUCT_PRICE,
			
CASE PRODUCT_CLASS_CODE
		WHEN 2050 
			THEN PRODUCT_PRICE+2000
		WHEN 2051 
			THEN PRODUCT_PRICE+500
		WHEN 2052 
			THEN PRODUCT_PRICE+600
		ELSE 
			PRODUCT_PRICE
END NEW_PRODUCT_PRICE
		
FROM 
	PRODUCT
	
ORDER BY 
	PRODUCT_CLASS_CODE DESC;
	
-- =================================================================================


-- 2. Write a query to display (product_class_desc, product_id, product_desc, product_quantity_avail ) 
-- and Show inventory status of products as below as per their available quantity:
-- 
		-- a. For Electronics and Computer categories, 
		-- if available quantity is <= 10, show 'Low stock', 11 <= qty <= 30, show 'In stock', 
		-- >= 31, show 'Enough stock'
		-- b. For Stationery and Clothes categories, if qty <= 20, show 'Low stock', 
		-- 21 <= qty <= 80, show 'In stock', >= 81, show 'Enough stock'
		-- c. Rest of the categories, if qty <= 15 – 'Low Stock', 16 <= qty <= 50 – 'In Stock', 
		-- >= 51 – 'Enough stock'
		-- For all categories, if available quantity is 0, show 'Out of stock'.


SELECT PRODUCT_CLASS_DESC,
			PRODUCT_ID,
			PRODUCT_DESC,
			PRODUCT_QUANTITY_AVAIL,
CASE 
		-- For Categories of Electronics and Computer --
		WHEN 
			PRODUCT_CLASS_DESC IN ('Electronics', 'Computer') 
			AND 
			PRODUCT_QUANTITY_AVAIL<=10
		THEN
			'Low Stock'
		
		WHEN 
			PRODUCT_CLASS_DESC IN ('Electronics', 'Computer') 
			AND 
			PRODUCT_QUANTITY_AVAIL>= 11
			AND
			PRODUCT_QUANTITY_AVAIL <= 31
		THEN
			'In Stock'
		
		WHEN 
			PRODUCT_CLASS_DESC IN ('Electronics', 'Computer') 
			AND 
			PRODUCT_QUANTITY_AVAIL>= 31
		THEN
			'Enough Stock'
		
		-- For Categories of Clothes and Stationery --
		WHEN 
			PRODUCT_CLASS_DESC IN ('Clothes', 'Stationery') 
			AND 
			PRODUCT_QUANTITY_AVAIL<=20
		THEN
			'Low Stock'
					
		WHEN 
			PRODUCT_CLASS_DESC IN ('Clothes', 'Stationery') 
			AND 
			PRODUCT_QUANTITY_AVAIL>= 21
			AND
			PRODUCT_QUANTITY_AVAIL <=80
		THEN
			'In Stock'
			
		WHEN 
			PRODUCT_CLASS_DESC IN ('Clothes', 'Stationery') 
			AND 
			PRODUCT_QUANTITY_AVAIL>=81
		THEN
			'Enough Stock'
		
		-- For All Rest of the Categories --
		WHEN 
			PRODUCT_CLASS_DESC 
			IN ('Promotion-Medium Value', 'Promotion-Low Value', 'Toys', 'Books', 'Mobiles', 'Watches', 
			'Furnitures', 'Bags', 'Kitchen Items', 'Promotion-High Value') 
			AND 
			PRODUCT_QUANTITY_AVAIL<=15
		THEN
			'Low Stock'
					
		WHEN 
			PRODUCT_CLASS_DESC 
			IN ('Promotion-Medium Value', 'Promotion-Low Value', 'Toys', 'Books', 'Mobiles', 'Watches', 
			'Furnitures', 'Bags', 'Kitchen Items', 'Promotion-High Value') 
			AND 
			PRODUCT_QUANTITY_AVAIL>= 16
			AND
			PRODUCT_QUANTITY_AVAIL <= 50
		THEN
			'In Stock'
			
		WHEN 
			PRODUCT_CLASS_DESC 
			IN ('Promotion-Medium Value', 'Promotion-Low Value', 'Toys', 'Books', 'Mobiles', 'Watches', 
			'Furnitures', 'Bags', 'Kitchen Items', 'Promotion-High Value') 
			AND 
			PRODUCT_QUANTITY_AVAIL >= 51
		THEN
			'Enough Stock'

		-- When Available Quantity is NILL for ALL Categories --
		WHEN
			PRODUCT_QUANTITY_AVAIL = 0
		THEN
			'Out of Stock'
		
END PRESENT_STOCK

FROM
			PRODUCT_CLASS AS PC
INNER JOIN
			PRODUCT AS P
ON
			PC.PRODUCT_CLASS_CODE=P.PRODUCT_CLASS_CODE;
			
-- =================================================================================
			
			
-- 3. Write a query to Show the count of cities in all countries other than USA & MALAYSIA, 
-- with more than 1 city, in the descending order of CITIES.		
			
SELECT COUNTRY, 
			COUNT(CITY) AS NUMBER_OF_CITIES
FROM 
			ADDRESS
WHERE 
			COUNTRY NOT IN ('USA', 'Malaysia')
GROUP BY
			COUNTRY
HAVING
			COUNT(CITY) >= 2
ORDER BY
			COUNT(CITY) DESC;

-- =================================================================================

			
-- 4. Write a query to display the customer_id,customer full name ,city,pincode,and 
-- order details (order id,order date, product class desc, product desc, subtotal(product_quantity * product_price)) 
-- for orders shipped to cities whose pin codes do not have any 0s in them. 
-- 
-- Sort the output on customer name, order date and subtotal.
			
SELECT 
			OC.CUSTOMER_ID, 
			CUSTOMER_FNAME || ' ' || CUSTOMER_LNAME AS FULL_NAME,
			PINCODE,
			CITY,
			OI.ORDER_ID,
			ORDER_DATE,
			PRODUCT_CLASS_DESC,
			PRODUCT_DESC,
-- 			PRODUCT_QUANTITY,
-- 			PRODUCT_PRICE,
			OI.PRODUCT_QUANTITY * P.PRODUCT_PRICE AS SUBTOTAL_AMOUNT
FROM
			ADDRESS AS AD 
INNER JOIN 
			ONLINE_CUSTOMER AS OC 
			ON OC.ADDRESS_ID=AD.ADDRESS_ID
INNER JOIN 
			ORDER_HEADER AS OH 
			ON OH.CUSTOMER_ID=OC.CUSTOMER_ID
INNER JOIN 
			ORDER_ITEMS AS OI 
			ON OH.ORDER_ID=OI.ORDER_ID
INNER JOIN 
			PRODUCT AS P 
			ON OI.PRODUCT_ID=P.PRODUCT_ID
INNER JOIN 
			PRODUCT_CLASS AS PC 
			ON P.PRODUCT_CLASS_CODE=PC.PRODUCT_CLASS_CODE
WHERE
			ORDER_STATUS LIKE '%Ship%'
			AND
			PINCODE NOT LIKE '%0%'
ORDER BY
			FULL_NAME, ORDER_DATE, SUBTOTAL_AMOUNT;

-- =================================================================================

			
-- 5. Write a Query to display product id, product description, totalquantity (sum(product quantity) 
-- for an item which has been bought maximum no. of times along with product id 201.
			

SELECT  
			OI.PRODUCT_ID,  
			PRODUCT_DESC, 
			PRODUCT_QUANTITY 
FROM 
			ORDER_ITEMS AS OI
	INNER JOIN
			PRODUCT AS P
	ON  
			OI.PRODUCT_ID=P.PRODUCT_ID
WHERE
			ORDER_ID IN  
			(SELECT ORDER_ID FROM ORDER_ITEMS WHERE PRODUCT_ID=201)
GROUP BY 
			OI.PRODUCT_ID
ORDER BY 
			OI.PRODUCT_QUANTITY DESC LIMIT 1;
			
-- =================================================================================


-- 6. Write a query to display the customer_id,customer name, email and 
-- order details (order id, product desc,product qty, subtotal(product_quantity * product_price)) 
-- for all customers even if they have not ordered any item.

SELECT OC.CUSTOMER_ID,
			CUSTOMER_FNAME || ' ' || CUSTOMER_LNAME AS CUSTOMER_NAME,
			OC.CUSTOMER_EMAIL,
			OH.ORDER_ID,
			P.PRODUCT_DESC,
			OI.PRODUCT_QUANTITY,
			OI.PRODUCT_QUANTITY * P.PRODUCT_PRICE AS SUBTOTAL_AMOUNT
			
FROM
			ONLINE_CUSTOMER AS OC
LEFT JOIN
			ORDER_HEADER AS OH
			ON OC.CUSTOMER_ID=OH.CUSTOMER_ID
LEFT JOIN
			ORDER_ITEMS AS OI
			ON OH.ORDER_ID=OI.ORDER_ID
LEFT JOIN
			PRODUCT AS P
			ON OI.PRODUCT_ID=P.PRODUCT_ID
ORDER BY
			OC.CUSTOMER_ID ASC;


--------- END OF QUESTION 1 TO 6 OF SQL PROJECT ---------

--------- BY CHETAN DUDHANE ----------




