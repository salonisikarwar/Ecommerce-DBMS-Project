-- Step 1: Create the database (if it doesn't exist)
DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db;

-- Step 2: Select the database to use for all subsequent commands
USE ecommerce_db;

-- Step 3: Create all the tables

-- Table: Customer
CREATE TABLE Customer (
    cust_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address VARCHAR(255) NOT NULL,
    ph_no VARCHAR(15) UNIQUE NOT NULL,
    pin_code VARCHAR(10) NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Table: Seller
CREATE TABLE Seller (
    seller_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    ph_no VARCHAR(15) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Table: Category
CREATE TABLE Category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Table: Product
CREATE TABLE Product (
    prod_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    category_id INT,
    seller_id INT,
    stock INT NOT NULL CHECK (stock >= 0),
    rating DECIMAL(2, 1) CHECK (rating >= 0 AND rating <= 5),
    FOREIGN KEY (category_id) REFERENCES Category(category_id),
    FOREIGN KEY (seller_id) REFERENCES Seller(seller_id)
);

-- Table: Orders
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    cust_id INT,
    order_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    total_amt DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    status VARCHAR(50) NOT NULL DEFAULT 'Pending',
    pin_code VARCHAR(10) NOT NULL,
    FOREIGN KEY (cust_id) REFERENCES Customer(cust_id)
);

-- Table: Order_items
CREATE TABLE Order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    prod_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (prod_id) REFERENCES Product(prod_id)
);

-- Table: Cart
CREATE TABLE Cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    cust_id INT,
    prod_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    UNIQUE(cust_id, prod_id),
    FOREIGN KEY (cust_id) REFERENCES Customer(cust_id),
    FOREIGN KEY (prod_id) REFERENCES Product(prod_id)
);

-- Table: Payment
CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    cust_id INT,
    mode VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (cust_id) REFERENCES Customer(cust_id)
);

-- Table: Review
CREATE TABLE Review (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    prod_id INT,
    cust_id INT,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    UNIQUE(prod_id, cust_id),
    FOREIGN KEY (prod_id) REFERENCES Product(prod_id),
    FOREIGN KEY (cust_id) REFERENCES Customer(cust_id)
);

-- Table: Wishlist
CREATE TABLE Wishlist (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    cust_id INT,
    prod_id INT,
    UNIQUE(cust_id, prod_id),
    FOREIGN KEY (cust_id) REFERENCES Customer(cust_id),
    FOREIGN KEY (prod_id) REFERENCES Product(prod_id)
);
