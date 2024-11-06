# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `project_new`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `project_new`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and deleting records with missing data or replacing with suitable data.

```sql
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
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT * from retail_sales where category="Clothing" And quantiy>=4 And date_format(sale_date,"%Y-%m")='2022-11';
```


3. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT round(avg(age),2) as Avg_age FROM retail_sales where category = 'Beauty';
```

4. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales WHERE total_sale > 1000
```

5. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT category,gender,count(transactions_id) from retail_sales GROUP BY category,gender Order by category;
```

6. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:

```sql

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
```

7. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql

SELECT customer_id,Total_Sales,Rankings from
(SELECT customer_id,SUM(total_sale) as Total_Sales,DENSE_RANK() OVER( ORDER BY SUM(total_sale) DESC) as Rankings FROM retail_sales 
GROUP BY customer_id ORDER BY Total_Sales DESC) as rank_check
Where Rankings BETWEEN 1 and 5;

```

8. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT COUNT(DISTINCT customer_id) as unique_customers,category from retail_sales GROUP BY category;
```

9. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql

SELECT *,
CASE
	WHEN hour(sale_time)<12 THEN "Morning"
    WHEN hour(sale_time) BETWEEN 12 and 17 THEN "Afternoon"
    ELSE "Evening"
    END as Shift
FROM retail_sales;
```
10. **Check the Total_number of Orders by each Shift**
```sql
SELECT Shift,COUNT(transactions_id) as Total_Orders FROM
(SELECT *,
CASE
	WHEN hour(sale_time)<12 THEN "Morning"
    WHEN hour(sale_time) BETWEEN 12 and 17 THEN "Afternoon"
    ELSE "Evening"
    END as Shift												-- Most Number of Orders in Evening that are 1062, Then Morning with 548 Orders And in Afternoon there are only 377 orders
FROM retail_sales) as Shifts
GROUP BY Shift ORDER BY Total_Orders DESC;
```



## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - TalhaxAnalytics

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

Thank you!
