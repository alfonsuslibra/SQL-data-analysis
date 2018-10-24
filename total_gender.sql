SELECT act_gender, COUNT(act_gender) AS total_gender
FROM 
(SELECT CONCAT(a.act_fname, ' ', a.act_lname) AS full_act_name, a.act_gender, mc.role, 
	m.mov_title, m.mov_year, m.mov_time, m.mov_lang, m.mov_dt_rel, m.mov_rel_country, g.gen_title,
	r.rev_stars, CONCAT(d.dir_fname, ' ', d.dir_lname) AS full_dir_name
	FROM actor AS a
	INNER JOIN movie_cast AS mc USING (act_id)
	INNER JOIN movie AS m USING (mov_id)
	INNER JOIN movie_genres AS mg USING (mov_id)
	INNER JOIN genres AS g USING (gen_id)
	INNER JOIN rating AS r USING (mov_id)
	INNER JOIN movie_direction AS md USING (mov_id)
	INNER JOIN director AS d USING (dir_id)
	GROUP BY mov_id) AS gabung
GROUP BY act_gender;