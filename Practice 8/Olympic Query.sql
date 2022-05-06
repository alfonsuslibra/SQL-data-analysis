# 1. How many olympics games have been held?
select count(distinct games) as no_of_games_held from olympics_history;

# 2. List down all olympics games held so far?
select distinct games as games_held, city from olympics_history order by games_held asc;

# 3. Mention the total no of nations who participated in each olympics game?
select games, count(distinct noc) as no_of_participated_nations
from OLYMPICS_HISTORY
group by 1
order by 1 asc;

# 4. Which year saw the highest and lowest no of countries participating in olympics?
with t0 as 
(
select year, count(distinct noc) as no_of_participated_nations
from OLYMPICS_HISTORY
group by 1)
select distinct concat('year ', first_value(year) over (order by no_of_participated_nations desc), ' - ', 
first_value(no_of_participated_nations) over (order by no_of_participated_nations desc), ' countries') 
as highest_countries, 
concat('year ', first_value(year) over (order by no_of_participated_nations asc), ' - ', 
first_value(no_of_participated_nations) over (order by no_of_participated_nations asc), ' countries') 
as lowest_countries
from t0;

# 5. Which nation has participated in all of the olympic games?
select noc, count(distinct games) as no_of_participation from OLYMPICS_HISTORY group by 1
having count(distinct games) = (select count(distinct games) from OLYMPICS_HISTORY);

# 6. Identify the sport which was played in all summer olympics.
select sport, count(distinct games) as no_of_played from OLYMPICS_HISTORY 
where games like '%Summer' group by 1
having count(distinct games) = 
(select count(distinct games) from OLYMPICS_HISTORY where games like '%Summer');

# 7. Which Sports were just played only once in the olympics?
with t0 as
(select distinct sport, games from OLYMPICS_HISTORY),
t1 as
(select sport, count(games) as no_of_games from t0 group by 1)
select t0.sport, t0.games, no_of_games from t0 inner join t1 on t0.sport = t1.sport 
where no_of_games = 1 order by 1,2;

# 8. Fetch the total no of sports played in each olympic games.
select games, count(distinct sport) as no_of_sport from OLYMPICS_HISTORY group by 1;

# 9. Fetch details of the oldest athletes to win a gold medal.
with t0 as
(select * from OLYMPICS_HISTORY where medal = 'Gold' and age <> 'NA'),
t1 as
(select t0.*, 
rank() over(order by age desc) as ranking
from t0)
select * from t1 where ranking = 1;

# 10. Find the Ratio of male and female athletes participated in all olympic games.
with t0 as 
(
select sex, count(1) as cnt from OLYMPICS_HISTORY group by 1
),
male as
(
select cnt as m from t0 where sex = 'M'
 ), 
female as
(
select cnt as f from t0 where sex = 'F'
)
select 'M : F' as title, concat('1 : ', round(m/f,2)) as ratio from male, female;

# 11. Fetch the top 5 athletes who have won the most gold medals.
with t0 as 
(select name, count(medal) total_gold_medal from OLYMPICS_HISTORY where medal = 'Gold' group by 1), 
t1 as
(select t0.*, 
dense_rank() over(order by total_gold_medal desc) ranking from t0)
select name, total_gold_medal from t1 where ranking <= 5;

# 12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze)
with t0 as 
(select name, count(medal) total_medal from OLYMPICS_HISTORY where medal <> 'NA' group by 1), 
t1 as
(select t0.*, 
dense_rank() over(order by total_medal desc) ranking from t0)
select name, total_medal from t1 where ranking <= 5;

# 13. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
with t0 as 
(select team, count(medal) total_medal from OLYMPICS_HISTORY where medal <> 'NA' group by 1), 
t1 as
(select t0.*, 
dense_rank() over(order by total_medal desc) ranking from t0)
select team, total_medal from t1 where ranking <= 5;

# 14. List down total gold, silver and broze medals won by each country.
select t1.region, 
count(if(medal='Gold', 1, null)) as Gold, 
count(if(medal='Silver', 1, null)) as Silver, 
count(if(medal='Bronze', 1, null)) as Bronze, 
count(medal) as no_of_medals
from OLYMPICS_HISTORY as t0
inner join OLYMPICS_HISTORY_NOC_REGIONS as t1
on t0.noc = t1.noc
where medal <> 'NA' group by 1 order by 5 desc;

# 15. List down total gold, silver and broze medals won by each country 
# corresponding to each olympic games.
select games, region, 
count(if(medal='Gold', 1, null)) Gold, 
count(if(medal='Silver', 1, null)) Silver, 
count(if(medal='Bronze', 1, null)) Bronze, 
count(medal) no_of_medals
from OLYMPICS_HISTORY t0
inner join OLYMPICS_HISTORY_NOC_REGIONS t1
on t0.noc = t1.noc
where medal <> 'NA' group by 1,2 order by 1 asc;

# 16. Identify which country won the most gold, most silver and most bronze medals 
# in each olympic games.
with t0 as 
(select games, noc, 
count(if(medal='Gold', 1, null)) Gold,
count(if(medal='Silver', 1, null)) Silver,
count(if(medal='Bronze', 1, null)) Bronze,
count(medal) no_of_medals
from OLYMPICS_HISTORY
where medal <> 'NA' group by 1,2 order by 1 asc), 

t1 as
(select t0.*, 
first_value(noc) over(partition by games order by gold desc) gold_country,
first_value(noc) over(partition by games order by silver desc) silver_country, 
first_value(noc) over(partition by games order by bronze desc) bronze_country, 
first_value(gold) over(partition by games order by gold desc) gold_no, 
first_value(silver) over(partition by games order by silver desc) silver_no, 
first_value(bronze) over(partition by games order by bronze desc) bronze_no 
from t0)
select distinct games, concat(gold_country, ' - ', gold_no) as most_gold, 
concat(silver_country, ' - ', silver_no) as most_silver, 
concat(bronze_country, ' - ', bronze_no) as most_bronze
from t1;

# 17. Identify which country won the most gold, most silver, 
# most bronze medals and the most medals in each olympic games.
with t0 as 
(select games, noc, 
count(if(medal='Gold', 1, null)) Gold,
count(if(medal='Silver', 1, null)) Silver,
count(if(medal='Bronze', 1, null)) Bronze,
count(medal) no_of_medals
from OLYMPICS_HISTORY
where medal <> 'NA' group by 1,2 order by 1 asc), 

t1 as
(select t0.*, 
first_value(noc) over(partition by games order by gold desc) gold_country,
first_value(noc) over(partition by games order by silver desc) silver_country, 
first_value(noc) over(partition by games order by bronze desc) bronze_country,
first_value(noc) over(partition by games order by no_of_medals desc) total_medals_country, 
first_value(gold) over(partition by games order by gold desc) gold_no, 
first_value(silver) over(partition by games order by silver desc) silver_no, 
first_value(bronze) over(partition by games order by bronze desc) bronze_no, 
first_value(no_of_medals) over(partition by games order by no_of_medals desc) total_medals_no 
from t0)
select distinct games, concat(gold_country, ' - ', gold_no) as most_gold, 
concat(silver_country, ' - ', silver_no) as most_silver, 
concat(bronze_country, ' - ', bronze_no) as most_bronze, 
concat(total_medals_country, ' - ', total_medals_no) as most_medals
from t1;

# 18. Which countries have never won gold medal but have won silver/bronze medals?
with t0 as
(select region, 
sum(if(medal='Gold', 1, null)) sum_gold,
sum(if(medal='Silver', 1, null)) sum_silver, 
sum(if(medal='Bronze', 1, null)) sum_bronze 
from OLYMPICS_HISTORY a
inner join OLYMPICS_HISTORY_NOC_REGIONS b
on a.noc = b.noc
where medal <> 'NA' group by 1 order by 1) 
select * from t0 where sum_gold is null and (sum_silver is null or sum_silver > 0) 
and (sum_bronze is null or sum_bronze > 0);

# 19.  In which Sport/event, India has won highest medals.
select region, sport, count(medal) no_of_medals from OLYMPICS_HISTORY a
inner join OLYMPICS_HISTORY_NOC_REGIONS b
on a.noc = b.noc
where medal <> 'NA'
group by 1, 2 
having region = 'India'
order by 3 desc limit 1;

# 20. Break down all olympic games where India won medal for Hockey 
# and how many medals in each olympic games

select noc, games, count(medal) no_of_medal from OLYMPICS_HISTORY
where medal <>'NA' and noc = 'IND' and games in
(select games
from OLYMPICS_HISTORY
where noc = 'IND' and medal <> 'NA' and sport = 'Hockey')
group by 1,2 order by 2 asc;