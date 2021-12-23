# 1. Count the number of customers per city
select city, count(distinct(CustomerId)) as total_number 
from `snappy-mark-296918.1superstore_wanda.customers`
group by city 
order by total_number desc;

# 2. Count the number of orders per city
select city, count(Order_ID) as num_of_orders
from `snappy-mark-296918.1superstore_wanda.orders` t1
left join 
(select distinct CustomerId, City
from `snappy-mark-296918.1superstore_wanda.customers` ) t2
on t1.Customer_ID = t2.CustomerId
group by city order by num_of_orders desc;

# 3. Find the first order date of each customer
select distinct Customer_ID, min(Order_Date) as first_order_date 
from `snappy-mark-296918.1superstore_wanda.orders`
group by Customer_ID order by Customer_ID;

# 4. Find the number of customer who made their first order in each city, each day
select City, first_order_date, count(distinct(t0.Customer_ID)) as no_of_cust
from 
(select Customer_ID, min(Order_Date) as first_order_date 
from `snappy-mark-296918.1superstore_wanda.orders` 
group by Customer_ID) as t0
left join `snappy-mark-296918.1superstore_wanda.customers` c
on t0.Customer_ID = c.CustomerId
group by City, first_order_date order by no_of_cust desc

# 5. Find the first sales of each customer. If there is a tie, use the order with lower order id
with t0 as 
    (select o.Customer_ID, o.Sales, o.Order_Date,
    min(o.Order_Date) over (partition by o.Customer_ID) as first_order_date
    from `snappy-mark-296918.1superstore_wanda.orders` as o
    order by o.Order_ID)
select Customer_ID, Sales from t0 
where Order_Date = first_order_date 
order by Customer_ID


