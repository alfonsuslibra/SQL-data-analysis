# 1. Fetch paintings that are priced higher than the average painting price.
select name, listed_price
from paintings
where listed_price > (select avg(listed_price) from paintings);

# 2. Fetch all collectors who purchased paintings.
select *
from collectors
where id in (select collector_id from sales);

select distinct first_name, last_name, c.id from sales s
inner join collectors c
on s.collector_id = c.id;

# 3. Fetch the total amount of sales for each artist who has sold at least 3 painting
select artist_id, first_name, last_name, total_sales
from (select artist_id, sum(sales_price) as total_sales, count(1) no_of_sls from sales 
group by 1 having count(1) >= 3) as dummy
inner join artists a
on dummy.artist_id = a.id;

# 4. Find the names of the artists who had zero sales
select * from artists a where not exists (select 1 from sales s where s.artist_id = a.id);
