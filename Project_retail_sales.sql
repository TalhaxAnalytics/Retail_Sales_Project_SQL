-- RETAIL_SALES ALANYSIS MYSQL PROJECT

-- Creating database
CREATE DATABASE Project_new;
Use Project_new;

-- Creating Table

CREATE TABLE retail_sales(
transactions_id INT PRIMARY key,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(10),
age INT,
category VARCHAR(20),
quantiy INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);

SELECT * from retail_sales;

-- Dealing with Null Values 

-- replacing null values in Age by Avg Age instead of Removing it
SET SQL_SAFE_UPDATES=0;
 
select avg(age) from retail_sales; -- Avg age is 41

UPDATE retail_sales
SET age = 41 Where age is NULL;

SELECT Count(*) from retail_sales where age is null ; -- So there is No Null value in age Now

-- Now Removing Other Rows that Contains Null Values 

DELETE FROM retail_sales
Where 
sale_date IS NULL OR sale_time IS NULL OR
customer_id IS NULL OR gender IS NULL OR age IS NULL OR category IS NULL 
OR quantiy IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;  -- Now there is No Null Value remaining in Table.

-- Data Exploring 

SELECT * from retail_sales;

SELECT COUNT(DISTINCT customer_id) from retail_sales ; -- 155 Unique Customers
SELECT DISTINCT category from retail_sales ; -- There are 3 Unique categories Beauty,Clothing and Electronics
SELECT category,sum(quantiy) as total_sold from retail_sales GROUP BY category order by total_sold DESC; -- Number of Total item Sold By category, Clothing is on top with Most Sold.
SELECT category,sum(total_sale) as total_sale from retail_sales GROUP BY category order by total_sale DESC; -- By total Sale Amount Electronics on Top. 

-- Heading towards our Project

-- Q1.Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * from retail_sales where sale_date ='2022-11-05';

-- Q2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
SELECT * from retail_sales where category="Clothing" And quantiy>=4 And date_format(sale_date,"%Y-%m")='2022-11';

-- Q3.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT round(avg(age),2) as Avg_age FROM retail_sales where category = 'Beauty';

-- Q4.Write a SQL query to find all transactions where the total_sale is greater than 1000.
Select * from retail_sales Where (total_sale)>1000;

-- Q5.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category,gender,count(transactions_id) from retail_sales GROUP BY category,gender Order by category;

-- Q6.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT * from retail_sales;

SELECT year(sale_date) as Year,monthname(sale_date) as Months,round(avg(total_sale),2) as Avg_sale   -- Avg_Sales of Each Month by Year
from retail_sales
GROUP BY  Year,Months Order by Year,Avg_sale DESC;

-- Finding Best Selling Month of Each Year

SELECT Year,Months,Avg_sale FROM 
(SELECT year(sale_date) as Year,monthname(sale_date) as Months,round(avg(total_sale),2) as Avg_sale,
    RANK() OVER(PARTITION BY year(sale_date) ORDER BY AVG(total_sale) DESC) as rankings
FROM retail_sales
GROUP BY Year,Months
) as t1
WHERE rankings = 1;              -- July and February are the best Months on 2022 and 2023 respectively.


-- Q.7 Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT customer_id,Total_Sales,Rankings from
(SELECT customer_id,SUM(total_sale) as Total_Sales,DENSE_RANK() OVER( ORDER BY SUM(total_sale) DESC) as Rankings FROM retail_sales 
GROUP BY customer_id ORDER BY Total_Sales DESC) as rank_check
Where Rankings BETWEEN 1 and 5;

-- Q.8 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT * FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) as unique_customers,category from retail_sales GROUP BY category;

-- Q.9 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

SELECT * FROM retail_sales;

SELECT *,
CASE
	WHEN hour(sale_time)<12 THEN "Morning"
    WHEN hour(sale_time) BETWEEN 12 and 17 THEN "Afternoon"
    ELSE "Evening"
    END as Shift
FROM retail_sales;

-- Q.10 Check the Total_number of Orders by each Shift

SELECT Shift,COUNT(transactions_id) as Total_Orders FROM
(SELECT *,
CASE
	WHEN hour(sale_time)<12 THEN "Morning"
    WHEN hour(sale_time) BETWEEN 12 and 17 THEN "Afternoon"
    ELSE "Evening"
    END as Shift												-- Most Number of Orders in Evening that are 1062, Then Morning with 548 Orders And in Afternoon there are only 377 orders
FROM retail_sales) as Shifts
GROUP BY Shift ORDER BY Total_Orders DESC;















































































