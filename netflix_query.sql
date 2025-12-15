-- NetFlix Project 

-- Table Creation
drop table if exists netflix;
create table netflix (
	show_id varchar(10),
	type varchar(10),
	title varchar(150),
	director varchar(208),
	casts varchar(1000),
	country varchar(150),
	date_added varchar(50),
	release_year int,
	rating varchar(10),
	duration varchar(15),
	listed_in varchar(100),
	description varchar(250)
);

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- Verify the data 
select * from netflix;
select count(*) from netflix;

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- 1. Count the Number of Movies vs TV Shows
select 
type , count(*) as total_count
from netflix
group by type;

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- 2. Find the Most common Rating for Movies and TV Show 
select 
type,
rating
from
	(select 
	type,
	rating,
	count(*) as total_count,
	rank() over(partition by type  order by count(*) desc) as ranking
	from netflix
	group by 1,2
	order by 1,3 desc
) as t2
where ranking = 1;

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- 3. List All Movies Released in a Specific Year (e.g., 2020)
select 
show_id , type , title , release_year
from netflix
where release_year = 2020 and type = 'Movie';

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- 4. Find the Top 5 Countries with the Most Content on Netflix

select 
trim(unnest(string_to_array(country,','))) as new_country,
count(*) as total_release
from netflix
group by 1 
order by 2 desc
limit 5;

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- 5. Identify the Longest Movie
select * from netflix
where
type='Movie' and
duration = (select max(duration) from netflix);

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- 6. Find Content Added in the Last 5 Years
select 
*
from netflix
where to_date(date_added , 'Month DD, YYYY') >= current_date - interval '5 years';

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
select *
from (
	select * ,
	unnest(string_to_array(director , ',')) as seperate_directors
	from netflix
) where seperate_directors = 'Rajiv Chilaka';

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- 8. List All TV Shows with More Than 5 Seasons
select title,type,duration
from netflix
where type = 'TV Show' and
split_part(duration , ' ' , 1)::numeric > 5;

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- 9. Count the Number of Content Items in Each Genre
select
unnest(string_to_array(listed_in , ',')) as Genre,
count(show_id) as content_number
from netflix
group by 1;

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- 10. Find each year  the average numbers of content release in India on netflix and return top 5 year with highest avg content release!
select 
extract (year from (to_date(date_added, 'Month DD, YYYY'))) as released_year ,
count(*) , 
round(count(*) :: numeric / (select count(*) from netflix where country = 'India') :: numeric * 100 , 2 ) as avg_content
from netflix
where country like '%India%'
group by 1;

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- 11. List All Movies that are Documentaries
select * 
from netflix
where listed_in like '%Documentaries%';

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- 12. Find All Content Without a Director
select * 
from netflix
where director is null

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 15 Years
select * 
from netflix
where casts ilike '%Salman Khan%' and 
release_year > extract (year from current_date) - 15;

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
select 
unnest(string_to_array(casts , ',')) as casts_updated,
count(*) as total_movies
from netflix
where country like '%India%'
group by 1
order by 2 desc
limit 10

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

-- 15.  Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords.
-- Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.
select 
case
	when description ilike '%kill%' or description ilike '%violence' then 'Bad_Content'
	else 'Good Content'
end category_create,
count(*) as total_count
from netflix
group by 1
























































