select * 
from 
(select concat(a.act_fname, ' ', a.act_lname) as full_act_name, a.act_gender, mc.role, 
	m.mov_title, m.mov_year, m.mov_time, m.mov_lang, m.mov_dt_rel, m.mov_rel_country, g.gen_title,
	r.rev_stars, concat(d.dir_fname, ' ', d.dir_lname) as full_dir_name
from actor as a
inner join movie_cast as mc
using (act_id)
inner join movie as m
using (mov_id)
inner join movie_genres as mg
using (mov_id)
inner join genres as g
using (gen_id)
inner join rating as r
using (mov_id)
inner join movie_direction as md
using (mov_id)
inner join director as d
using (dir_id)
group by mov_id) as gabung
where rev_stars = 
(select max(rev_stars) 
from rating);