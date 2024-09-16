-- SQL Retails sales analysis - P1

CREATE DATABASE sql_project_p2;

-- Create Table
CREATE TABLE Sales_Retail
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
DROP TABLE IF EXISTS retail_sales;

-- Data cleaning 

SELECT * FROM sales_retail
LIMIT 50;

SELECT 
     COUNT(*)
FROM sales_retail;

SELECT * FROM sales_retail
WHERE age IS NULL;

-- Data exploration
-- how many sales we have?

SELECT 
COUNT(*) as total_sales
FROM sales_retail;

-- How many UNIQUE customer we have?

SELECT COUNT(DISTINCT customer_id) AS total_customer
FROM sales_retail;

-- which all categories we have?

SELECT DISTINCT category 
FROM sales_retail;

-- Data Analysis & Business key problems with answers

-- Q.1 To retrieve all columns for the sales made on "2022-11-05"

SELECT * FROM sales_retail
WHERE sale_date = '2022-11-05';

-- Q.2 To retrieve all transaction where category is 'clothing' and the quantity sold is more than 4 and in the month of NOV-2022

-- SELECT 
-- category,
-- SUM(quantiy)
-- FROM sales_retail
-- WHERE category = 'Clothing'
-- AND
-- TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' -- TO_CHAR IS BEING USED ONLY IN THE PostgreSQL BUT IN MYSQL it's different
-- GROUP BY 1;

SELECT *
FROM sales_retail
WHERE category = 'Clothing'
    AND quantiy >= 4
	AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';
    
-- Q.3 To calculate the total sales for each category
    
SELECT 
      category,
      SUM(total_sale) as net_sales,
      COUNT(*) as total_orders
FROM sales_retail
GROUP BY 1;
   
-- Q.4 To find the average age of customers who purchased items from the "beauty" category

SELECT 
	ROUND(AVG(age), 2) as average_age
	FROM sales_retail
    WHERE category = 'Beauty';
    
-- Q.5 To find all transaction where the total_sale is greater than 1000.

SELECT * FROM sales_retail
WHERE total_sale > 1000;

-- Q.6 to find the total number of transactions (transactions_id) made by each gender in each category.

SELECT 
	 category,
     gender,
     COUNT(*) as total_trans
FROM sales_retail
GROUP BY
       category,
       gender
ORDER BY 1;

-- Q.7 To calculate the average sale for each month. Find out Best selling month in each year.

SELECT
    YEAR(sale_date) AS sale_year,
    MONTH(sale_date) AS sale_month,
    ROUND(AVG(total_sale), 2) AS avg_total_sales
FROM sales_retail
GROUP BY sale_year, sale_month
ORDER BY sale_year;

-- Q.8 To find the top 5 customers based on the highest total sales.

SELECT
     customer_id,
     SUM(total_sale) as total_sales
FROM sales_retail
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 To find the number of unique customers who purchsed items from each category 

SELECT 
     category,
     COUNT(DISTINCT customer_id) AS UNIQUE_CUSTOMER
FROM sales_retail
GROUP BY category;

-- Q.10 To create each shift and number of orders (Example morning <=12, afternoon Between 12 & 17, Evening > 17)

WITH hourly_sale
AS
(
SELECT *,
      CASE 
          WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
          WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
          ELSE 'Evening'
	  END AS shift
FROM sales_retail
)
SELECT
     shift,
     COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift