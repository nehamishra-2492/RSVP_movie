USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each director_mappingable of the schema?
-- Type your code below:
-- Queries required to be solved
	--  total no. of rows present in each table of the schema
    
SELECT 
    COUNT(*) AS `director_mapping_count`
FROM
    director_mapping;

SELECT 
    COUNT(*) AS `genre_count`
FROM
    genre;

SELECT 
    COUNT(*) AS `movie_count`
FROM
    movie;

SELECT 
    COUNT(*) AS `names_count`
FROM
    names;

SELECT 
    COUNT(*) AS `ratings_count`
FROM
    ratings;

SELECT 
    COUNT(*) AS `role_mapping_count`
FROM
    role_mapping;
    
/* 
-- total no. of rows in `role_mapping_count` = 15615
-- total no. of rows in `director_mapping_count` = 3867
-- total no. of rows in `genre_count` = 14662
-- total no. of rows in `movie_count` = 7997
-- total no. of rows in `names_ count` = 25735
-- total no. of rows in `ratings_count` = 7997
-- total no. of rows in `role_mapping_count` = 15615
*/







-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
    SUM(CASE
        WHEN title IS NULL THEN 1
        ELSE 0
    END) AS title_NULL_COUNT,
    SUM(CASE
        WHEN year IS NULL THEN 1
        ELSE 0
    END) AS year_NULL_COUNT,
    SUM(CASE
        WHEN date_published IS NULL THEN 1
        ELSE 0
    END) AS date_published_NULL_COUNT,
    SUM(CASE
        WHEN duration IS NULL THEN 1
        ELSE 0
    END) AS duration_NULL_COUNT,
    SUM(CASE
        WHEN country IS NULL THEN 1
        ELSE 0
    END) AS country_NULL_COUNT,
    SUM(CASE
        WHEN worlwide_gross_income IS NULL THEN 1
        ELSE 0
    END) AS worlwide_gross_income_NULL_COUNT,
    SUM(CASE
        WHEN languages IS NULL THEN 1
        ELSE 0
    END) AS languages_NULL_COUNT,
    SUM(CASE
        WHEN production_company IS NULL THEN 1
        ELSE 0
    END) AS production_company_NULL_COUNT
FROM
    movie;  

/* 
Since ID is primary key so we cannot insert Null values so its not necessary to find null values for id
title, year, date_published, duration have NO NULL values
country , worldwide_gross_income, languages, production_company have NULL VALUES as follows
Country = 20
worldwide_gross= 3724
languages = 194
Production company = 528
*/








-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- 1st part
SELECT `year`      AS 'Year',
       COUNT(`id`) AS 'number_of_movies'
FROM   `movie`
GROUP  BY `year`
ORDER  BY `year`;

-- Highest number of movies released in 2017

SELECT MONTH(`date_published`) AS month_num,
       COUNT(`id`)             AS 'number_of_movies'
FROM   `movie`
GROUP  BY month_num
ORDER  BY month_num;

-- Highest no. of movies produced in March



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT `year`,
       COUNT(`id`) AS number_of_movies
FROM   `movie`
WHERE  `year` = 2019
       AND ( `country` LIKE '%India%'
              OR `country` LIKE '%USA%' ); 
	
-- 1059 movies are produced in the year 2019 in INDIA and USA
	

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT ( `genre` ) AS 'Genre'
FROM   `movie` AS m
       INNER JOIN `genre` AS g
               ON g.`movie_id` = m.`id`
WHERE  `year` = 2019
       AND `country` IN ( 'India', 'USA' ); 
        


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,
       COUNT(`id`) AS 'number_of_movies'
FROM   `movie` AS m
       INNER JOIN `genre` AS g
               ON g.`movie_id` = m.`id`
GROUP  BY `genre`
ORDER  BY `number_of_movies` DESC; 


-- Genre Drama produces the highest number of movies that is 4285




/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH movies_with_one_genre
AS
  (
           SELECT   `movie_id`
           FROM     `genre`
           GROUP BY `movie_id`
           HAVING   count(DISTINCT `genre`) = 1)
  SELECT count(*) AS movies_with_one_genre
  FROM   movies_with_one_genre;

-- 3289 movies belong to only one genre





/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT `g`.`genre`,
       ROUND(AVG(`m`.`duration`), 2) AS avg_duration
FROM   `movie` AS m
       INNER JOIN `genre` AS g
               ON `m`.`id` = `g`.`movie_id`
GROUP  BY `genre`
ORDER  BY avg_duration; 

-- Action has the highest avg_duration of 112.88 minutes followed by Romance, Crime, Drama
-- Horror has the least avg_duration of 92.72 minutes
-- Drama has avg_duration of 106.77 minutes



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


