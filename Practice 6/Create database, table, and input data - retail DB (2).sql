# Aggregate function (Min, Max, Avg, Sum, Count)

# 1. Find the average sales order price
select round(avg(sales),4) as avg_sales from sales_order;

# 2. Count total no of orders
select count(1) as no_of_orders from sales_order;

# 3. Find the total qty (items) sold
select sum(quantity_ordered) as total_qty from sales_order;

# 4. Fetch the first oder date and the last order date
select min(order_date) as first_order_date, max(order_date) as last_order_date from sales_order;

# Group By & Having clause

# 1. Find the average sales order price based on deal size (M, S, L)
select deal_size, round(avg(price_each),4) avg_sales
from sales_order
group by 1;

# 2. Find total no of orders per each day. Sort data based on highest orders.
select order_date, count(order_number) as no_of_orders
from sales_order
group by 1
order by 2 desc;

# 3. Segregate order sales for each quarter. Display the data with highest sales quarter on top.
# (In each quarter how much sales amount was generated)
select qtr_id, round(sum(sales),2) total_sales
from sales_order
group by 1
order by 2 desc;

# 4. Identify how many cars, Motorcycles, trains and ships are available.
# Treat all type of cars as just "Cars".
select product_line, count(1) from 
(select case when product_line like '%Cars%' then 'Cars'
else product_line end product_line
from products) as sq
where product_line in ('Cars', 'Motorcycles', 'Trains', 'Ships')
group by 1;

# 5. Identify how many cars, Motorcycles, trains and ships are available.
# Treat all type of cars as just "Cars". Display only vehicles which are less than 10 in number
select product_line, count(1) as no_of_vehicles from 
(select case when product_line like '%Cars%' then 'Cars'
else product_line end product_line
from products) as sq
where product_line in ('Cars', 'Motorcycles', 'Trains', 'Ships')
group by 1
having no_of_vehicles < 10;

# 6. Find the countries which have purchase more than 500 motorcycles
select c.country, p.PRODUCT_LINE, sum(s.quantity_ordered) as qty_purchased
from sales_order s
inner join customers c
on s.customer = c.customer_id
inner join products p
on s.Product = p.product_code
where PRODUCT_LINE = 'Motorcycles'
group by 1,2
having sum(s.quantity_ordered) > 500;

