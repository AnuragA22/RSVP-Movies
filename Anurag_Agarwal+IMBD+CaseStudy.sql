
USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
 
SHOW TABLES;

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- method 1

SELECT 
  TABLE_NAME as 'Table Name', 
  TABLE_ROWS as 'Number of Rows' 
FROM 
  INFORMATION_SCHEMA.TABLES 
WHERE 
  TABLE_SCHEMA = 'IMDB';
  
-- method 2

SELECT 
  COUNT(*) 
FROM 
  DIRECTOR_MAPPING;
SELECT 
  COUNT(*) 
FROM 
  GENRE;
SELECT 
  COUNT(*) 
FROM 
  MOVIE;
SELECT 
  COUNT(*) 
FROM 
  NAMES;
SELECT 
  COUNT(*) 
FROM 
  RATINGS;
SELECT 
  COUNT(*) 
FROM 
  ROLE_MAPPING;
  
-- numbers of rows in each table are as:
-- director_mapping  3867
-- genre  14662
-- movie  7102
-- names  22914
-- ratings  8230
-- role_mapping  16125


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
  SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS ID_nulls, 
  SUM(
    CASE WHEN title IS NULL THEN 1 ELSE 0 END
  ) AS title_nulls, 
  SUM(
    CASE WHEN year IS NULL THEN 1 ELSE 0 END
  ) AS year_nulls, 
  SUM(
    CASE WHEN date_published IS NULL THEN 1 ELSE 0 END
  ) AS date_published_nulls, 
  SUM(
    CASE WHEN duration IS NULL THEN 1 ELSE 0 END
  ) AS duration_nulls, 
  SUM(
    CASE WHEN country IS NULL THEN 1 ELSE 0 END
  ) AS country_nulls, 
  SUM(
    CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END
  ) AS worlwide_gross_income_nulls, 
  SUM(
    CASE WHEN languages IS NULL THEN 1 ELSE 0 END
  ) AS languages_nulls, 
  SUM(
    CASE WHEN production_company IS NULL THEN 1 ELSE 0 END
  ) AS production_company_nulls 
FROM 
  movie;
  
-- results for null values are as
-- country 20
-- worldwide gross income 3724
-- language 194
-- production company 528
-- ID, Title,Date publish & Duration have no null values

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 

-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year      |  number_of_movies|
+-------------------+----------------
|  2017    |  2134      |
|  2018    |    .      |
|  2019    |    .      |
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|  month_num  |  number_of_movies|
+---------------+----------------
|  1      |   134      |
|  2      |   231      |
|  .      |    .      |
+---------------+-------------------+ */
-- Type your code below:

-- Number of movies released each year.
SELECT 
  year, 
  COUNT(id) as number_of_movies 
FROM 
  movie 
GROUP BY 
  year;

-- 2017 highest number of movie release 3052
-- 2018 number of movies released 2944
-- 2019  number of movies relaesed 2001

-- Number of movies released each month.
SELECT 
  MONTH(date_published) AS month_num, 
  COUNT(id) AS number_of_movies 
FROM 
  movie 
GROUP BY 
  MONTH(date_published) 
ORDER BY 
  MONTH(date_published);
  
-- 824 highest number of movies were released in March
-- 438 least number of movies released in Dec

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/


-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
  Count(id) AS Movie_Count 
FROM 
  movie 
WHERE 
  year = 2019 
  AND country REGEXP 'USA|India';
  
-- Total 1059  movies were produced in 2019


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/


-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT 
  DISTINCT genre 
FROM 
  genre;
  
-- unique list of genres
-- Drama
-- Fantasy
-- Thriller
-- Comedy
-- Horror
-- Family
-- Romance
-- Adventure
-- Action
-- Sci-Fi
-- Crime
-- Mystery 
-- Others

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */


-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

WITH ranking AS (
  SELECT 
    genre, 
    COUNT(genre) AS movie_count, 
    RANK() OVER(
      ORDER BY 
        COUNT(genre) DESC
    ) AS genre_rank 
  FROM 
    genre 
  GROUP BY 
    genre 
  ORDER BY 
    movie_count DESC
) 
SELECT 
  genre, 
  movie_count 
FROM 
  ranking 
WHERE 
  genre_rank = 1;
