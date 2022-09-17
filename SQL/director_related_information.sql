-- director related information
SELECT 	m.id MID, 
		CONCAT(d.first_name, ' ', d.last_name) Director, 
		m.name Movie, 
		m.year Year 
FROM 	movies m, 
		directors d, 
		directors_genres dg, 
		movies_directors md
WHERE 	d.id = dg.director_id
		AND m.id = md.movie_id
		AND d.id = md.movie_id
		AND m.rank IS NOT NULL
		AND m.id IN (
			SELECT mid
			FROM (
				SELECT movie_id mid
				FROM movies_directors
				WHERE director_id IN (
					SELECT did
					FROM (
						SELECT 	director_id did, 
								COUNT(movie_id) cnt 
						FROM 	movies_directors 
						GROUP BY did
						HAVING 	cnt >= 5
					) D_cnt
				) 
			) D
			WHERE mid IN (
				SELECT movie_id mid
				FROM roles
				WHERE actor_id IN (
					SELECT aid
					FROM (
						SELECT 	actor_id aid, 
								COUNT(movie_id) cnt 
						FROM 	roles 
						GROUP BY aid 
						HAVING 	cnt >= 5
					) A_cnt
				)
			)
		);