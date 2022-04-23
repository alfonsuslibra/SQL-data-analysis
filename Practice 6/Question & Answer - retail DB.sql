# 1. Fetch all the small shipped orders from August 2003 till the end of year 2003.
# small shipped orders

select count(1) from sales_order
where status = "Shipped" and deal_size = "Small"
and order_date between str_to_date("2003-08-01", "%Y-%m-%d") and str_to_date("2003-12-31", "%Y-%m-%d");

select count(1) from sales_order
where status = "Shipped" and deal_size = "Small"
and month_id  >= 8 and month_id  <= 12 and year_id = 2003;

# 2.  Find only those orders which do not belong to customers from USA and are still in process.
select s.*, c.country from sales_order s
inner join customers c
on s.customer = c.customer_id
where status = "In Process" and country <> "USA";

# 3. Find all orders for Planes, Ships and Trains which are neither Shipped nor In Process nor Resolved.
select s.*, p.PRODUCT_LINE from sales_order s 
inner join products p 
on s.Product = p.product_code
where p.PRODUCT_LINE in ("Planes", "Ships", "Trains") and 
s.status not in ("Shipped", "In Process", "Resolved");

# 4. Find customers whose phone number has either parenthesis "()" or a plus sign "+".
select * from customers
where phone like "%+%" or phone like "%(%" or phone like "%)%";

# 5. Find customers whose phone number does not have any space.
select * from customers
where phone not like "% %";

# 6. Fetch all the orders between Feb 2003 and May 2003 where the quantity ordered was an even number.
select * from sales_order
where month_id>=2 and month_id<=5 and year_id = 2003
and mod(quantity_ordered,2) = 0;

# 7. Find orders which sold the product for price higher than its original price.
select s.*, p.price from sales_order s
inner join products p
on s.Product = p.product_code and s.price_each > p.price;