WITH genre_summary
     AS (SELECT genre                              AS genre,
                Count(movie_id)                    AS movie_count,
                RANK()
                  OVER(
                    ORDER BY Count(movie_id) DESC) AS genre_rank
         FROM   genre
         GROUP  BY genre)
SELECT *
FROM   genre_summary
WHERE  genre = "thriller"; 

-- Genre 'thriller' lies among the top 3 genre with movie count of 1484


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
-- Using Max() and Min() 

SELECT MIN(avg_rating)    AS min_avg_rating,
       MAX(avg_rating)    AS max_avg_rating,
       MIN(total_votes)   AS min_total_votes,
       MAX(total_votes)   AS max_total_votes,
       MIN(median_rating) AS min_median_rating,
       MAX(median_rating) AS max_median_rating
FROM   ratings;



    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

-- Finding the rank and dense rank of the query using 'LIMIT'clause
-- Displaying the top 10 movies based on avg_rating

SELECT     title,
           avg_rating,
           RANK() over(ORDER BY avg_rating DESC)       AS movie_rank,
           dense_rank() over(ORDER BY avg_rating DESC) AS movie_dense_rank
FROM       ratings                                     AS r
INNER JOIN movie                                       AS m
ON         m.id = r.movie_id
LIMIT      10;

-- Fan has the avg_rating of 9.6


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       COUNT(movie_id)      AS movie_count
FROM   movie                AS m
       INNER JOIN ratings   AS r
               ON m.id = r.movie_id
GROUP  BY median_rating
ORDER  BY movie_count DESC; 