-- Highest number of movies produced genre is Drama with 4285 count


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/


-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH movie_from_one_genre AS (
  SELECT 
    movie_id, 
    COUNT(genre) AS number_of_movies 
  FROM 
    genre 
  GROUP BY 
    movie_id 
  HAVING 
    number_of_movies = 1
) 
SELECT 
  COUNT(movie_id) AS number_of_movies 
FROM 
  movie_from_one_genre;
  
-- number of movies belong to one genre 3289


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/


-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre      |  avg_duration  |
+-------------------+----------------
|  thriller  |    105      |
|  .      |    .      |
|  .      |    .      |
+---------------+-------------------+ */
-- Type your code below:
SELECT 
  genre, 
  ROUND(
    AVG(duration), 
    2
  ) AS avg_duration 
FROM 
  genre AS g 
  INNER JOIN movie AS m ON g.movie_id = m.id 
GROUP BY 
  genre 
ORDER BY 
  AVG(duration) DESC;
  
-- Highest average duration is Action genre with 112.88
-- Drama average duration is 106.77


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/


-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre      |    movie_count  |    genre_rank    |  
+---------------+-------------------+---------------------+
|drama      |  2312      |      2      |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_rank AS (
  SELECT 
    genre, 
    COUNT(movie_id) AS movie_count, 
    RANK() OVER(
      ORDER BY 
        COUNT(movie_id) DESC
    ) AS genre_rank 
  FROM 
    genre 
  GROUP BY 
    genre
) 
SELECT 
  * 
FROM 
  genre_rank 
WHERE 
  genre = 'thriller';
  
-- Thriller, movie count is 1484 & genre rank is 3


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|  max_avg_rating  |  min_total_votes   |  max_total_votes    |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|    0    |      5    |         177      |     2000           |    0         |  8       |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
  ROUND(
    MIN(avg_rating)
  ) AS min_avg_rating, 
  ROUND(
    MAX(avg_rating)
  ) AS max_avg_rating, 
  ROUND(
    MIN(total_votes)
  ) AS min_total_votes, 
  ROUND(
    MAX(total_votes)
  ) AS max_total_votes, 
  ROUND(
    MIN(median_rating)
  ) AS min_median_rating, 
  ROUND(
    MAX(median_rating)
  ) AS max_median_rating 
FROM 
  ratings;
  
-- avg rating min/max 1.0/10.0
-- total votes min/max 100/725138
-- median rating min/max 1/10


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/


-- Q11. Which are the top 10 movies based on average rating?

/* Output format:
+---------------+-------------------+---------------------+
| title      |    avg_rating  |    movie_rank    |
+---------------+-------------------+---------------------+
| Fan      |    9.6      |      5        |
|  .      |    .      |      .      |
|  .      |    .      |      .      |
|  .      |    .      |      .      |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- It's ok if RANK() or DENSE_RANK() is used too

WITH ranking AS (
  SELECT 
    m.title AS title, 
    avg_rating, 
    DENSE_RANK() OVER(
      ORDER BY 
        avg_rating DESC
    ) AS movie_rank 
  FROM 
    ratings AS r 
    INNER JOIN movie AS m ON m.id = r.movie_id
) 
SELECT 
  * 
FROM 
  ranking 
WHERE 
  movie_rank <= 10;
  
-- Highest rating movie Kirket


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/


-- Q12. Summarise the ratings table based on the movie counts by median ratings.

/* Output format:

+---------------+-------------------+
| median_rating  |  movie_count    |
+-------------------+----------------
|  1      |    105      |
|  .      |    .      |
|  .      |    .      |
+---------------+-------------------+ */
-- Type your code below:

-- Order by is good to have

SELECT 
  median_rating, 
  COUNT(movie_id) AS movie_count 
FROM 
  ratings 
GROUP BY 
  median_rating 
ORDER BY 
  median_rating;
  
-- 2257 movie have median rating of 7


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/


-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??

/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count         |  prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers     |    1       |      1       |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
  production_company, 
  COUNT(id) AS movie_count, 
  DENSE_RANK() OVER(
    ORDER BY 
      COUNT(id) DESC
  ) AS prod_company_rank 
FROM 
  movie AS m 
  INNER JOIN ratings AS r ON m.id = r.movie_id 
