# Get top 3 products with the highest total sales value 
# in October 2020 in each category. Show the category name, 
# product name, and total sales value.
# Total Sales Value = Order Value from delivered transaction 
# (trx_state = ‘Delivered’)

select c.name category_name, p.name product_name, 
sum(s.order_value) total_sales_value
from sales_order s
inner join product p
on s.product_id = p.id
inner join category c
on p.category_id = c.id
where trx_state = 'Delivered' and extract(month from created_at) = 10
group by 1,2
order by 3 desc
limit 3

# Get all products with sales value lower than average sales 
# value of products within the corresponding category. 
# Show category name, product name, product sales value, 
# and average sales value in corresponding category.

with t0 as(
select c.name category_name, p.name product_name, 
s.order_value sales_value
from sales_order s
inner join product p
on s.product_id = p.id
inner join category c
on p.category_id = c.id
),
t1 as (select *, 
avg(sales_value) over(partition by category_name) as avg_sales_by_cat
from t0
)
select * from t1 
where sales_value < avg_sales_by_cat 
order by category_name, sales_value;

# Calculate sales lost and sales lost rate of each category, 
# sort by sales lost descending. Show category name, sales lost, 
# and sales lost rate.Sales lost = Order Value from Cancelled 
# Transactions. Sales Lost Rate = (Order value from cancelled 
# transactions)/(Total order value from all transactions)

with t0 as (
select c.name category_name, s.trx_state status, 
s.order_value sales_value
from sales_order s
inner join product p
on s.product_id = p.id
inner join category c
on p.category_id = c.id
), 
t1 as (
select *, 
row_number() over (partition by category_name, status) as row_dummy,
sum(sales_value) over (partition by category_name, status) as total_sales_by_catnstat, 
sum(sales_value) over (partition by category_name) as total_sales_by_cat
from t0
)
select category_name, total_sales_by_catnstat as sales_lost, 
round(sales_value/total_sales_by_cat*100,1) as sales_lost_rate 
from t1 
where status = "Cancelled" and row_dummy = 1
order by sales_lost desc


