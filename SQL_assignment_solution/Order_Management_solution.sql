-- 1. Write a query to Display the product details (product_class_code, product_id, product_desc, product_price,) as per the following criteria and sort them in descending order of category: a. If the category is 2050, increase the price by 2000 b. If the category is 2051, increase the price by 500 c. If the category is 2052, increase the price by 600. Hint: Use case statement. no permanent change in table required. (60 ROWS) [NOTE: PRODUCT TABLE]
SELECT  product_class_code, product_id, product_desc,
    product_price,
   CASE
        WHEN product_class_code = 2050 THEN product_price + 2000
        WHEN product_class_code = 2051 THEN product_price + 500
        WHEN product_class_code = 2052 THEN product_price + 600
        ELSE product_price
        END AS adjusted_price
        FROM
        PRODUCT
        ORDER BY
        product_class_code DESC;
     
       
-- 2. Write a query to display (product_class_desc, product_id, product_desc, product_quantity_avail ) and Show inventory status of products as below as per their available quantity: a. For Electronics and Computer categories, if available quantity is <= 10, show 'Low stock', 11 <= qty <= 30, show 'In stock', >= 31, show 'Enough stock' b. For Stationery and Clothes categories, if qty <= 20, show 'Low stock', 21 <= qty <= 80, show 'In stock', >= 81, show 'Enough stock' c. Rest of the categories, if qty <= 15 – 'Low Stock', 16 <= qty <= 50 – 'In Stock', >= 51 – 'Enough stock' For all categories, if available quantity is 0, show 'Out of stock'. Hint: Use case statement. (60 ROWS) [NOTE: TABLES TO BE USED – product, product_class]

 SELECT product_class.product_class_desc,
    product_class.product_class_code,
    product.product_id,
    product.product_desc,
    product.product_quantity_avail,
            CASE
            WHEN product_class.product_class_desc IN ('Electronics', 'Computer') THEN
            CASE
                WHEN product.product_quantity_avail=0 THEN 'Out of stock'
                WHEN product.product_quantity_avail BETWEEN 1 AND 10 THEN 'Low stock'
                WHEN product.product_quantity_avail BETWEEN 11 AND 30 THEN 'In stock'
                ELSE 'Enough stock'
            END
           WHEN product_class.product_class_desc IN ('Stationery', 'Clothes') THEN
            CASE
                WHEN product.product_quantity_avail=0 THEN 'Out of stock'
                WHEN product.product_quantity_avail BETWEEN 1 AND 20 THEN 'Low stock'
                WHEN product.product_quantity_avail BETWEEN 21 AND 80 THEN 'In stock'
                ELSE 'Enough stock'
            END
            ELSE
            CASE
                WHEN product.product_quantity_avail=0 THEN 'Out of stock'
                WHEN product.product_quantity_avail BETWEEN 1 AND 15 THEN 'Low stock'
                WHEN product.product_quantity_avail BETWEEN 16 AND 50 THEN 'In stock'
                ELSE 'Enough stock'
            END
           END AS inventory_status
           FROM
           product 
           INNER JOIN product_class ON product.product_class_code = product_class.product_class_code;



-- 3. Write a query to Show the count of cities in all countries other than USA & MALAYSIA, with more than 1 city, in the descending order of CITIES. (2 rows) [NOTE: ADDRESS TABLE, Do not use Distinct]

SELECT COUNT(city) AS city_count,  country
            FROM  ADDRESS
            WHERE  country NOT IN ('USA', 'Malaysia')
            GROUP BY  country
            HAVING  COUNT(city) > 1
            ORDER BY  city_count DESC;

   

-- 4. Write a query to display the customer_id,customer full name ,city,pincode,and order details (order id, product class desc, product desc, subtotal(product_quantity * product_price)) for orders shipped to cities whose pin codes do not have any 0s in them. Sort the output on customer name and subtotal. (52 ROWS) [NOTE: TABLE TO BE USED - online_customer, address, order_header, order_items, product, product_class] (doubt)

SELECT online_customer.customer_id,  online_customer.customer_fname|| online_customer.customer_lname AS full_name, ADDRESS.city, ADDRESS.pincode, ORDER_ITEMS.order_id, PRODUCT_CLASS_DESC, SUM( order_items.product_quantity*  PRODUCT.product_price) AS subtotal 
FROM  online_customer 
JOIN address, order_header, order_items, product, product_class ON online_customer.address_id = address.address_id AND order_header.order_id= order_items.order_id AND product_class.product_class_code= product.product_class_code AND online_customer.customer_id= order_header.customer_id AND product.product_id=order_items.product_id 
WHERE address.pincode NOT LIKE '%0%' AND order_header.order_status='Shipped'
GROUP BY online_customer.customer_id
ORDER BY subtotal, full_name






