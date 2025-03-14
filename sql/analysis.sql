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





