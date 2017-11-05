.mode columns
.headers on

.read social.sql
.tables
.schema
/*
Highschooler ( ID, name, grade ) 
There is a high school student with unique ID and a given first name in a certain grade.

Friend ( ID1, ID2 ) 
The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123).

Likes ( ID1, ID2 ) 
The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 
*/

/*===============================*/
/* Q1: It's time for the seniors to graduate. Remove all 12th graders from Highschooler. */
Delete from Highschooler
where 	grade = 12
/*; */

select * from Highschooler;
/*===============================*/
/* Q2: If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. */

/*Delete From Likes */
Where ID1 in
(Select  ID1
From    Likes
Where   ID1  in (Select ID1 from Likes L2 join Friend using(ID1,ID2))
	and ID1 not in
	(Select  L1.ID1
	From    (Likes L1 join Likes L2 on L1.ID1 = L2.ID2)
	Where   L1.ID2 = L2.ID1
	)
);

/*===============================*/
/* Q3: For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.) */

Select count(*)
From Friend;

Insert 	into Friend
Select 	F1.ID1, F2.ID2
From 	Friend F1, Friend F2
Where	F1.ID2 = F2.ID1 
	and F1.ID1 <> F2.ID2
Except
Select * from Friend
;

Select count(*)
From Friend;
