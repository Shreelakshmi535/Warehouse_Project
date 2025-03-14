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

