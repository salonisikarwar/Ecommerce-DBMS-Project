-- Ensure the correct database is being used
USE ecommerce_db;

-- QUERY 1: Customers to find products with the highest ratings for a given category.
SELECT name, price, rating, description
FROM Product
WHERE category_id = 1 AND is_active = TRUE
ORDER BY rating DESC
LIMIT 5;

-- QUERY 2: Customers to filter out the products according to their brand (seller) and price.
SELECT p.name, p.price, p.rating, s.name AS seller_name
FROM Product p
JOIN Seller s ON p.seller_id = s.seller_id
WHERE p.seller_id = 1 AND p.price < 10000.00 AND p.is_active = TRUE
ORDER BY p.price;

-- QUERY 3: If a customer wants to know the total price for all products present in their cart.
SELECT
    c.cust_id,
    SUM(p.price * c.quantity) AS total_cart_value
FROM Cart c
JOIN Product p ON c.prod_id = p.prod_id
WHERE c.cust_id = 3
GROUP BY c.cust_id;

-- QUERY 4: Customers to find the best seller of a particular product.
SELECT s.name as seller_name, p.stock, p.price
FROM Product p
JOIN Seller s ON p.seller_id = s.seller_id
WHERE p.name = 'Wireless Earbuds Pro' AND p.is_active = TRUE
ORDER BY p.stock DESC
LIMIT 1;

-- QUERY 5: List the orders which are to be delivered at a particular pincode.
SELECT o.order_id, c.name AS customer_name, c.address, o.status
FROM Orders o
JOIN Customer c ON o.cust_id = c.cust_id
WHERE o.pin_code = '560001' AND o.status <> 'Delivered';

-- QUERY 6: List the product whose sale is the highest on a particular day.
SELECT
    p.name,
    SUM(oi.quantity) as total_quantity_sold
FROM Order_items oi
JOIN Orders o ON oi.order_id = o.order_id
JOIN Product p ON oi.prod_id = p.prod_id
WHERE o.order_date = '2025-09-01'
GROUP BY p.name
ORDER BY total_quantity_sold DESC
LIMIT 1;

-- QUERY 7: List the category of product which has been sold the highest on a particular day.
SELECT
    cat.name as category_name,
    SUM(oi.quantity) as total_quantity_sold
FROM Order_items oi
JOIN Orders o ON oi.order_id = o.order_id
JOIN Product p ON oi.prod_id = p.prod_id
JOIN Category cat ON p.category_id = cat.category_id
WHERE o.order_date = '2025-09-01'
GROUP BY cat.name
ORDER BY total_quantity_sold DESC
LIMIT 1;

-- QUERY 8: List the customers who bought products from a particular seller the most.
SELECT
    c.name as customer_name,
    COUNT(DISTINCT o.order_id) as number_of_orders
FROM Customer c
JOIN Orders o ON c.cust_id = o.cust_id
JOIN Order_items oi ON o.order_id = oi.order_id
JOIN Product p ON oi.prod_id = p.prod_id
WHERE p.seller_id = 1
GROUP BY c.name
ORDER BY number_of_orders DESC;

-- QUERY 9: List all the orders whose payment mode is not CoD and yet to be delivered.
SELECT o.order_id, c.name as customer_name, o.status
FROM Orders o
JOIN Payment p ON o.order_id = p.order_id
JOIN Customer c ON o.cust_id = c.cust_id
WHERE p.mode <> 'CoD' AND o.status NOT IN ('Delivered', 'Cancelled');

-- QUERY 10: List all orders of customers whose total amount is greater than 5000.
SELECT o.order_id, c.name AS customer_name, o.total_amt
FROM Orders o
JOIN Customer c ON o.cust_id = c.cust_id
WHERE o.total_amt > 5000.00
ORDER BY o.total_amt DESC;

-- QUERY 11: If a customer wants to modify the cart, that is, delete some products from the cart.
DELETE FROM Cart
WHERE cust_id = 3 AND prod_id = 6;

-- QUERY 12: List the seller who has the highest stock of a particular product.
SELECT s.name AS seller_name, p.stock
FROM Product p
JOIN Seller s ON p.seller_id = s.seller_id
WHERE p.prod_id = 1
ORDER BY p.stock DESC
LIMIT 1;

-- QUERY 13: Customers to compare the products based on their ratings and reviews.
SELECT p.name, p.price, p.rating, r.comment, c.name as reviewer
FROM Product p
LEFT JOIN Review r ON p.prod_id = r.prod_id
LEFT JOIN Customer c ON r.cust_id = c.cust_id
WHERE p.prod_id IN (1, 2) AND p.is_active = TRUE
ORDER BY p.name, r.rating DESC;
