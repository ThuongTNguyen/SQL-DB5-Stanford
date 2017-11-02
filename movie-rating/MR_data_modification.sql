.mode columns
.headers on

.read rating.sql
.tables
.schema

/*===============================*/
/* Q4: Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars. */
select * from Movie;

select * 
from Rating 
where mID in (select mID From Movie Where year<1970 or year > 2000)
	and stars <4;

Select * 
From  Rating
	join  (select mID From Movie Where year<1970 or year > 2000)
	using(mID)
Where	 stars<4 ;

Delete From Rating
Where 	 mID in (select mID From Movie Where year<1970 or year > 2000)
        and stars <4;

select * from Rating;

/*===============================*/
/* Q3: For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.) */
Update	Movie
Set	year=year+25 
Where mID in (select distinct  mID from Rating group by mID having avg(stars)>=4);

select * From Movie;

/*===============================*/
/* Q1: Add the reviewer Roger Ebert to your database, with an rID of 209. */
Insert into Reviewer values(209, 'Roger Ebert');
select * From Reviewer;

/*===============================*/
/* Q2: Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. */
Insert into Rating
select 	rID, mID, 5, null
from 	Movie, reviewer
Where 	rID in (select rID  From Reviewer Where name='James Cameron')
	and mID in (select mID from Movie);

/*
Select * from rating;
*/