-- 5. Write a Query to display product id,product description,totalquantity(sum(product quantity) for an item which has been bought maximum no. of times (Quantity Wise) along with product id 201. (USE SUB-QUERY) (1 ROW) [NOTE: ORDER_ITEMS TABLE, PRODUCT TABLE]
 SELECT product.product_id, product.product_desc, SUM(order_items.product_quantity) AS TOTAL_QUANTITY
        FROM product JOIN order_items ON product.product_ID= order_items.product_ID 
        WHERE product.product_id=201 
        GROUP BY product.product_id



-- 6. Write a query to display the customer_id,customer name, email and order details (order id, product desc,product qty, subtotal(product_quantity * product_price)) for all customers even if they have not ordered any item.(225 ROWS) [NOTE: TABLE TO BE USED - online_customer, order_header, order_items, product]

 SELECT online_customer.customer_id, online_customer.customer_fname ||' ' || online_customer.customer_lname     AS customer_full_name,   online_customer.customer_email, order_items.order_id, product.product_desc,    order_items.product_quantity, order_items.product_quantity*product.product_price
       FROM online_customer 
       LEFT JOIN order_header, order_items, product
       ON online_customer.customer_id=order_header.customer_id
       AND order_header.order_id= order_items.order_id AND  product.product_id= order_items.product_id 
 
-- 7. Write a query to display carton id, (len*width*height) as carton_vol and identify the optimum carton (carton with the least volume whose volume is greater than the total volume of all items (len * width * height * product_quantity)) for a given order whose order id is 10006, Assume all items of an order are packed into one single carton (box). (1 ROW) [NOTE: CARTON TABLE]

 SELECT carton_id, carton.len*carton.width*carton.height AS CARTON_VOL 
        FROM carton WHERE CARTON_VOL > (SELECT SUM(product.len*product.width*product.height*order_items.product_quantity)
        FROM product JOIN order_items  ON product.product_id= order_items.product_id WHERE order_items.order_id=10006) 
        ORDER BY CARTON_VOL LIMIT 1




-- 8. Write a query to display details (customer id,customer fullname,order id,product quantity) of customers who bought more than ten (i.e. total order qty) products per shipped order. (11 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items,]
  SELECT oc.customer_id,oc.customer_fname ||' '|| oc.customer_lname AS fullname ,oh.order_id,SUM(oi.product_quantity) AS total_qty 
         FROM online_customer oc JOIN order_header oh ON oc.customer_id = oh.customer_id JOIN order_items oi ON oh.order_id = oi.order_id 
         WHERE  oh.order_status = 'Shipped' GROUP BY oc.customer_id, fullname, oh.order_id HAVING  total_qty > 10
         ORDER BY oc.customer_id,oi.order_id ;




-- 9. Write a query to display the order_id, customer id and customer full name of customers along with (product_quantity) as total quantity of products shipped for order ids > 10060. (6 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items]
    SELECT oc.customer_id,oc.customer_fname ||' '|| oc.customer_lname AS fullname ,oh.order_id,SUM(oi.product_quantity) AS total_qty FROM online_customer oc JOIN order_header oh ON oc.customer_id = oh.customer_id JOIN order_items oi ON oh.order_id = oi.order_id 
    WHERE  oh.order_status = 'Shipped' GROUP BY oc.customer_id, fullname, oh.order_id HAVING  oi.order_id > 10060
     



-- 10. Write a query to display product class description ,total quantity (sum(product_quantity),Total value (product_quantity * product price) and show which class of products have been shipped highest(Quantity) to countries outside India other than USA? Also show the total value of those items. (1 ROWS)[NOTE:PRODUCT TABLE,ADDRESS TABLE,ONLINE_CUSTOMER TABLE,ORDER_HEADER TABLE,ORDER_ITEMS TABLE,PRODUCT_CLASS TABLE]

SELECT
    product_class.product_class_desc,
    SUM(order_items.product_quantity) AS total_quantity,
    SUM(order_items.product_quantity*product.product_price) AS total_value,
    address.country
FROM product
    JOIN product_class, order_header, online_customer, order_items, address ON product.product_class_code = product_class.product_class_code AND product.product_id = order_items.product_id AND  order_header.order_id = order_items.order_id AND online_customer.customer_id = order_header.customer_id AND online_customer.address_id = address.address_id 
    WHERE
    address.country NOT IN ('USA', 'India') AND order_header.order_status='Shipped'
  GROUP BY
    product_class.product_class_desc,
    address.country 
ORDER BY total_quantity DESC
LIMIT 1


       




