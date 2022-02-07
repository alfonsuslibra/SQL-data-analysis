# Readme

Given a databases with 2 tables,

1. User Profile (index = user_id) Columns = user_id, registration_import_datetime, user_gender, user_age, user_occupation, user_income_range, referral_code_used, user_income_source
2. Transactions (index = user_id) Columns = user_id, date, saham_aum. saham_invested_amt, pasar_uang_aum, pasar_uang_invested_amt, pendapatan_tetap_aum, pendapatan_tetap_invested_amt, campuran_aum, campuran_invested_amt


Write SQL queries to:

a. Write a query that finds the top 3 users with most active (frequency) on buying for each 
group 17-22 and 23 - 30

b. Write a query that finds the top 3 users with most active (frequency) on selling
(Reksadana Saham Portfolio Only) who are female and income source not from 
"Keuntungan Bisnis"
