-- movie related information woked more than 5 movies
SELECT 	m.id MID, 
		CONCAT(a.first_name, ' ', a.last_name) Actor, 
		m.name Movie, 
		r.role Role, 
		m.year Year 
FROM	movies m, 
		actors a, 
		roles r, 
		movies_genres mg 
WHERE 	a.id = r.actor_id
		AND r.movie_id = m.id
		AND m.id = mg.movie_id
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