WHERE 
  avg_rating > 8 
  AND production_company IS NOT NULL 
GROUP BY 
  production_company 
ORDER BY 
  movie_count DESC;
  
  
-- Dream Warrior Pictures produced the most hit movies follwed by National theatre live
-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both


-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?

/* Output format:

+---------------+-------------------+
| genre      |  movie_count    |
+-------------------+----------------
|  thriller  |    105      |
|  .      |    .      |
|  .      |    .      |
+---------------+-------------------+ */
-- Type your code below:

SELECT 
  genre, 
  Count(M.id) AS MOVIE_COUNT 
FROM 
  movie AS M 
  INNER JOIN genre AS G ON G.movie_id = M.id 
  INNER JOIN ratings AS R ON R.movie_id = M.id 
WHERE 
  year = 2017 
  AND Month(date_published) = 3 
  AND country LIKE '%USA%' 
  AND total_votes > 1000 
GROUP BY 
  genre 
ORDER BY 
  movie_count DESC;
  
-- Highest 24 movies in Drama genre released in March 2017


-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?

/* Output format:
+---------------+-------------------+---------------------+
| title      |    avg_rating  |    genre        |
+---------------+-------------------+---------------------+
| Theeran    |    8.3      |    Thriller    |
|  .      |    .      |      .      |
|  .      |    .      |      .      |
|  .      |    .      |      .      |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
  title, 
  avg_rating, 
  genre 
FROM 
  genre AS g 
  INNER JOIN ratings AS r ON g.movie_id = r.movie_id 
  INNER JOIN movie AS m ON m.id = g.movie_id 
WHERE 
  title LIKE 'The%' 
  AND avg_rating > 8 
ORDER BY 
  genre DESC;
  
-- The Brighton Miracle has highest average rating of 9.5.
-- Most movies are from Drama genre
-- 8 movies begin with 'The' in title


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.


-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below

SELECT 
  median_rating, 
  COUNT(movie_id) AS movie_count 
FROM 
  movie AS m 
  INNER JOIN ratings AS r ON m.id = r.movie_id 
WHERE 
  median_rating = 8 
  AND date_published BETWEEN '2018-04-01' 
  AND '2019-04-01' 
GROUP BY 
  median_rating;
  
  
-- 361 movies released BETWEEN '2018-04-01' AND '2019-04-01'with median rating of 8


-- Once again, try to solve the problem given below.


-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- method 1

SELECT 
  total_votes, 
  languages 
FROM 
  movie AS m 
  INNER JOIN ratings AS r ON m.id = r.movie_id 
WHERE 
  languages LIKE 'German' 
  OR languages LIKE 'Italian' 
GROUP BY 
  languages 
ORDER BY 
  total_votes DESC;
  
-- output vote 4695- German & 1684- Italian

-- method 2
(
  SELECT 
    'Italian' AS languages, 
    SUM(rat.total_votes) AS total_votes 
  FROM 
    movie AS mov 
    INNER JOIN ratings AS rat ON mov.id = rat.movie_id 
  WHERE 
    languages REGEXP 'italian'
) 
UNION ALL 
  (
    SELECT 
      'German' AS languages, 
      SUM(rat.total_votes) AS total_votes 
    FROM 
      movie AS mov 
      INNER JOIN ratings AS rat ON mov.id = rat.movie_id 
    WHERE 
      languages REGEXP 'german'
  );
-- output  vote counts German- 4421525 & Italian 2559540

-- yes  german movies got more votes in both the cases where on basis of Country or Language
-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/


-- Segment 3:

-- Q18. Which columns in the names table have null values??

/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls  |  height_nulls  |date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|    0    |      123    |         1234      |     12345         |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
  SUM(
    CASE WHEN name IS NULL THEN 1 ELSE 0 END
  ) AS name_nulls, 
  SUM(
    CASE WHEN height IS NULL THEN 1 ELSE 0 END
  ) AS height_nulls, 
  SUM(
    CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END
  ) AS date_of_birth_nulls, 
  SUM(
    CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END
  ) AS known_for_movies_nulls 
FROM 
  names;
  
-- Results are as
-- Height null 17335
-- Date of birth null 13431
-- Knmown for movies null 15226
-- Name null 0

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/


-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)

/* Output format:

+---------------+-------------------+
| director_name  |  movie_count    |
+---------------+-------------------|
|James Mangold  |    4      |
|  .      |    .      |
|  .      |    .      |
+---------------+-------------------+ */
-- Type your code below:

