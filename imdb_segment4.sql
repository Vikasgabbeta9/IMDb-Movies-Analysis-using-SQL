-- Segment 4: Ratings Analysis and Crew Members
-	1.Retrieve the minimum and maximum values in each column of the ratings table (except movie_id).
	  select max(avg_rating),min(avg_rating),
      max(total_votes),min(total_votes),
      max(median_rating),min(median_rating)
      from ratings_imdb;
      
-- 2.Identify the top 10 movies based on average rating.
	  select * from(select m.title,r.avg_rating,row_number() over(order by r.avg_rating desc) as ranks from ratings_imdb r
      join movies_imdb m on r.movie_id=m.id)s
      where ranks<=10;
      
      
--	3.Summarise the ratings table based on movie counts by median ratings.
	  select median_rating,count(movie_id)
      from ratings_imdb
      group by median_rating
      order by median_rating;
      
--	4.Identify the production house that has produced the most number of hit movies (average rating > 8).
	select * from (select production_company, count(id) as movie_count,
	row_number() over (order by count(id) desc) as ranks from movies_imdb
	left join ratings_imdb on movie_id=id
	where avg_rating>8 and production_company!=''
	group by production_company) a where ranks=1;
--	5.Determine the number of movies released in each genre during March 2017 in the USA with more than 1,000 votes.
	 select genre,count(id) as total_movies from movies_imdb
     left join genre_imdb g on g.movie_id=id
     left join ratings_imdb r on r.movie_id=id
     where total_votes>1000 and substr(date_published,6,2)='03' and year=2017
     and country='USA'
     group by genre
     order by genre;
--	6.Retrieve movies of each genre starting with the word 'The' and having an average rating > 8.
	  select genre,title,avg_rating
      from movies_imdb m left join genre_imdb g on m.id=g.movie_id
      left join ratings_imdb r on m.id=r.movie_id
      where title like 'The%'
      and avg_rating>8
      order by genre;