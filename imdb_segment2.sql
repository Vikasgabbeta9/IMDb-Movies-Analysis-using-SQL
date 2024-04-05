-- Segment 2: Movie Release Trends
-- 1.Determine the total number of movies released each year and analyse the month-wise trend.
	  select year,count(id) as total_movies from movies_imdb
      group by year;
	  select year,substr(date_published,6,2) as month,count(id) as total_movies
      from movies_imdb
      group by year,month
      order by year,month;
-- 2.Calculate the number of movies produced in the USA or India in the year 2019.
	  select count(*) from movies_imdb
      where (country='USA' or country='INDIA') and year=2019;