WITH genre_selection AS (
  WITH top_genre AS (
    SELECT 
      genre, 
      COUNT(title) AS movie_count, 
      RANK() OVER(
        ORDER BY 
          COUNT(title) DESC
      ) AS genre_rank 
    FROM 
      movie AS m 
      INNER JOIN ratings AS r ON r.movie_id = m.id 
      INNER JOIN genre AS g ON g.movie_id = m.id 
    WHERE 
      avg_rating > 8 
    GROUP BY 
      genre
  ) 
  SELECT 
    genre 
  FROM 
    top_genre 
  WHERE 
    genre_rank < 4
), 
top_directors AS (
  SELECT 
    n.name AS director_name, 
    COUNT(g.movie_id) AS movie_count, 
    RANK() OVER(
      ORDER BY 
        COUNT(g.movie_id) DESC
    ) AS director_rank 
  FROM 
    names AS n 
    INNER JOIN director_mapping AS dm ON n.id = dm.name_id 
    INNER JOIN genre AS g ON dm.movie_id = g.movie_id 
    INNER JOIN ratings r ON r.movie_id = g.movie_id, 
    genre_selection 
  WHERE 
    g.genre IN (genre_selection.genre) 
    AND avg_rating > 8 
  GROUP BY 
    director_name 
  ORDER BY 
    movie_count DESC
) 
SELECT 
  * 
FROM 
  top_directors 
WHERE 
  director_rank <= 3;
  
-- top 3 directors
-- Josh Oreck
-- Joe Russo
-- Anthony Russo

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/


-- Q20. Who are the top two actors whose movies have a median rating >= 8?

/* Output format:

+---------------+-------------------+
| actor_name  |  movie_count    |
+-------------------+----------------
|Christain Bale  |    10      |
|  .      |    .      |
+---------------+-------------------+ */
-- Type your code below:

WITH top_actor AS (
  SELECT 
    nm.name AS actor_name, 
    count(rtg.movie_id) AS movie_count, 
    RANK() over (
      ORDER BY 
        count(rtg.movie_id) DESC
    ) AS ranks 
  FROM 
    role_mapping AS role_map 
    INNER JOIN names AS nm ON nm.id = role_map.name_id 
    INNER JOIN ratings AS rtg ON role_map.movie_id = rtg.movie_id 
  WHERE 
    role_map.category = 'actor' 
    AND rtg.median_rating >= 8 
  GROUP BY 
    nm.name
) 
SELECT 
  actor_name, 
  movie_count 
FROM 
  top_actor 
WHERE 
  ranks <= 2;
  
-- Top 2 actors are Mammootty and Mohanlal

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/


-- Q21. Which are the top three production houses based on the number of votes received by their movies?

/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count      |    prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers    |    830      |    1          |
|  .        |    .      |      .      |
|  .        |    .      |      .      |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH prod_comp_rank AS (
  SELECT 
    mov.production_company, 
    SUM(rtg.total_votes) AS vote_count, 
    RANK() OVER (
      ORDER BY 
        SUM(rtg.total_votes) DESC
    ) AS prod_comp_rank_rating 
  FROM 
    movie AS mov 
    INNER JOIN ratings AS rtg ON rtg.movie_id = mov.id 
  GROUP BY 
    mov.production_company
) 
SELECT 
  * 
FROM 
  prod_comp_rank 
WHERE 
  prod_comp_rank_rating <= 3;
  
-- Top 3 production houses are
-- marvrl Studio tops the list and vote counts are 2656967
-- Twentieth Century Fox with vote counts 2411163
-- Warner Bros.with vote counts  2396057


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
| actor_name  |  total_votes    |  movie_count      |  actor_avg_rating    |actor_rank     |
+---------------+-------------------+---------------------+----------------------+-----------------+
|  Yogi Babu  |      3455  |         11      |     8.42           |    1         |
|    .    |      .    |         .      |     .           |    .         |
|    .    |      .    |         .      |     .           |    .         |
|    .    |      .    |         .      |     .           |    .         |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
  name AS actor_name, 
  SUM(total_votes) AS total_votes, 
  COUNT(m.id) AS movie_count, 
  ROUND(
    SUM(avg_rating * total_votes)/ SUM(total_votes), 
    2
  ) AS actor_avg_rating, 
  RANK() OVER(
    ORDER BY 
      SUM(avg_rating * total_votes)/ SUM(total_votes) DESC
  ) AS actor_rank 
