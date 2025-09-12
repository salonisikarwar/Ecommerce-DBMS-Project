-- Ensure the correct database is being used
USE ecommerce_db;

-- Inserting sample data into the tables

-- Customers (passwords are now example bcrypt hashes)
INSERT INTO Customer (name, email, address, ph_no, pin_code, password) VALUES
('Saurabh Kumar', 'saurabh.k@example.com', '123 Tech Avenue, Bangalore', '9876543210', '560001', '$2a$12$E/l4M9C3A3a.PTbX.2a3b.5c6d7e8f9g0h1i2j3k4l5m6n7o8'),
('Jane Smith', 'jane.smith@example.com', '456 Market St, Mumbai', '8765432109', '400001', '$2a$12$F/m5N0D4B4b.QUcY.3b4c.6d7e8f9g0h1i2j3k4l5m6n7o8p'),
('Amit Patel', 'amit.patel@example.com', '789 Ganga Road, Delhi', '7654321098', '110001', '$2a$12$G/n6O1E5C5c.RVdZ.4c5d.7e8f9g0h1i2j3k4l5m6n7o8p9');

-- Sellers (passwords are now example bcrypt hashes)
INSERT INTO Seller (name, email, ph_no, password) VALUES
('ElectroHub', 'contact@electrohub.com', '6543210987', '$2a$12$H/o7P2F6D6d.SWae.5d6e.8f9g0h1i2j3k4l5m6n7o8p9q'),
('FashionFiesta', 'support@fashion.com', '5432109876', '$2a$12$I/p8Q3G7E7e.TXbf.6e7f.9g0h1i2j3k4l5m6n7o8p9q0'),
('BookNook', 'info@booknook.com', '4321098765', '$2a$12$J/q9R4H8F8f.UYcg.7f8g.0h1i2j3k4l5m6n7o8p9q0r');

-- Categories
INSERT INTO Category (name) VALUES
('Electronics'),
('Apparel'),
('Books');

-- Products
INSERT INTO Product (name, description, price, category_id, seller_id, stock, rating) VALUES
('Smartwatch Series 8', 'Latest model with advanced health tracking', 25000.00, 1, 1, 50, 4.8),
('Wireless Earbuds Pro', 'Noise-cancelling with 24-hour battery life', 8000.00, 1, 1, 150, 4.6),
('Men''s Denim Jacket', 'Classic blue denim jacket, all sizes available', 2500.00, 2, 2, 100, 4.5),
('Women''s Cotton T-shirt', 'Comfortable and stylish plain white t-shirt', 800.00, 2, 2, 200, 4.7),
('The Alchemist', 'A classic novel by Paulo Coelho', 350.00, 3, 3, 300, 4.9),
('DBMS Fundamentals', 'Comprehensive guide to Database Management Systems', 750.00, 3, 3, 80, 4.4);

-- Orders
-- Note: total_amt will be updated by a trigger after items are added.
INSERT INTO Orders (cust_id, order_date, status, pin_code) VALUES
(1, '2025-09-01', 'Delivered', '560001'),
(2, '2025-09-03', 'Shipped', '400001'),
(1, '2025-09-05', 'Pending', '560001');

-- Order_items
-- Order 1 items
INSERT INTO Order_items (order_id, prod_id, quantity, price) VALUES
(1, 1, 1, 25000.00), -- Smartwatch
(1, 5, 1, 350.00);   -- The Alchemist
-- Order 2 items
INSERT INTO Order_items (order_id, prod_id, quantity, price) VALUES
(2, 3, 1, 2500.00);   -- Denim Jacket
-- Order 3 items
INSERT INTO Order_items (order_id, prod_id, quantity, price) VALUES
(3, 2, 2, 8000.00);   -- 2 Wireless Earbuds

-- Carts
INSERT INTO Cart (cust_id, prod_id, quantity) VALUES
(3, 4, 2), -- Amit's cart: 2 Cotton T-shirts
(3, 6, 1); -- Amit's cart: 1 DBMS book

-- Payments
INSERT INTO Payment (order_id, cust_id, mode, status) VALUES
(1, 1, 'Credit Card', 'Completed'),
(2, 2, 'CoD', 'Pending'); -- CoD payment is pending until delivery

-- Reviews
INSERT INTO Review (prod_id, cust_id, rating, comment) VALUES
(1, 1, 5, 'Excellent product! The health tracking is very accurate.'),
(5, 1, 5, 'A life-changing book. Must read!'),
(3, 2, 4, 'Good quality jacket, but the size was a bit off.');

-- Wishlists
INSERT INTO Wishlist (cust_id, prod_id) VALUES
(1, 3), -- Saurabh wants the Denim Jacket
(2, 1); -- Jane wants the Smartwatch
