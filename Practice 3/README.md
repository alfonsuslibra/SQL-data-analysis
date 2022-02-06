# Readme

Given a databases with 3 tables, 
1. Category (index = id)
Columns = id, name
2. Product (index = id)
Columns = id, name, category_id
3. sales order (index = trx_id)
Columns = trx_line_id, product_id, trx_state, order_value, created_at

Write SQL queries to:
a. Get top 3 products with the highest total sales value in October 2020 in
each category. Show the category name, product name, and total sales
value.
Total Sales Value = Order Value from delivered transaction (trx_state =
‘Delivered’)

b. Get all products with sales value lower than average sales value of
products within the corresponding category. Show category name,
product name, product sales value, and average sales value in
corresponding category.

c. Calculate sales lost and sales lost rate of each category, sort by sales lost
descending. Show category name, sales lost, and sales lost rate.
Sales lost = Order Value from Cancelled Transactions.
Sales Lost Rate = (Order value from cancelled transactions)/(Total order
value from all transactions)