FROM 
  movie AS m 
  INNER JOIN ratings AS r ON m.id = r.movie_id 
  INNER JOIN role_mapping AS rm ON m.id = rm.movie_id 
  INNER JOIN names AS n ON rm.name_id = n.id 
WHERE 
  category = 'actor' 
  AND country = 'india' 
GROUP BY 
  name 
HAVING 
  COUNT(m.id)>= 5;
  
-- Vijay Sethupathi is top actor with total votes 20364, movies 5 & average rating 8.42


-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name  |  total_votes    |  movie_count      |  actress_avg_rating    |actress_rank     |
+---------------+-------------------+---------------------+----------------------+-----------------+
|  Tabu    |      3455  |         11      |     8.42           |    1         |
|    .    |      .    |         .      |     .           |    .         |
|    .    |      .    |         .      |     .           |    .         |
|    .    |      .    |         .      |     .           |    .         |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_movie_count AS (
  SELECT 
    nm.name AS actress_name, 
    sum(total_votes) AS Total_votes, 
    count(mov.id) AS movie_count, 
    ROUND(
      SUM(rtg.avg_rating * Total_votes) / SUM(Total_votes), 
      2
    ) AS actress_avg_rating, 
    RANK() OVER(
      ORDER BY 
        SUM(rtg.avg_rating * Total_votes) / SUM(Total_votes) DESC
    ) AS actress_rank 
  FROM 
    role_mapping AS role_map 
    INNER JOIN names AS nm ON nm.id = role_map.name_id 
    INNER JOIN movie AS mov ON mov.id = role_map.movie_id 
    INNER JOIN ratings AS rtg ON mov.id = rtg.movie_id 
  WHERE 
    role_map.category = 'actress' 
    AND mov.languages REGEXP 'HINDI' 
    AND mov.country REGEXP 'INDIA' 
  GROUP BY 
    nm.name 
  HAVING 
    count(mov.id) >= 3
) 
SELECT 
  * 
FROM 
  actress_movie_count 
WHERE 
  actress_rank <= 5;
  
-- Top 5 Actress are
-- Taapsee Pannu rating 7.74
-- Kriti Sanon rating 7.05
-- Divya Dutta rating 6.88
-- Shraddha Kapoor rating 6.63
-- Kriti Kharbanda rating 4.80

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

      Rating > 8: Superhit movies
      Rating between 7 and 8: Hit movies
      Rating between 5 and 7: One-time-watch movies
      Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 
  title, 
  CASE WHEN avg_rating > 8 THEN 'Superhit movies' WHEN avg_rating BETWEEN 7 
  AND 8 THEN 'Hit movies' WHEN avg_rating BETWEEN 5 
  AND 7 THEN 'One-time-watch movies' WHEN avg_rating < 5 THEN 'Flop movies' END AS avg_rating_category 
FROM 
  movie AS m 
  INNER JOIN genre AS g ON m.id = g.movie_id 
  INNER JOIN ratings as r ON m.id = r.movie_id 
WHERE 
  genre = 'thriller';
  
-- sample of output
-- Dukun  One-time-watch movies
-- Back Roads  Hit movies
-- Countdown  One-time-watch movies
-- Staged Killer  Flop movies
-- Vellaipookal  Hit movies

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/


-- Segment 4:


-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 

/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre      |  avg_duration  |running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|  comdy    |      145    |         106.2    |     128.42         |
|    .    |      .    |         .      |     .           |
|    .    |      .    |         .      |     .           |
|    .    |      .    |         .      |     .           |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
  genre, 
  ROUND(
    AVG(duration), 
    2
  ) AS avg_duration, 
  SUM(
    ROUND(
      AVG(duration), 
      2
    )
  ) OVER(
    ORDER BY 
      genre ROWS UNBOUNDED PRECEDING
  ) AS running_total_duration, 
  AVG(
    ROUND(
      AVG(duration), 
      2
    )
  ) OVER(
    ORDER BY 
      genre ROWS 10 PRECEDING
  ) AS moving_avg_duration 
