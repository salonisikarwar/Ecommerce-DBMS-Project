E-commerce Database Management System Project
This project involves the design, implementation, and querying of a comprehensive database for a modern e-commerce platform. The goal is to create a robust and scalable backend system that can handle customers, sellers, products, orders, and more, ensuring data integrity and efficient data retrieval.

Table of Contents
Project Description

Functional Requirements

Database Design

Conceptual ER Diagram

Physical EER Diagram (Schema)

Technology Stack

Getting Started

SQL Scripts Overview

Usage and Sample Queries

Project Description
In the modern era of online shopping, every seller aims to transition from an offline to an online model for rampant growth. This project eases that transition by providing a foundational database system for small sellers to manage their products online. The prime objective is to design a robust e-commerce database that supports operations such as viewing and placing orders, updating inventory, reviewing products, and maintaining data consistency.

Functional Requirements
Customers can manage their accounts, search for products by category, manage their wishlist and cart, choose payment methods, track order status, and review purchased products.

Sellers can update product stock, track total sales, and analyze sales performance by day, month, or year.

System must ensure data privacy (no access between customer and seller data), maintain data consistency, and prevent data loss.

Database Design
The database was designed in two phases: a high-level conceptual model to capture business rules, and a physical model for the final implementation in MySQL.

Conceptual ER Diagram
This diagram outlines the high-level entities, their attributes (including composite, multivalued, and derived attributes), and the relationships between them. It served as the initial blueprint for the project.

Physical EER Diagram (Schema)
This is the final schema as implemented in the MySQL database. It was generated using the Reverse Engineering feature in MySQL Workbench and shows the actual tables, columns, data types, and foreign key relationships.

Technology Stack
Database: MySQL Server 8.0

IDE: MySQL Workbench

Language: SQL (Structured Query Language)

Getting Started
To set up this project locally, follow these steps:

Prerequisites:

MySQL Server installed.

MySQL Workbench (or any other SQL client) installed.

Setup:

Clone this repository to your local machine.

Open your SQL client and connect to your MySQL server.

Run the SQL scripts from the sql_scripts/ directory in the following order:

1_Complete_Setup_MySQL.sql - This will create the ecommerce_db database and all its tables.

2_Sample_Data_MySQL.sql - This will populate the tables with sample data.

3_Advanced_Features_MySQL.sql - This will create the stored procedures, views, and triggers.

4_Queries_MySQL.sql - This file contains all the sample queries to test the database functionality.

SQL Scripts Overview
1_Complete_Setup_MySQL.sql: Contains all CREATE TABLE statements to build the database schema from scratch.

2_Sample_Data_MySQL.sql: Contains INSERT statements to populate the database with realistic sample data.

3_Advanced_Features_MySQL.sql: Contains advanced logic, including triggers for automating stock and total amount updates, stored procedures for common tasks (like fetching order history), and views for complex reporting (like sales by category).

4_Queries_MySQL.sql: A collection of 13 queries designed to test and demonstrate the capabilities of the database.

Usage and Sample Queries
You can use the queries in 4_Queries_MySQL.sql to interact with the database. Here are a few examples:

1. Find the top-rated products in the 'Electronics' category:

SELECT name, price, rating, description FROM Product WHERE category_id = 1 -- Assuming 1 is the ID for Electronics ORDER BY rating DESC LIMIT 5; 

2. Get the total value of items in a specific customer's cart:

SELECT
    c.cust_id,
    SUM(p.price * c.quantity) AS total_cart_value
FROM Cart c
JOIN Product p ON c.prod_id = p.prod_id
WHERE c.cust_id = 3
GROUP BY c.cust_id;

3. Use a stored procedure to get a customer's order history:

CALL get_order_history(1); -- Get order history for customer with ID 1

4. Check the view for total sales by product category:

SELECT * FROM sales_by_category;
