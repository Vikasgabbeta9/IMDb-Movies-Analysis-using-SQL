--     Segment 6: Broader Understanding of Data
--	1.Classify thriller movies based on average ratings into different categories.
	  select title,avg_rating,case when avg_rating>8 then 'Hit Movie'
      when avg_rating<=4 then 'Flop Movie' else 'Avg Movie' end as category
      from movies_imdb m left join ratings_imdb r on m.id=r.movie_id
      left join genre_imdb g on m.id=g.movie_id
      where genre='Thriller'
      
-- 2.analyse the genre-wise running total and moving average of the average movie duration.
	  select id,genre,duration,sum(duration) over(partition by genre order by id) as running_total,
      avg(duration) over(partition by genre order by id) as avg_duration from movies_imdb m
      left join genre_imdb g on m.id=g.movie_id;
-- 3.Identify the five highest-grossing movies of each year that belong to the top three genres.
	 with cte as(select genre from (select genre,row_number() over(order by count(movie_id) desc) as ranks
     from genre_imdb 
	 group by genre) a where ranks<=3),
     cte2 as (select * from(select title,genre,concat('$ ',worlwide_gross_income) as gross_income,year,row_number() over(partition by year order by worlwide_gross_income desc ) as top_movies
     from movies_imdb m left join genre_imdb g on m.id=g.movie_id
     where genre in (select genre from cte)
     ) b 
     )
      (select * from cte2 where top_movies<=5)
-- 4.Determine the top two production houses that have produced the highest number of hits among multilingual movies.
	  select * from (select production_company,count(id) total_hits,row_number() over(order by count(id) desc) as ranks
      from movies_imdb
      where languages like '%,%' and production_company !=''
      group by production_company)a
      where ranks<=2;
-- 5.Identify the top three actresses based on the number of Super Hit movies (average rating > 8) in the drama genre.
	  select* from (select name,count(m.id) as total_movie,avg(avg_rating) as rating ,row_number() over(order by (count(m.id)) desc) as ranks
      from  movies_imdb m left join ratings_imdb r on m.id=r.movie_id
      left join role_mapping_imdb rm on m.id=rm.movie_id
      left join names_imdb n on n.id=rm.name_id
      where category='actress' and avg_rating>8
      group by n.id,name) a
      where ranks<=3 
      
-- 6.Retrieve details for the top nine directors based on the number of movies, including average inter-movie duration, ratings, and more.
	 select * from (select name,n.id,count(m.id) as total_movies,avg(avg_rating),avg(duration),row_number() over(order by count(m.id) desc,avg(avg_rating) desc,avg(duration)desc) as ranks
      from movies_imdb m left join director_mapping_imdb dm on m.id=dm.movie_id
      left join names_imdb n on dm.name_id=n.id
      left join ratings_imdb r on m.id=r.movie_id
      where name is not null
      group by name,n.id) a
      where ranks <=9