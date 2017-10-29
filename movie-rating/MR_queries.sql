.mode columns
.headers on

.read rating.sql
.tables
.schema

/*===============================*/
/* Q1: Find the titles of all movies directed by Steven Spielberg.*/ 
Select 	title 
From	Movie
Where	director='Steven Spielberg';

/*===============================*/
/* Q2: Find all years that have a movie that received a rating of 4 or 5, 
and sort them in increasing order. 
 */
select * from Rating where stars =4 or stars=5;

Select 	year, mID
From 	Movie
Where 	mID in (select mID from Rating where stars=4 or stars=5)
Order by year asc;

Select 	year
From 	Movie
Where 	mID in (select mID from Rating where stars=4 or stars=5)
Order by year asc;

/*===============================*/
/* Q3: Find the titles of all movies that have no ratings. */
Select 	title
From 	Movie
Where 	mID not in (select mID from Rating);

/*===============================*/
/* Q4: Some reviewers didn't provide a date with their rating. 
Find the names of all reviewers who have ratings with a NULL value for the date*/
Select	 name
From 	Reviewer
Where	rID in (select rID From Rating where ratingDate is null);

/*===============================*/
/* Q5: Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.*/
Select	name, title, stars, ratingDate
From	Reviewer, Movie, Rating
Where 	Reviewer.rID = Rating.rID 
	and Movie.mID = Rating.mID
Order By name, title, stars;

/*===============================*/
/* Q6: For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. */
/*
insert into Rating values(203, 108, 5, '2011-02-12');
*/
/*
Select 	name, title
From    Reviewer, Movie, Rating R1 
Where   Reviewer.rID = R1.rID
        and Movie.mID = R1.mID
	and R1.rID in (select R2.rID From Rating R2 
			Where R2.rID = R1.rID and R2.mID=R1.mID
			and R2.ratingDate < R1.ratingDate
			and R2.stars < R1.stars);

*/		
select 	rID 
From 	Rating R1 
where 	rID in (select rID From Rating R2 Where R2.rID = R1.rID and R2.mID=R1.mID 
	and R2.ratingDate < R1.ratingDate
	and R2.stars < R1.stars);

 
Select distinct  name, title
From    Reviewer, Movie, Rating R1
Where   Reviewer.rID = R1.rID
        and Movie.mID = R1.mID
	and R1.rID in  
(select  rID From Rating R1 Group By rID, mID having count(mID)=2
intersect
select  rID From    Rating R1
where   rID in (select rID From Rating R2 Where R2.rID = R1.rID and R2.mID=R1.mID
	        and R2.ratingDate < R1.ratingDate
		        and R2.stars < R1.stars)
	);
/*===============================*/
/* Q7: For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. */
select 	mID, max(stars)
From Rating 
group by mID;

select title, nbstars
From Movie join (select mID, max(stars) as nbstars From Rating group by mID) using(mID)
Order by title;


/*===============================*/
/* Q8: For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. */

select title, S
From Movie join
(
select mID, max(stars) - min(stars) as S
From Rating
Group By mID
) using(mID)
order by S desc, title;

/*===============================*/
/* Q9: Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
(Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) : */

Select M.mID,  avg(B) 
from
((Select mID, year From Movie Where year>1980) 
join
(Select mID, avg(stars) as B From Rating Group by mID)
using(mID))  M;

Select abs(avg(B)- avg(A))
from	(Select mID, avg(stars) as B From (Rating join (Select mID, year From Movie Where year<1980) using(mID))  
       		Group by mID),
	(Select mID, avg(stars) as A From (Rating join (Select mID, year From Movie Where year>1980) using(mID))
		Group by mID)
			;


