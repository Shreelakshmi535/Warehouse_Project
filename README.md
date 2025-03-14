Target Data Warehouse Project – Final Report
1. Project Overview
The Target Data Warehouse Project integrates e-commerce data into a centralized data warehouse for business intelligence and analytics. The project focuses on:
Data Integration: Combining customer, product, and sales data. 
ETL Pipeline: Automating extraction, transformation, and loading (ETL).
Business Insights: Analyzing trends, customer behaviour, and product performance.
Technologies Used
🔹 Database: MySQL (Star Schema)
🔹 ETL Tools: MySQL LOAD DATA INFILE
🔹 Visualization: Excel
🔹 Querying & Analysis: MySQL Workbench

2. Project Structure
The project follows a structured folder organization:
 ![image](https://github.com/user-attachments/assets/d937c5fb-2be6-4cc2-90c3-aa781261ddb3)
![image](https://github.com/user-attachments/assets/379ffbb8-464c-46d0-a7b7-e74698e9a63e)
 
2. Database Schema & ER Diagram
The database follows a Star Schema for optimized analytics.
Schema Overview
•	dim_customers – Customer details.
•	dim_products – Product information.
•	dim_payment_methods – Payment type reference.
•	dim_shipping_status – Shipping status details.
•	fact_sales – Sales transactions (linking all dimensions).
📌 Screenshot: ER Diagram
 ![image](https://github.com/user-attachments/assets/d789d127-3b69-49f8-b734-8b18aafd244e)

Star Schema
![image](https://github.com/user-attachments/assets/6559a985-1fd1-4bdb-b2e7-9f760552077a)
![image](https://github.com/user-attachments/assets/66422d5c-e3ee-4c58-b76a-a6aae8d04e24)

 
 3. ETL Process
The ETL Pipeline is divided into four stages:
1️ Extraction
•	Raw data is loaded from CSV files into staging tables using LOAD DATA INFILE.
2️ Transformation
•	Data is cleaned and validated.
•	Slowly Changing Dimensions (SCD Type 2) is applied for tracking customer updates.
3️ Loading
•	Dimension and fact tables are populated with surrogate keys.
•	Referential integrity is ensured to maintain data consistency.
4️ Data Validation
•	Verification queries ensure no missing values or duplicate records.
 ![image](https://github.com/user-attachments/assets/11066770-190d-4724-9808-cfb769408377)

4. Key Analytical Queries & Business Insights and  Business Insights & Visualization
1️ Most Preferred Payment Methods
![image](https://github.com/user-attachments/assets/a54eda58-284d-4290-923f-67d24a768af6)

2️ Monthly Sales Trends
![image](https://github.com/user-attachments/assets/e35f6d33-7c90-47ca-86a4-e2622e77d070)
 
3️ Top-Selling Products
![image](https://github.com/user-attachments/assets/68b25ca6-627d-4fd3-b4d8-8c86f94d2d09)

4. Customer Purchase Behaviour
![image](https://github.com/user-attachments/assets/90df5a8b-8bdb-4cbb-9b16-4274268d93c1)
 
6. Future Enhancements
🔹 Real-time Data Processing: Implement incremental ETL updates.
🔹 Advanced Analytics: Introduce AI for demand forecasting.
🔹 Geographic Analysis: Sales distribution by region.
🔹 Cloud Deployment: Migrate to a cloud warehouse for scalability.
7. Conclusion
The Target Data Warehouse Project successfully consolidates data for analytics, enabling data-driven decision-making. The insights support better customer engagement, sales forecasting, and marketing strategies.
Future Scope
🔹 Implement Machine Learning (ML) models for sales forecasting and demand prediction.
🔹 Integrate real-time ETL processing to support instant decision-making.
🔹 Enhance personalized marketing strategies through customer segmentation and behavioural analytics.
🔹 Optimize supply chain efficiency by linking sales insights with logistics and supplier data.
By leveraging the structured dimensional model and analytical insights, the business can improve customer engagement, sales performance, and operational efficiency, ensuring a competitive advantage in the e-commerce industry. 

