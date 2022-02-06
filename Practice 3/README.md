# Readme

Given a databases with 3 tables, 

1. Category (index = id)

|  id  |       name       |
|   1  | makanan instan   |
|   2  | fresh            |
|   3  | makanan ringan   |
|   4  | rokok            |
|   .. | ..               |
|   99 | minuman kemasan  |


2. Product (index = id)

|  id  |         name          | category_id |
|   1  | filma minyak goreng   |      7      |
|   2  | beras si geulis       |      8      |
|   3  | kapal api special mix |     15      |
|   4  | ladaku merica bubuk   |     10      |
|   .. |        ..             |     ..      |
|   99 | djarum gold           |      4      |

3. sales order (index = trx_id)

| trx_line_id | product_id | trx_state | order_value |      created_at     |
|      1      |      3     | Delivered |   100000    | 2020-10-05 21:57:26 |

|      2      |      1     | Cancelled |   300000    | 2020-08-15 12:47:36 |

|      3      |      1     | Delivered |  1500000    | 2020-09-18 11:17:06 |

|      4      |      5     | Cancelled |  50750000   | 2020-11-05 06:07:18 |

|      5      |      1     | Cancelled |  7750000    | 2020-10-24 20:06:19 | 

|      6      |      4     | Delivered |  5500000    | 2020-09-21 19:47:08 | 

|     ..      |     ..     |     ..    |      ..     |         ..          | 

|    999      |     99     | Delivered |  25000000   | 2020-09-14 09:44:17 | 

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
