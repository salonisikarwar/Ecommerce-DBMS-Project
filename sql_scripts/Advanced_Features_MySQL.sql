-- Ensure the correct database is being used
USE ecommerce_db;

-- Delimiter is changed to $$ to allow semicolons inside procedures and triggers
DELIMITER $$

-- 1. Stored procedure for the details of the customer.
DROP PROCEDURE IF EXISTS get_customer_details$$
CREATE PROCEDURE get_customer_details(IN customer_id INT)
BEGIN
    SELECT name, email, address, ph_no
    FROM Customer
    WHERE cust_id = customer_id;
END$$

-- 2. Stored procedure for getting order history.
DROP PROCEDURE IF EXISTS get_order_history$$
CREATE PROCEDURE get_order_history(IN customer_id INT)
BEGIN
    SELECT o.order_id, o.order_date, o.total_amt, o.status
    FROM Orders o
    WHERE o.cust_id = customer_id
    ORDER BY o.order_date DESC;
END$$

-- 3. Stored procedure for processing an order from a customer's cart
DROP PROCEDURE IF EXISTS process_order_from_cart$$
CREATE PROCEDURE process_order_from_cart(IN customer_id INT, IN customer_pin_code VARCHAR(10))
BEGIN
    -- Declare variables
    DECLARE new_order_id INT;
    DECLARE finished INT DEFAULT 0;
    DECLARE cart_prod_id INT;
    DECLARE cart_quantity INT;
    DECLARE product_price DECIMAL(10, 2);
    DECLARE product_stock INT;

    -- Declare a cursor to iterate through the customer's cart
    DECLARE cart_cursor CURSOR FOR
        SELECT prod_id, quantity FROM Cart WHERE cust_id = customer_id;

    -- Declare a handler for when the cursor finds no more rows
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    -- Start a transaction
    START TRANSACTION;

    -- Create a new order and get its ID
    INSERT INTO Orders (cust_id, pin_code, status)
    VALUES (customer_id, customer_pin_code, 'Pending Payment') ;
    SET new_order_id = LAST_INSERT_ID();

    -- Open the cursor
    OPEN cart_cursor;

    -- Loop through each item in the cart
    cart_loop: LOOP
        FETCH cart_cursor INTO cart_prod_id, cart_quantity;
        IF finished = 1 THEN
            LEAVE cart_loop;
        END IF;

        -- Check for stock and get price. Use FOR UPDATE to lock the row and prevent race conditions.
        SELECT price, stock INTO product_price, product_stock
        FROM Product WHERE prod_id = cart_prod_id FOR UPDATE;

        IF product_stock < cart_quantity THEN
            -- Not enough stock, rollback transaction and signal an error
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not enough stock for a product in the cart.';
        END IF;

        -- Insert into order items
        INSERT INTO Order_items (order_id, prod_id, quantity, price)
        VALUES (new_order_id, cart_prod_id, cart_quantity, product_price);

    END LOOP cart_loop;

    -- Close the cursor
    CLOSE cart_cursor;

    -- Clear the cart for the customer
    DELETE FROM Cart WHERE cust_id = customer_id;

    -- If we reach here, everything is fine, so commit the transaction
    COMMIT;
END$$


-- 4. Trigger to update the no. of products (stock) as soon as the payment is made.
DROP TRIGGER IF EXISTS after_payment_update_stock$$
CREATE TRIGGER after_payment_update_stock
AFTER UPDATE ON Payment
FOR EACH ROW
BEGIN
    IF NEW.status = 'Completed' AND OLD.status <> 'Completed' THEN
        UPDATE Product p
        INNER JOIN Order_items oi ON p.prod_id = oi.prod_id
        SET p.stock = p.stock - oi.quantity
        WHERE oi.order_id = NEW.order_id;
    END IF;
END$$

-- 5. Triggers to keep the order total amount accurate.

-- A) After INSERT on Order_items
DROP TRIGGER IF EXISTS after_order_item_insert$$
CREATE TRIGGER after_order_item_insert
AFTER INSERT ON Order_items
FOR EACH ROW
BEGIN
    UPDATE Orders
    SET total_amt = total_amt + (NEW.quantity * NEW.price)
    WHERE order_id = NEW.order_id;
END$$

-- B) After UPDATE on Order_items (Handles quantity changes)
DROP TRIGGER IF EXISTS after_order_item_update$$
CREATE TRIGGER after_order_item_update
AFTER UPDATE ON Order_items
FOR EACH ROW
BEGIN
    UPDATE Orders
    SET total_amt = total_amt - (OLD.quantity * OLD.price) + (NEW.quantity * NEW.price)
    WHERE order_id = NEW.order_id;
END$$

-- C) After DELETE on Order_items (Handles item removal)
DROP TRIGGER IF EXISTS after_order_item_delete$$
CREATE TRIGGER after_order_item_delete
AFTER DELETE ON Order_items
FOR EACH ROW
BEGIN
    UPDATE Orders
    SET total_amt = total_amt - (OLD.quantity * OLD.price)
    WHERE order_id = OLD.order_id;
END$$


-- Reset the delimiter back to semicolon
DELIMITER ;

-- 6. View for getting sales by category of products.
CREATE OR REPLACE VIEW sales_by_category AS
SELECT
    c.name AS category_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.price) AS total_sales_amount
FROM Order_items oi
JOIN Product p ON oi.prod_id = p.prod_id
JOIN Category c ON p.category_id = c.category_id
GROUP BY c.name
ORDER BY total_sales_amount DESC;
