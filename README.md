# SQL Retail Sales Analysis Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `sql_project_p2`

This project demonstrates SQL skills applied to a retail sales dataset. The analysis focuses on understanding customer behavior, purchase patterns, and product performance. The approach starts by profiling customers analyzing age, gender, and purchase behavior before moving into product and time-based sales insights.

## Objectives

1. **Set up a retail sales database**: Create and populate a table with transaction data.
2. **Data Cleaning**: Identify and remove records with missing values to ensure analysis quality.
3. **Exploratory Data Analysis (EDA)**: Gain insights into customers, products, and sales trends.
4. **Business Analysis**: Answer business questions using SQL queries including customer profiling, category performance, and time-based sales.

## Project Structure

### A. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_p2`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.


```sql
CREATE DATABASE sql_project_p2;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### B. Initial Data Inspection

- **Preview Data**: View first 10 rows.
- **Total Records**: Count all transactions.

```sql
SELECT * FROM retail_sales
LIMIT 10;
SELECT 
    COUNT(*)
FROM retail_sales
```

### C. Data Cleaning

- **Identify missing values**: Check for incomplete records.
- **Remove incomplete records**: Delete any rows with null values in key fields.

```sql
SELECT * FROM retail_sales
WHERE transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL
      OR gender IS NULL OR age IS NULL OR category IS NULL
      OR quantiy IS NULL OR cogs IS NULL OR total_sale IS NULL;

DELETE FROM retail_sales
WHERE transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL
      OR gender IS NULL OR age IS NULL OR category IS NULL
      OR quantiy IS NULL OR cogs IS NULL OR total_sale IS NULL;
```
  
### D. Exploratory Data Analysis (Customer-Centric)
Since understanding customers is critical, the analysis starts by profiling who the customers are and their purchasing patterns:

- **Total sales transactions**:

```sql
SELECT COUNT(*) AS total_sales FROM retail_sales;
```

- **Distinct Customers**:

```sql
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;
```

The following SQL queries were developed to answer specific business questions:

1. **Which 5 customers generated the highest total sales revenue**? 

```sql
SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

2. **Which age group has the most customers**?

```sql
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
```

3. **How many unique customers purchased items in each product category**? 

```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

4. **What is the average age of customers by gender who purchased items from the 'Beauty' category**?

```sql
SELECT 
    gender, 
    ROUND(AVG(age), 2) AS average_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY gender;
```

5. **Which product categories are purchased most frequently**?

```sql
SELECT
    category,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category 
ORDER BY total_transactions DESC;
```

6. **Which product categories are most frequently purchased by each gender**?

```sql
SELECT
    category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY gender, total_transactions DESC;
```

7. **Which product categories contribute the most to total sales revenue**?

```sql
SELECT
    category,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;
```

8. **What is the average number of orders placed per customer**?

```sql
SELECT
    AVG(order_count) AS avg_orders_per_customer
FROM (
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM retail_sales
    GROUP BY customer_id
) customer_orders;
```

### F. DATE AND FILTERED ANALYSIS 


9. **What sales were recorded on November 5, 2022**?

```sql
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

10. **What Clothing transactions had exactly 4 units sold in November 2022**?

```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantiy >= 4
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';
```

11. **Which transactions generated high revenue (sales above 1000)**?

```sql
SELECT *
  FROM retail_sales
  WHERE total_sale > 1000;
```

### G. TIME-BASED ANALYSIS

12. **What is the best-selling month in each year based on average sales**?

```sql
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
```

13. **How do sales orders vary by time of day (morning, afternoon, and evening)**?

```sql
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
```


## Key Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Recommendations

- **Target marketing**: Focus promotions on mid-age customers and men for Clothing.
- **Revenue Strategy**: Prioritize Electronics for higher revenue per transaction.
- **Time-based campaigns**: RRun campaigns during peak order times in the evening.
- **Customer retention**: Reward top customers and encourage repeat purchases from other age groups.

## Conclusion

This project demonstrates SQL skills applied to retail sales analysis, beginning with customer insights, moving to product trends, and finally examining time-based sales patterns. The findings can help businesses make data-driven decisions on marketing, inventory, and sales strategy.


This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!