FROM 
  movie AS m 
  INNER JOIN genre AS g ON m.id = g.movie_id 
GROUP BY 
  genre 
ORDER BY 
  genre;
  
  
-- Sample output
-- genre|  avg_duration |running_total_duration|moving_avg_duration 
-- Action  112.88      112.88          112.880000
-- Adventure  101.87    214.75          107.375000
-- Comedy  102.62      317.37          105.790000


-- Round is good to have and not a must have; Same thing applies to sorting
-- Let us find top 5 movies of each year with top 3 genres.


-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre      |  year      |  movie_name      |worldwide_gross_income|movie_rank     |
+---------------+-------------------+---------------------+----------------------+-----------------+
|  comedy    |      2017  |         indian    |     $103244842       |    1         |
|    .    |      .    |         .      |     .           |    .         |
|    .    |      .    |         .      |     .           |    .         |
|    .    |      .    |         .      |     .           |    .         |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
-- Top 3 Genres based on most number of movies

WITH top_three_genre AS (
  SELECT 
    gen.genre, 
    count(mov.id), 
    RANK() OVER (
      ORDER BY 
        count(mov.id) DESC
    ) AS ranks 
  FROM 
    genre AS gen 
    INNER JOIN movie AS mov ON gen.movie_id = mov.id 
  GROUP BY 
    gen.genre
), 
top_three_genre_movies AS (
  SELECT 
    mo.id as movie_id, 
    ge.genre as genre, 
    YEAR(mo.date_published) AS year, 
    mo.title AS movie_name, 
    CAST(
      REPLACE(
        REPLACE(
          ifnull(mo.worlwide_gross_income, 0), 
          '$', 
          ''
        ), 
        'INR', 
        ''
      ) AS DECIMAL(20)
    ) AS worlwide_gross_income 
  FROM 
    movie AS mo 
    INNER JOIN genre AS ge ON ge.movie_id = mo.id 
  WHERE 
    ge.genre IN (
      SELECT 
        genre 
      FROM 
        top_three_genre 
      WHERE 
        ranks <= 3
    )
), 
rank_gross_income AS (
  SELECT 
    genre, 
    year, 
    movie_name, 
    worlwide_gross_income, 
    rank() over(
      partition by year 
      order by 
        worlwide_gross_income desc
    ) as movie_rank 
  FROM 
    top_three_genre_movies 
  GROUP BY 
    movie_id
) 
SELECT 
  * 
FROM 
  rank_gross_income 
where 
  movie_rank <= 5;
  
  -- Sample output
-- Thriller	2017	The Fate of the Furious	1236005118	1
-- Comedy	2017	Despicable Me 3	1034799409	2
-- Comedy	2017	Jumanji: Welcome to the Jungle	962102237	3
-- Drama	2017	Zhan lang II	870325439	4
-- Comedy	2017	Guardians of the Galaxy Vol. 2	863756051	5
  
-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.

-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?

/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count    |    prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers    |    830      |    1          |
|  .        |    .      |      .      |
|  .        |    .      |      .      |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH ranking AS (
  SELECT 
    production_company, 
    COUNT(m.id) AS movie_count, 
    RANK() OVER(
      ORDER BY 
        COUNT(id) DESC
    ) AS prod_comp_rank 
  FROM 
    movie AS m 
    INNER JOIN ratings AS r ON m.id = r.movie_id 
  WHERE 
    median_rating >= 8 
    AND production_company IS NOT NULL 
    AND POSITION(',' IN languages)> 0 
  GROUP BY 
    production_company
) 
SELECT 
  * 
FROM 
  ranking 
WHERE 
  prod_comp_rank < 3;
  