-- movie with median_rating 7 has the highest movie_count of 2257


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH production_company_hit_movie_summary
     AS (SELECT production_company,
                Count(movie_id)                    AS movie_count,
                RANK()
                  OVER(
                    ORDER BY Count(movie_id) DESC) AS prod_company_rank,
                DENSE_RANK()
                  OVER(
                    ORDER BY Count(movie_id) DESC) AS prod_company_dense_rank
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   production_company_hit_movie_summary
WHERE  prod_company_rank = 1; 

-- The production companies are'Dream Warrior Picture' or 'National Theatre Live'


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT genre,
       COUNT(m.id) AS movie_count
FROM   movie AS m
       INNER JOIN genre AS g
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON r.movie_id = m.id
WHERE  MONTH(date_published) = 3
       AND year = 2017
       AND country LIKE '%USA%'
       AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC;
-- Genre Drama has 24 movies during March 2017 and have voting more than 1000
-- top 3 genre : Drama, Comedy, Action

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT title,
       avg_rating,
       genre
FROM   movie AS m
       INNER JOIN genre AS g
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON r.movie_id = m.id
WHERE  title LIKE "the%"
       AND avg_rating > 8
GROUP  BY title
ORDER  BY avg_rating DESC; 

-- There are 8  movies starting with 'The'
-- The Brigton Miracle has the highest avg_rating of 9.5





-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT median_rating,
       COUNT(*) AS movie_count
FROM   movie AS m
       INNER JOIN ratings AS r
               ON r.movie_id = m.id
WHERE  date_published BETWEEN '2018-04-01' AND '2019-04-01'
       AND median_rating = 8
GROUP  BY median_rating
ORDER  BY movie_count; 

-- movie published within 1 year between 1st April 2018 and 1st APril 2019 with median_rating = 8 is 361


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT `m`.`languages` AS 'Language',
       `r`.`total_votes`
FROM   movie m
       INNER JOIN ratings r
               ON `r`.`movie_id` = `m`.`id`
WHERE  languages IN ( 'German', 'Italian' )
GROUP  BY `m`.`languages`
ORDER  BY `r`.`total_votes` DESC; 

-- Yes german movies has more votes than Italian movies. German movies has 4695 votes where as Italian movies has 1684 votes only




-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT SUM(CASE
             WHEN `name` IS NULL THEN 1
             ELSE 0
           end) AS name_nulls,
       SUM(CASE
             WHEN `height` IS NULL THEN 1
             ELSE 0
           end) AS height_nulls,
       SUM(CASE
             WHEN `date_of_birth` IS NULL THEN 1
             ELSE 0
           end) AS date_of_birth_nulls,
       SUM(CASE
             WHEN `known_for_movies` IS NULL THEN 1
             ELSE 0
           end) AS known_for_movies_nulls
FROM   `names`; 

-- Height, Date of Birth, known for movies have null values



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_three_genre
AS
  (
             SELECT     `genre`,
                        count(`m`.`id`)                              AS movie_count,
                        rank() over( ORDER BY count(`m`.`id`) DESC ) AS genre_rank
             FROM       `movie`                                      AS m
             INNER JOIN `genre`                                      AS g
             ON         `g`.`movie_id` = `m`.`id`
             INNER JOIN `ratings` AS r
             ON         `r`.`movie_id` = `m`.`id`
             WHERE      `avg_rating` > 8
             GROUP BY   `genre`
             LIMIT      3 )
  SELECT     n.name             AS director_name,
             count(d.movie_id)  AS movie_count
  FROM       `director_mapping` AS d
  INNER JOIN `genre` g
  USING      (`movie_id`)
  INNER JOIN `names` AS n
  ON         `n`.`id` = `d`.`name_id`
  INNER JOIN `top_three_genre`
  USING      (`genre`)
  INNER JOIN `ratings`
  USING      (`movie_id`)
  WHERE      `avg_rating` > 8
  GROUP BY   `name`
  ORDER BY   `movie_count` DESC
  LIMIT      3;

-- James Mangold, Anthony Russo and Soubin Shahir are the top 3 directors with 4,3,3 movie count respectively





/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT DISTINCT `n`.`name`            AS actor_name,
                Count(`r`.`movie_id`) AS movie_count
FROM   `ratings` AS r
       INNER JOIN `role_mapping` AS rm
               ON `rm`.`movie_id` = `r`.`movie_id`
       INNER JOIN `names` AS n
               ON `rm`.`name_id` = `n`.`id`
WHERE  `median_rating` >= 8
       AND `category` = 'actor'
GROUP  BY `n`.`name`
ORDER  BY `movie_count` DESC
LIMIT  2; 
 
 -- Top 2 actors are Mammootty and Mohanlal



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT     `m`.`production_company`,
           Sum(`r`.`total_votes`)                                  AS vote_count,
           Dense_rank() over(ORDER BY sum(`r`.`total_votes`) DESC) AS prod_comp_rank
FROM       `movie`                                                 AS m
INNER JOIN `ratings`                                               AS r
ON         `m`.`id` = `r`.`movie_id`
GROUP BY   `m`.`production_company`
LIMIT      3;

-- Top 3 production houses are Marvel Studios, Twentieth Century Fox, Warner Bros





/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT     `name` AS actor_name,
           `r`.`total_votes`,
           Count(`m`.`id`)                                                              AS movie_count,
           Round(Sum(`r`.`avg_rating` * `r`.`total_votes`) / Sum(`r`.`total_votes`), 2) AS actor_avg_rating,
           Rank() over(ORDER BY `avg_rating` DESC)                                      AS actor_rank
FROM       movie                                                                        AS m
INNER JOIN ratings                                                                      AS r
ON         `m`.`id` = `r`.`movie_id`
INNER JOIN role_mapping AS `r_m`
ON         `m`.`id` = `r_m`.`movie_id`
INNER JOIN names AS n
ON         `r_m`.`name_id` = n.`id`
WHERE      `r_m`.`category` = 'actor'
AND        m.country = 'India'
GROUP BY   `n`.`name`
HAVING     count(`m`.`id`) >= 5
LIMIT      1;


-- Vijay Sethupathi is the top actor







-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT     `nm`.`name` AS actress_name,
           `r`.`total_votes`,
           COUNT(m.id)                                                                   AS movie_count,
           ROUND( SUM(`r`.`avg_rating` * `r`.`total_votes`)/ SUM(`r`.`total_votes`), 2 ) AS actress_avg_rating,
           RANK() over( ORDER BY `r`.`avg_rating` DESC )                                 AS actress_rank
FROM       `movie`                                                                       AS m
INNER JOIN `ratings`                                                                     AS r
ON         `m`.`id` = `r`.`movie_id`
INNER JOIN `role_mapping` AS rm
ON         `m`.`id` = `rm`.`movie_id`
INNER JOIN `names` AS nm
ON         `rm`.`name_id` = `nm`.`id`
WHERE      `rm`.`category` = 'actress'
AND        `m`.`country` = 'India'
AND        `m`.`languages` = 'Hindi'
GROUP BY   `nm`.`name`
HAVING     count(`m`.`id`) >= 3
LIMIT      1;
-- Taapsee Pannu  is rank 1 actress with average_rating  of 7.74


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT `m`.`title`      AS 'Movie',
       `m`.`languages`,
       CASE
         WHEN `r`.`avg_rating` > 8 THEN 'Superhit movies'
         WHEN `r`.`avg_rating` BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN `r`.`avg_rating` BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       end              AS 'Review',
       `r`.`avg_rating` AS 'Rating'
FROM   `movie` AS m
       INNER JOIN `genre` AS g
               ON `g`.`movie_id` = `m`.`id`
       INNER JOIN `ratings` AS r
               ON `r`.`movie_id` = `m`.`id`
WHERE  `g`.`genre` = 'Thriller'; 










/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT     `g`.`genre`,
           ROUND(AVG(`m`.`duration`),2)                                                          AS avg_duration,
           SUM(ROUND(AVG(`m`.`duration`),2)) over(ORDER BY `g`.`genre` rows unbounded preceding) AS running_total_duration,
           avg(round(avg(`m`.`duration`),2)) over(ORDER BY `g`.`genre` rows 10 preceding)        AS moving_avg_duration
FROM       movie                                                                                 AS m
INNER JOIN genre                                                                                 AS g
ON         m.id= g.movie_id
GROUP BY   `g`.`genre`
ORDER BY   `g`.`genre`;






-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_3_genre
AS
  (
             SELECT     `g`.`genre`,
                        count(`movie_id`) AS number_of_movies
             FROM       `genre`           AS g
             INNER JOIN `movie`           AS m
             ON         `g`.`movie_id` = `m`.`id`
             GROUP BY   `g`.`genre`
             ORDER BY   count(`movie_id`) DESC
             LIMIT      3 ),
  top_5
AS
  (
             SELECT     `g`.`genre`,
                        `m`.`year`,
                        `m`.`title` AS movie_name,
                        `m`.`worlwide_gross_income`,
                        dense_rank() over(partition BY `m`.`year` ORDER BY `m`.`worlwide_gross_income` DESC) AS movie_rank
             FROM       `movie`                                                                              AS m
             INNER JOIN `genre`                                                                              AS g
             ON         `g`.`movie_id` =`m`.`id`
             WHERE      `g`.`genre` IN
                        (
                               SELECT genre
                               FROM   top_3_genre) )
  SELECT *
  FROM   `top_5`
  WHERE  `movie_rank` <= 5;








-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH production_company_summary
AS
  (
             SELECT     production_company,
                        count(*) AS movie_count
             FROM       movie    AS m
             INNER JOIN ratings  AS r
             ON         m.id = r.movie_id
             WHERE      median_rating >= 8
             AND        production_company IS NOT NULL
             AND        position(',' IN languages)> 0
             GROUP BY   production_company
             ORDER BY   movie_count DESC )
  SELECT   *,
           rank() over(ORDER BY 'movie_rank' DESC) AS prod_comp_rank
  FROM     production_company_summary
  LIMIT    2;

-- Star cinema and Twentieth Century Fox are top two that gave hits in multilingual movies
     
-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT     `n`.`name`,
           SUM(`r`.`total_votes`) AS total_votes,
           COUNT(`rm`.`movie_id`) AS movie_count,
           `r`.`avg_rating`,
           DENSE_RANK() over(ORDER BY `r`.`avg_rating` DESC) AS actress_rank
FROM       names                                             AS n
INNER JOIN role_mapping                                      AS rm
ON         `n`.`id` = `rm`.`name_id`
INNER JOIN ratings AS r
ON         `r`.`movie_id` = `rm`.`movie_id`
INNER JOIN genre AS g
ON         `r`.`movie_id` = `g`.`movie_id`
WHERE      `rm`.`category` = 'actress'
AND        `g`.`genre` = 'Drama'
AND        `r`.`avg_rating` > 8
GROUP BY   `n`.`name`
LIMIT      3;







/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_date_published_summary
AS
  (
             SELECT     d.name_id,
                        name,
                        d.movie_id,
                        duration,
                        r.avg_rating,
                        total_votes,
                        m.date_published,
                        lead(date_published,1) over(partition BY d.name_id ORDER BY date_published, movie_id) AS next_date_published
             FROM       director_mapping                                                                      AS d
             INNER JOIN names                                                                                 AS n
             ON         n.id= d.name_id
             INNER JOIN movie AS m
             ON         m.id = d.movie_id
             INNER JOIN ratings AS r
             ON         r.movie_id = m.id ),top_director_summary
AS
  (
         SELECT *,
                datediff(next_date_published, date_published) AS date_difference
         FROM   next_date_published_summary)
  SELECT   name_id                  AS director_id,
           name                     AS director_name,
           count(movie_id)          AS number_of_movies,
           round(avg(avg_rating),2) AS avg_inter_movies_days,
           sum(total_votes)         AS total_votes,
           min(avg_rating)          AS min_rating,
           max(avg_rating)          AS max_rating,
           sum(duration)            AS total_duration
  FROM     top_director_summary
  GROUP BY director_id
  ORDER BY count(movie_id) DESC
  LIMIT    9;





