-- 1. Create Database
CREATE DATABASE IF NOT EXISTS sales_analysis;
USE sales_analysis;

-- 2. Create Table
CREATE TABLE cleaned_sales_data (
    order_id VARCHAR(20),
    product VARCHAR(255),
    quantity_ordered INT,
    price_each DECIMAL(10,2),
    order_date DATETIME,
    purchase_address VARCHAR(255),
    month INT,
    sales DECIMAL(12,2),
    city VARCHAR(100),
    hour INT,
    day INT,
    weekday VARCHAR(20)
);

-- 3. Import Cleaned CSV into Table
-- ⚠️ Update path if needed
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cleaned_sales_data.csv'
INTO TABLE cleaned_sales_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, product, quantity_ordered, price_each, order_date, 
 purchase_address, month, sales, city, hour, day, weekday);

-- 4. Data Quality Check
SELECT 
  SUM(order_id IS NULL) AS null_order_id,
  SUM(product IS NULL) AS null_product,
  SUM(order_date IS NULL) AS null_order_date
FROM cleaned_sales_data;

-- 5. Total Sales Summary
SELECT ROUND(SUM(sales), 2) AS total_sales FROM cleaned_sales_data;
SELECT SUM(quantity_ordered) AS total_quantity FROM cleaned_sales_data;

-- 6. Sales by City
SELECT city, ROUND(SUM(sales), 2) AS total_sales
FROM cleaned_sales_data
GROUP BY city
ORDER BY total_sales DESC;

SELECT city, SUM(quantity_ordered) AS total_quantity
FROM cleaned_sales_data
GROUP BY city
ORDER BY total_quantity DESC;

-- 7. Monthly Sales Trend
SELECT month, ROUND(SUM(sales), 2) AS monthly_sales
FROM cleaned_sales_data
GROUP BY month
ORDER BY month;

-- 8. Hourly Sales Trend (Peak Times)
SELECT hour, ROUND(SUM(sales), 2) AS hourly_sales
FROM cleaned_sales_data
GROUP BY hour
ORDER BY hour;

-- 9. Weekday Sales Trend
SELECT weekday, ROUND(SUM(sales), 2) AS weekday_sales
FROM cleaned_sales_data
GROUP BY weekday
ORDER BY FIELD(weekday, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- 10. Top 10 Products by Quantity
SELECT product, SUM(quantity_ordered) AS total_quantity
FROM cleaned_sales_data
GROUP BY product
ORDER BY total_quantity DESC
LIMIT 10;

-- 11. Top 10 Products by Revenue
SELECT product, ROUND(SUM(sales), 2) AS total_sales
FROM cleaned_sales_data
GROUP BY product
ORDER BY total_sales DESC
LIMIT 10;

-- 12. Top 5 Purchase Addresses
SELECT purchase_address, COUNT(*) AS total_orders
FROM cleaned_sales_data
GROUP BY purchase_address
ORDER BY total_orders DESC
LIMIT 5;
