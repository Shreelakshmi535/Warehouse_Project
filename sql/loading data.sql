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
