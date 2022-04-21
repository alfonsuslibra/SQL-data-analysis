# 1. Fetch all transaction data
select * from transactions;

# 2. Fetch acc_number & acc_type from all acounts
select account_number, acc_type from accounts;

# 3. Fetch customer_id and name of all active customers
select customer_id, concat(first_name, ' ', last_name) as cust_name, is_active 
from customers
where is_active = TRUE;

# 4. Fetch cust id and name of all active customers who were born after 2000
select customer_id, concat(first_name, ' ', last_name) as cust_name, dob, is_active 
from customers
where is_active = TRUE and str_to_date(dob, '%Y-%m-%d') >= '2000-01-01' ;

select * from customers;

# 5. Find employees whose salary ranges from 50k to 70k
select * from employee where salary between 50000 and 70000;
select * from employee where salary >= 50000 and salary <= 70000;

# 6. Find cust who havent provided basic info
# such as address and phone no
select * from customers where phone_no is null or address is null;

# 7. Find customers having "oo" in their name
select * from customers 
where first_name like '%oo%' or last_name like '%oo%';
# sql is case sensitive

# 8. Identify the total no of wire transfer transactions
select count(1) as no_of_wire_transactions from transactions
where trns_type = 'wire transfer';
# count(1) is faster than count(*) bcs * will fetch all the rows and columns
# count function only count not null value

# 9. Identify the unique trans type
select distinct(trns_type) as unique_trans_type from transactions;
select distinct trns_type, status from transactions; # apply to both columns

# 10. Fetch the first 5 transactions
select * from transactions
order by trns_date asc
limit 5;

# 11. Fetch the inactive customers name, phone no, 
# address, and dob! Display the oldest customer first
select concat(first_name, ' ', last_name) as cust_name, 
phone_no, address, dob
from customers
where is_active = FALSE
order by dob;

# 12. Find the customers who are from either "77 Lien Park"
# "337 Westend Park", "9 Troy Plaza"
select * 
from customers
where address in ("77 Lien Park", "9 Troy Plaza", "337 Westend Park");

# 13. Fetch all customers who have "Park" or "Plaza"
# in their address
select * 
from customers
where address like "%Park%" or "%Plaza%"; 

# 14. find employees working in mumbai
select * from employee e
inner join branch b
on e.branch_code = b.branch_code
where b.branch_name in ("Bangalore", "Mumbai")
order by b.branch_name, salary desc;

# 15. Find total no of successful transactions 
# that belong to inactive customers
select count(1) from transactions t
inner join accounts a
on t.acc_number = a.account_number
inner join customers c
on a.cust_id = c.customer_id
where t.status = "Success" and c.is_active = false

# 16. Categorise employees based on their salary
select *, 
case when salary < 50000 then "Low Salary"
when salary >= 50000 and salary <= 70000 then "Medium Salary" 
when salary > 70000 then "High Salary"
end salary_categorization 
from employee;

# 17. Find the total balance of all savings account
select acc_type, round(sum(balance)) 
from accounts
where acc_type = "Saving"
group by 1;

# 18. Display the total account balance in all the loan
# and saving accounts
select acc_type, round(sum(balance)) 
from accounts
group by 1;