-- top 2 production houses
-- Star Cinema
-- Twentieth Century Fox


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name  |  total_votes    |  movie_count      |actress_avg_rating   |actress_rank     |
+---------------+-------------------+---------------------+----------------------+-----------------+
|  Laura Dern  |      1016  |         1      |     9.60           |    1         |
|    .    |      .    |         .      |     .           |    .         |
|    .    |      .    |         .      |     .           |    .         |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH ranking AS (
  SELECT 
    name AS actress_name, 
    SUM(total_votes) AS total_votes, 
    COUNT(m.id) AS movie_count, 
    ROUND(
      SUM(avg_rating * total_votes)/ SUM(total_votes), 
      2
    ) AS actress_avg_rating, 
    RANK() OVER(
      ORDER BY 
        COUNT(m.id) DESC
    ) AS actress_rank 
  FROM 
    genre AS g 
    INNER JOIN movie AS m ON g.movie_id = m.id 
    INNER JOIN ratings AS r ON m.id = r.movie_id 
    INNER JOIN role_mapping AS rm ON m.id = rm.movie_id 
    INNER JOIN names AS n ON rm.name_id = n.id 
  WHERE 
    genre = 'drama' 
    AND category = 'actress' 
    AND avg_rating > 8 
  GROUP BY 
    name
) 
SELECT 
  * 
FROM 
  ranking 
WHERE 
  actress_rank <= 3;
  
-- top 3 actress are
-- Parvathy Thiruvothu
-- Susan Brown
-- Amanda Lawrence


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
| director_id  |  director_name  |  number_of_movies  |  avg_inter_movie_days |  avg_rating  | total_votes  | min_rating  | max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967    |  A.L. Vijay    |      5      |         177       |     5.65      |  1754     |  3.7    |  6.9     |    613      |
|  .      |    .      |      .      |         .       |     .      |  .       |  .    |  .     |    .      |
|  .      |    .      |      .      |         .       |     .      |  .       |  .    |  .     |    .      |
|  .      |    .      |      .      |         .       |     .      |  .       |  .    |  .     |    .      |
|  .      |    .      |      .      |         .       |     .      |  .       |  .    |  .     |    .      |
|  .      |    .      |      .      |         .       |     .      |  .       |  .    |  .     |    .      |
|  .      |    .      |      .      |         .       |     .      |  .       |  .    |  .     |    .      |
|  .      |    .      |      .      |         .       |     .      |  .       |  .    |  .     |    .      |
|  .      |    .      |      .      |         .       |     .      |  .       |  .    |  .     |    .      |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH director_info AS (
  SELECT 
    dm.name_id, 
    n.name, 
    dm.movie_id, 
    r.avg_rating, 
    r.total_votes, 
    m.duration, 
    date_published, 
    Lag(date_published, 1) OVER(
      PARTITION BY dm.name_id 
      ORDER BY 
        date_published
    ) AS previous_date_published 
  FROM 
    names n 
    INNER JOIN director_mapping dm ON n.id = dm.name_id 
    INNER JOIN movie m ON dm.movie_id = m.id 
    INNER JOIN ratings r ON m.id = r.movie_id
), 
top_directors AS (
  SELECT 
    name_id AS director_id, 
    NAME AS director_name, 
    Count(movie_id) AS number_of_movies, 
    Round(
      Avg(
        Datediff(
          date_published, previous_date_published
        )
      )
    ) AS avg_inter_movie_days, 
    Round(
      sum(avg_rating * total_votes)/ sum(total_votes), 
      2
    ) AS avg_rating, 
    Sum(total_votes) AS total_votes, 
    Round(
      Min(avg_rating), 
      1
    ) AS min_rating, 
    Round(
      Max(avg_rating), 
      1
    ) AS max_rating, 
    Sum(duration) AS total_duration, 
    Rank() OVER(
      ORDER BY 
        Count(movie_id) DESC
    ) AS director_rank 
  FROM 
    director_info 
  GROUP BY 
    director_id
) 
SELECT 
  director_id, 
  director_name, 
  number_of_movies, 
  avg_inter_movie_days, 
  avg_rating, 
  total_votes, 
  min_rating, 
  max_rating, 
  total_duration 
FROM 
  top_directors 
WHERE 
  director_rank <= 9;
  
-- output sample
-- director_id	director_name	number_of_movies	avg_inter_movie_days	avg_rating	total_votes	min_rating	max_rating	total_duration 
-- nm1777967	A.L. Vijay			5						177					5.65	1754			3.7			6.9		613
-- nm2096009	Andrew Jones		5						191					3.04	1989			2.7			3.2		432
