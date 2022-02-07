# Number 1
with t0 as 
(
select t.*, 
Saham_invested_amount + Pasar_Uang_invested_amount + Pendapatan_Tetap_invested_amount + Campuran_invested_amount as Total_invested_amount
from transactions t
), 

t1 as (
select t0.*, u.user_age , 
case when u.user_age between 17 and 22 then "Group 17 - 22"
	when u.user_age between 23 and 30 then "Group 23 - 30"
	when u.user_age > 30 then "Group Others"
end group_age
from t0
inner join user_profile u
on t0.user_id = u.user_id
), 

t2 as (
select t1.*, 
lag(t1.Total_invested_amount) over (partition by user_id) as prev_invested_amount, 
case when t1.Total_invested_amount > lag(t1.Total_invested_amount) over (partition by user_id) then "Buying"
	when t1.Total_invested_amount < lag(t1.Total_invested_amount) over (partition by user_id) then "Selling"
	when t1.Total_invested_amount = lag(t1.Total_invested_amount) over (partition by user_id) then "Maintain"
end journey
from t1
)

(select t2.user_id, t2.user_age, t2.group_age, count(t2.journey) as no_of_buying
from t2 
where t2.journey = "Buying" and t2.group_age = "Group 17 - 22"
group by 1,2,3
order by no_of_buying desc 
limit 3)
union
(select t2.user_id, t2.user_age, t2.group_age, count(t2.journey) as no_of_buying
from t2 
where t2.journey = "Buying" and t2.group_age = "Group 23 - 30"
group by 1,2,3
order by no_of_buying desc 
limit 3);

--------------------------------------------------------------------------------------------

# Number 2
with t0 as (
select t.*, 
case when Saham_invested_amount - 
  (1000000 * (Pasar_Uang_invested_amount + Pendapatan_Tetap_invested_amount + Campuran_invested_amount)) > 0 then "RD Saham Only"
	when Saham_invested_amount - 
  (1000000 * (Pasar_Uang_invested_amount + Pendapatan_Tetap_invested_amount + Campuran_invested_amount)) <= 0 then "RD Others"
end composition
from transactions t
), 

t1 as (
select t0.*, u.user_gender, u.user_income_source
from t0
inner join user_profile u
on t0.user_id = u.user_id
where t0.composition = "RD Saham Only"
), 

t2 as (
select t1.*, 
lag(t1.Saham_invested_amount) over (partition by user_id) as prev_invested_amount, 
case when t1.Saham_invested_amount > lag(t1.Saham_invested_amount) over (partition by user_id) then "Buying"
	when t1.Saham_invested_amount < lag(t1.Saham_invested_amount) over (partition by user_id) then "Selling"
	when t1.Saham_invested_amount = lag(t1.Saham_invested_amount) over (partition by user_id) then "Maintain"
end journey
from t1
) 

select t2.user_id, t2.user_gender, t2.user_income_source, 
count(t2.journey) as no_of_selling
from t2
where t2.journey = "Selling" and t2.user_gender = "Female" 
and t2.user_income_source <> "Keuntungan Bisnis"
group by 1,2,3
order by no_of_selling desc 
limit 3;
