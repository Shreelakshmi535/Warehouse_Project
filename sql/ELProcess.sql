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
