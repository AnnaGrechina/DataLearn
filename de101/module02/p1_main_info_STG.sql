-- Total Sales
select sum(sales) as TotalSales
from stg.orders

-- Total Profit
select sum(profit) as TotalProfit
from stg.orders

--Profit Ratio
select sum(profit) / sum(sales) as Profit_Ratio
from stg.orders

--Profit Rafio by Year
select extract (year from order_date) order_year,
		sum(profit) / sum(sales) as Profit_Ratio
from stg.orders
group by order_year 

-- Profit per order by Year
select extract (year from order_date) order_year,
		sum(profit) / count(distinct order_id) as mean_profit
from stg.orders
group by order_year 

-- Sales per Customer
select customer_id, sum(sales) cust_sales
from stg.orders
group by customer_id
order by customer_id

--Mean sales per Customer
select avg(cust_sales)
from (
	select customer_id, sum(sales) cust_sales
	from stg.orders
	group by customer_id
	) as a
	
--Avg. Discount
select avg(discount) from stg.orders

--Monthly Sales by Segment
select a.segment, avg(month_sales)
from (
	 select segment, 
	 	to_char(order_date, 'YYYY-MM') as order_month, 
	 	sum(sales) as month_sales
	 from stg.orders 
	 group by segment, order_month
	 ) a
group by a.segment

--Monthly Sales by Product Category
select a.category, avg(month_sales)
from (
	 select category, 
	 	to_char(order_date, 'YYYY-MM') as order_month, 
	 	sum(sales) as month_sales
	 from stg.orders 
	 group by category, order_month
	 ) a
group by a.category 

--Sales by Segment over time
select to_char(order_date , 'YYYY-MM') as order_month,
		segment,
		sum(sales)
from stg.orders
group by order_month, segment
order by order_month, segment 

--Sales by Product Category over time 
select to_char(order_date , 'YYYY-MM') as order_month,
		category,
		sum(sales)
from stg.orders
group by order_month, category
order by order_month, category 

--Sales and Profit by Customer
select AVG(s) avg_sales_by_customer from
	(
	select customer_id, sum(sales) s
	from stg.orders
	group by customer_id 
	) a
	
--Customer Ranking
select customer_id --, sum(sales)
from stg.orders
group by customer_id
order by sum(sales) desc

--Sales per region
select region, sum(sales) as region_sales
from stg.orders
group by region
order by region_sales desc

--Sales per region over time
select region, to_char(order_date , 'YYYY-MM') as order_month, sum(sales) as region_sales
from stg.orders
group by region, order_month
order by region, order_month
