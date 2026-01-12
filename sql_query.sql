-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;


-- CREATE TABLE
CREATE TABLE retail_sales
            (
               transactions_id INT PRIMARY KEY,
	           sale_date DATE,
	           sale_time TIME,	
	           customer_id INT,
	           gender VARCHAR(15),	
	           age INT,
	           category VARCHAR(15),
	           quantiy INT,
	           price_per_unit FLOAT,
	           cogs FLOAT,
	           total_sale FLOAT
            );

-- INITIAL DATA INSPECTION

SELECT * FROM retail_sales
LIMIT 10;

SELECT 
    COUNT(*)
FROM retail_sales

-- DATA CLEANING

-- Identify Missing Values
SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL
	OR
	sale_date IS NULL
    OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- REMOVE INCOMPLETE RECORDS 

DELETE FROM retail_sales 
WHERE 
    transactions_id IS NULL
	OR
	sale_date IS NULL
    OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- EXPLORATORY DATA ANALYSIS 

-- What is the total volume of sales transactions recorded?

SELECT COUNT(*) AS total_sales
FROM retail_sales;

-- What is the total number of distinct customers?

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales;

-- Which distinct product categories are represented in the dataset?

SELECT DISTINCT category
FROM retail_sales;

-- BUSINESS QUESTIONS AND ANALYSIS 

-- 1. Which 5 customers generated the highest total sales revenue? 

SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- 2. Which age group has the most customers?
SELECT
    CASE 
        WHEN age <= 25 THEN 'Young'
        WHEN age BETWEEN 26 AND 40 THEN 'Adult'
        WHEN age BETWEEN 41 AND 60 THEN 'Mid-age'
        ELSE 'Senior'
    END AS age_group,
    COUNT(DISTINCT customer_id) AS num_customers
FROM retail_sales
GROUP BY age_group
ORDER BY num_customers DESC;

-- 3. How many unique customers purchased items in each product category? 

SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;


-- 4. What is the average age of customers by gender who purchased items from the 'Beauty' category?

SELECT 
    gender, 
    ROUND(AVG(age), 2) AS average_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY gender;

-- 5. Which product categories are purchased most frequently?

SELECT
    category,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category 
ORDER BY total_transactions DESC;

-- 6. Which product categories are most frequently purchased by each gender?

SELECT
    category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY gender, total_transactions DESC;

-- 7. Which product categories contribute the most to total sales revenue?

SELECT
    category,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;

-- 8. What is the average number of orders placed per customer?

SELECT
    AVG(order_count) AS avg_orders_per_customer
FROM (
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM retail_sales
    GROUP BY customer_id
) customer_orders;

-- DATE AND FILTERED ANALYSIS 

-- 9. What sales were recorded on November 5, 2022?

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- 10. What Clothing transactions had exactly 4 units sold in November 2022?

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantiy >= 4
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';


-- 11. Which transactions generated high revenue (sales above 1000)?

SELECT *
  FROM retail_sales
  WHERE total_sale > 1000;

-- TIME-BASED ANALYSIS

-- 12. What is the best-selling month in each year based on average sales?

WITH monthly_avg_sales AS (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sales
    FROM retail_sales
    GROUP BY year, month
)
SELECT year, month, avg_sales
FROM (
    SELECT *,
           RANK() OVER (PARTITION BY year ORDER BY avg_sales DESC) AS rank
    FROM monthly_avg_sales
) t
WHERE rank = 1;

-- 13. How do sales orders vary by time of day (morning, afternoon, and evening)?

WITH hourly_sale AS
(
SELECT *, 
   CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
   END as shift
FROM retail_sales 
)

SELECT shift, 
   COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift
ORDER BY total_orders DESC;

-- End of project 





