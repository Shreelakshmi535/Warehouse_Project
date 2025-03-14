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