-- Step 1: Create the Database
CREATE DATABASE SupermartDB;
USE SupermartDB;

-- Step 2: Create Customers Table
CREATE TABLE Customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(50),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(20),
    registration_date DATE,
    loyalty_score DECIMAL(5,2)
);

-- Step 3: Create Products Table
CREATE TABLE Products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(100),
    price DECIMAL(10,2),
    brand VARCHAR(100),
    supplier VARCHAR(255)
);

-- Step 4: Create Stock Table (for handling stock details separately)
CREATE TABLE Stock (
    stock_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(50),
    stock_quantity INT,
    discount DECIMAL(5,2),
    rating DECIMAL(3,1),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Step 5: Create Payment Methods Table
CREATE TABLE PaymentMethods (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_method VARCHAR(50) UNIQUE
);

-- Step 6: Create Shipping Status Table
CREATE TABLE ShippingStatus (
    shipping_id INT AUTO_INCREMENT PRIMARY KEY,
    shipping_status VARCHAR(50) UNIQUE
);

-- Step 7: Create Sales Table
CREATE TABLE Sales (
    transaction_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    customer_id VARCHAR(50),
    product_id VARCHAR(50),
    quantity INT,
    total_amount DECIMAL(10,2),
    payment_id INT,
    shipping_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (payment_id) REFERENCES PaymentMethods(payment_id),
    FOREIGN KEY (shipping_id) REFERENCES ShippingStatus(shipping_id)
);
show tables from SupermartDB;
USE SupermartDB;

-- Load Customers Data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customers_Supermart.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from Customers;
select * from products;

USE SupermartDB;

-- Step 1: Create Staging Table for Products
CREATE TABLE IF NOT EXISTS Staging_Products (
    product_id VARCHAR(50),
    product_name VARCHAR(255),
    category VARCHAR(100),
    price DECIMAL(10,2),
    stock_quantity INT,
    brand VARCHAR(100),
    supplier VARCHAR(255),
    rating DECIMAL(3,1),
    discount DECIMAL(5,2)
);

-- Step 2: Load Raw Data into Staging Table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Products_Supermart.csv'
INTO TABLE Staging_Products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


USE SupermartDB;

-- Step 1: Create Staging Table for Sales
CREATE TABLE IF NOT EXISTS Staging_Sales (
    transaction_id VARCHAR(50),
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    customer_id VARCHAR(50),
    product_id VARCHAR(50),
    quantity INT,
    total_amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    shipping_status VARCHAR(50)
);

-- Step 2: Load Raw Data into Staging Sales Table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Sales_Supermart.csv'
INTO TABLE Staging_Sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

USE SupermartDB;

-- Step 3: Insert Distinct Payment Methods into PaymentMethods Table
INSERT INTO PaymentMethods (payment_method)
SELECT DISTINCT payment_method FROM Staging_Sales
WHERE payment_method IS NOT NULL;

-- Step 4: Insert Distinct Shipping Statuses into ShippingStatus Table
INSERT INTO ShippingStatus (shipping_status)
SELECT DISTINCT shipping_status FROM Staging_Sales
WHERE shipping_status IS NOT NULL;

-- Step 5: Insert Cleaned Data into Sales Table
INSERT INTO Sales (transaction_id, order_id, order_date, ship_date, customer_id, product_id, quantity, total_amount, payment_id, shipping_id)
SELECT 
    transaction_id,
    order_id,
    order_date,
    ship_date,
    customer_id,
    product_id,
    quantity,
    total_amount,
    (SELECT payment_id FROM PaymentMethods WHERE payment_method = Staging_Sales.payment_method LIMIT 1),
    (SELECT shipping_id FROM ShippingStatus WHERE shipping_status = Staging_Sales.shipping_status LIMIT 1)
FROM Staging_Sales;


USE SupermartDB;

-- List all tables containing the word 'staging'
SHOW TABLES LIKE 'Staging_%';

SELECT 'Staging_Products' AS TableName, COUNT(*) AS TotalRows FROM Staging_Products
UNION ALL
SELECT 'Staging_Sales', COUNT(*) FROM Staging_Sales;

-- Checking if data has been properly transferred
SELECT * FROM customers;
SELECT count(*) FROM Products;  -- Should be 500
SELECT * FROM Sales;  -- Should match expected number of sales
SELECT * FROM PaymentMethods; -- Should have distinct payment methods
SELECT * FROM ShippingStatus; -- Should have distinct shipping statuses
SELECT * FROM Staging_Products;
SELECT * FROM Staging_Sales;

INSERT INTO Products (product_id, product_name, category, price, brand, supplier)
SELECT product_id, product_name, category, price, brand, supplier
FROM Staging_Products;

-- ETL Process
USE SupermartDB;

USE SupermartDB;

-- Extract Customers Data
SELECT * FROM Customers;

-- Extract Products Data
SELECT * FROM Products;

-- Extract Sales Data
SELECT * FROM Sales;

-- Extract Payment Methods
SELECT * FROM PaymentMethods;

-- Extract Shipping Status
SELECT * FROM ShippingStatus;
-- Create a new database for the ETL process
CREATE DATABASE SupermartDW;
USE SupermartDW;

-- Staging Table for Customers
CREATE TABLE Staging_Customers (
    customer_id VARCHAR(50),
    name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(20),
    registration_date DATE,
    loyalty_score DECIMAL(5,2)
);

-- Staging Table for Products
CREATE TABLE Staging_Products (
    product_id VARCHAR(50),
    product_name VARCHAR(255),
    category VARCHAR(100),
    price DECIMAL(10,2),
    brand VARCHAR(100),
    supplier VARCHAR(255)
);

-- Staging Table for Sales
CREATE TABLE Staging_Sales (
    transaction_id VARCHAR(50),
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    customer_id VARCHAR(50),
    product_id VARCHAR(50),
    quantity INT,
    total_amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    shipping_status VARCHAR(50)
);

-- Staging Table for Payment Methods
CREATE TABLE Staging_PaymentMethods (
    payment_method VARCHAR(50)
);

-- Staging Table for Shipping Status
CREATE TABLE Staging_ShippingStatus (
    shipping_status VARCHAR(50)
);

-- loading table
USE SupermartDW;

-- Load Customers Data
INSERT INTO Staging_Customers
SELECT * FROM SupermartDB.Customers;

-- Load Products Data
INSERT INTO Staging_Products
SELECT * FROM SupermartDB.Products;

-- Load Sales Data
INSERT INTO Staging_Sales
SELECT S.transaction_id, S.order_id, S.order_date, S.ship_date, S.customer_id, S.product_id, 
       S.quantity, S.total_amount, P.payment_method, SH.shipping_status
FROM SupermartDB.Sales S
JOIN SupermartDB.PaymentMethods P ON S.payment_id = P.payment_id
JOIN SupermartDB.ShippingStatus SH ON S.shipping_id = SH.shipping_id;

-- Load Payment Methods Data
INSERT INTO Staging_PaymentMethods
SELECT DISTINCT payment_method FROM SupermartDB.PaymentMethods;

-- Load Shipping Status Data
INSERT INTO Staging_ShippingStatus
SELECT DISTINCT shipping_status FROM SupermartDB.ShippingStatus;

USE SupermartDW;

-- Check if data is loaded into Staging_Customers
SELECT COUNT(*) AS Total_Customers FROM Staging_Customers;

-- Check if data is loaded into Staging_Products
SELECT COUNT(*) AS Total_Products FROM Staging_Products;


SELECT COUNT(*) AS Total_Customers FROM SupermartDB.Customers;

USE SupermartDW;

INSERT INTO Staging_Customers
SELECT * FROM SupermartDB.Customers;

DESC SupermartDB.Customers;
DESC SupermartDW.Staging_Customers;

USE SupermartDW;

INSERT INTO Staging_Customers (customer_id, name, email, phone, city, state, zip_code, registration_date, loyalty_score)
SELECT customer_id, name, email, phone, city, state, zip_code, registration_date, loyalty_score 
FROM SupermartDB.Customers;

SELECT COUNT(*) AS Total_Customers FROM Staging_Customers;

-- View sample data from Staging_Customers
SELECT * FROM Staging_Customers LIMIT 5;

-- View sample data from Staging_Products
SELECT * FROM Staging_Products LIMIT 5;

-- View sample data from Staging_Sales
SELECT * FROM Staging_Sales LIMIT 5;

-- View sample data from Staging_PaymentMethods
SELECT * FROM Staging_PaymentMethods LIMIT 5;

-- View sample data from Staging_ShippingStatus
SELECT * FROM Staging_ShippingStatus LIMIT 5;


SELECT COUNT(*) AS Total_Products FROM SupermartDB.Products;

DESC SupermartDB.Products;
DESC SupermartDW.Staging_Products;

USE SupermartDW;

INSERT INTO Staging_Products (product_id, product_name, category, price, brand, supplier)
SELECT product_id, product_name, category, price, brand, supplier
FROM SupermartDB.Products;

SELECT 'Customers' AS TableName, COUNT(*) AS TotalRows FROM SupermartDW.Staging_Customers
UNION ALL
SELECT 'Products', COUNT(*) FROM SupermartDW.Staging_Products
UNION ALL
SELECT 'Sales', COUNT(*) FROM SupermartDW.Staging_Sales
UNION ALL
SELECT 'PaymentMethods', COUNT(*) FROM SupermartDW.Staging_PaymentMethods
UNION ALL
SELECT 'ShippingStatus', COUNT(*) FROM SupermartDW.Staging_ShippingStatus;
USE SupermartDW;

CREATE TABLE SupermartDW.dim_customers (
    customer_sk INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(20),
    registration_date DATE,
    loyalty_score DECIMAL(5,2),
    effective_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expiration_date TIMESTAMP NULL DEFAULT NULL,
    is_active BOOLEAN DEFAULT TRUE
);


CREATE TABLE SupermartDW.dim_products (
    product_sk INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(50) UNIQUE NOT NULL,
    product_name VARCHAR(255),
    category VARCHAR(100),
    price DECIMAL(10,2),
    brand VARCHAR(100),
    supplier VARCHAR(255)
);

CREATE TABLE SupermartDW.dim_payment_methods (
    payment_sk INT AUTO_INCREMENT PRIMARY KEY,
    payment_method VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE SupermartDW.dim_shipping_status (
    shipping_sk INT AUTO_INCREMENT PRIMARY KEY,
    shipping_status VARCHAR(100) UNIQUE NOT NULL
);

show tables from SupermartDW;



-- creating facts table
CREATE TABLE SupermartDW.fact_sales (
    transaction_sk INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id VARCHAR(50) UNIQUE NOT NULL,
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    customer_sk INT,
    product_sk INT,
    quantity INT,
    total_amount DECIMAL(10,2),
    payment_sk INT,
    shipping_sk INT,
    FOREIGN KEY (customer_sk) REFERENCES dim_customers(customer_sk),
    FOREIGN KEY (product_sk) REFERENCES dim_products(product_sk),
    FOREIGN KEY (payment_sk) REFERENCES dim_payment_methods(payment_sk),
    FOREIGN KEY (shipping_sk) REFERENCES dim_shipping_status(shipping_sk)
);

INSERT INTO SupermartDW.dim_customers (
    customer_id, name, email, phone, city, state, zip_code, registration_date, loyalty_score
)
SELECT customer_id, name, email, phone, city, state, zip_code, registration_date, loyalty_score
FROM SupermartDW.Staging_Customers;

INSERT INTO SupermartDW.dim_products (
    product_id, product_name, category, price, brand, supplier
)
SELECT product_id, product_name, category, price, brand, supplier
FROM SupermartDW.Staging_Products;

INSERT INTO SupermartDW.dim_payment_methods (payment_method)
SELECT DISTINCT payment_method FROM SupermartDW.Staging_PaymentMethods;

INSERT INTO SupermartDW.dim_shipping_status (shipping_status)
SELECT DISTINCT shipping_status FROM SupermartDW.Staging_ShippingStatus;

INSERT INTO SupermartDW.fact_sales (
    transaction_id, order_id, order_date, ship_date, customer_sk, product_sk, quantity, total_amount, payment_sk, shipping_sk
)
SELECT 
    S.transaction_id,
    S.order_id,
    S.order_date,
    S.ship_date,
    C.customer_sk,
    P.product_sk,
    S.quantity,
    S.total_amount,
    PM.payment_sk,
    SH.shipping_sk
FROM SupermartDW.Staging_Sales S
JOIN SupermartDW.dim_customers C ON S.customer_id = C.customer_id
JOIN SupermartDW.dim_products P ON S.product_id = P.product_id
JOIN SupermartDW.dim_payment_methods PM ON S.payment_method = PM.payment_method
JOIN SupermartDW.dim_shipping_status SH ON S.shipping_status = SH.shipping_status;

SELECT COUNT(*) FROM SupermartDW.dim_customers;
SELECT COUNT(*) FROM SupermartDW.dim_products;
SELECT COUNT(*) FROM SupermartDW.dim_payment_methods;
SELECT COUNT(*) FROM SupermartDW.dim_shipping_status;
SELECT COUNT(*) FROM SupermartDW.fact_sales;

SELECT * FROM SupermartDW.fact_sales LIMIT 5;



-- Verification for ETL

SELECT customer_id, COUNT(*)
FROM SupermartDW.Dim_Customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT *
FROM SupermartDW.Fact_Sales
WHERE total_amount < 0;

USE SupermartDW;

-- 1. Total Sales per Customer
SELECT 
    C.name AS customer_name,  -- Customer name from the dimension table
    SUM(F.total_amount) AS total_spent  -- Total amount spent by the customer
FROM SupermartDW.fact_sales F
-- Joining with dim_customers to get customer details
JOIN SupermartDW.dim_customers C ON F.customer_sk = C.customer_sk
-- Grouping results by customer name to calculate total spending per customer
GROUP BY C.name
-- Sorting the results in descending order to show the highest spenders first
ORDER BY total_spent DESC;

-- 2.Top-Selling Products
-- Selecting product name and total quantity sold
SELECT 
    P.product_name,  -- Product name from the dimension table
    SUM(F.quantity) AS total_quantity_sold  -- Summing up total quantity sold per product
FROM SupermartDW.fact_sales F
-- Joining with dim_products to get product details
JOIN SupermartDW.dim_products P ON F.product_sk = P.product_sk
-- Grouping results by product name to calculate total quantity sold per product
GROUP BY P.product_name
-- Sorting results in descending order to show the most sold products first
ORDER BY total_quantity_sold DESC;

-- 3.Monthly sales trends
-- Formatting order_date to extract Year-Month for monthly sales analysis
SELECT 
    DATE_FORMAT(F.order_date, '%Y-%m') AS sales_month,  -- Extracting year and month from order_date
    SUM(F.total_amount) AS total_revenue  -- Calculating total revenue for each month
FROM SupermartDW.fact_sales F
-- Grouping results by formatted order_date to get revenue per month
GROUP BY sales_month
-- Sorting results in ascending order to show chronological sales trends
ORDER BY sales_month;

-- 4.Most preffered payment methods
-- Selecting payment method, number of transactions, and total revenue
SELECT 
    PM.payment_method,  -- Payment method name
    COUNT(F.transaction_id) AS transaction_count,  -- Counting the number of transactions for each method
    SUM(F.total_amount) AS total_revenue  -- Total revenue generated using each payment method
FROM SupermartDW.fact_sales F
-- Joining with dim_payment_methods to get payment method details
JOIN SupermartDW.dim_payment_methods PM ON F.payment_sk = PM.payment_sk
-- Grouping results by payment method to calculate total usage and revenue per method
GROUP BY PM.payment_method
-- Sorting by total revenue in descending order to show the most profitable payment methods first
ORDER BY total_revenue DESC;


-- 5. complex query - customer purchase behabior
-- Selecting customer name, product category, number of purchases, and total spending
SELECT 
    C.name AS customer_name,  -- Customer name from the dimension table
    P.category AS product_category,  -- Product category from the dimension table
    COUNT(F.transaction_id) AS total_purchases,  -- Counting total purchases per customer per category
    SUM(F.total_amount) AS total_spent  -- Calculating total spending per customer per category
FROM SupermartDW.fact_sales F
-- Joining with dim_customers to get customer details
JOIN SupermartDW.dim_customers C ON F.customer_sk = C.customer_sk
-- Joining with dim_products to get product category details
JOIN SupermartDW.dim_products P ON F.product_sk = P.product_sk
-- Grouping results by customer name and product category to get detailed purchase behavior
GROUP BY C.name, P.category
-- Sorting by total spent and total purchases in descending order to show the most engaged customers first
ORDER BY total_spent DESC, total_purchases DESC;





