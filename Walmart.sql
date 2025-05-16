create database walmartSales;
use walmartSales;
select * from walmart;

#Count payment methods and number of transactions by payment method
select payment_method, count(*)
from walmart
group by payment_method;

#Count distinct branches
select count(Distinct Branch) from walmart;


# Find the minimum quantity sold
select min(quantity) As Min_quantity
from walmart;
#Q1:Find different payment methods, number of transactions, and quantity sold by payment method
Select payment_method,
	   count(*) AS no_of_transactions,
       sum(quantity) As no_quantity_sold 
from walmart
group by payment_method; 

#2: Identify the highest-rated category in each branch
-- Display the branch, category, and avg rating
Select branch, category, avg_rating 
from (
       select
       branch, category, avg(rating) AS avg_rating,
       Rank() over(partition by branch order by avg(rating) desc) As rating_rank
       from walmart
       group by branch ,category
       ) AS_ranked
where rating_rank = 1;

#3:Identify the busiest day for each branch based on the number of transactions
SELECT branch, day_name, no_transactions
FROM (
    SELECT 
        Branch AS branch,
        DAYNAME(STR_TO_DATE(date, '%d-%m-%Y')) AS day_name,
        COUNT(*) AS no_transactions,
        RANK() OVER (PARTITION BY Branch ORDER BY COUNT(*) DESC) AS day_rank
    FROM walmart
    GROUP BY Branch, DAYNAME(STR_TO_DATE(date, '%d-%m-%Y'))
) AS ranked_data
WHERE day_rank = 1;

 #Q4: Calculate the total quantity of items sold per payment method
 select payment_method, 
       sum(quantity) As items_sold
from walmart
group by payment_method;

 #Q5: Determine the average, minimum, and maximum rating of categories for each city
select category, city,
       Round(avg(rating), 2) As Avg_rating,
		max(rating) As Max_rating,
        min(rating) As Min_rating
        from walmart
        group by category ,city;

#Q6: Calculate the total profit for each category
select Category, SUM(unit_price * quantity * profit_margin) AS total_profit
from  walmart
Group by Category
order by total_profit;

#Q7: Determine the most common payment method for each branch
WITH cte AS (
    SELECT 
        branch,
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS branch_rank
    FROM walmart
    GROUP BY branch, payment_method
)
SELECT branch, payment_method AS preferred_payment_method
FROM cte
WHERE branch_rank = 1;

#Q8: Categorize sales into Morning, Afternoon, and Evening shifts
SELECT
    branch,
    CASE 
        WHEN HOUR(TIME(time)) < 12 THEN 'Morning'
        WHEN HOUR(TIME(time)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS num_invoices
FROM walmart
GROUP BY branch, shift
ORDER BY branch, num_invoices DESC;

#Q9: Identify the 5 branches with the highest revenue decrease ratio from last year to current year (e.g., 2022 to 2023)
WITH revenue_2022 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2022
    GROUP BY branch
),
revenue_2023 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2023
    GROUP BY branch
)
SELECT 
    r2022.branch,
    r2022.revenue AS last_year_revenue,
    r2023.revenue AS current_year_revenue,
    ROUND(((r2022.revenue - r2023.revenue) / r2022.revenue) * 100, 2) AS revenue_decrease_ratio
FROM revenue_2022 AS r2022
JOIN revenue_2023 AS r2023 ON r2022.branch = r2023.branch
WHERE r2022.revenue > r2023.revenue
ORDER BY revenue_decrease_ratio DESC
LIMIT 5;




