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
/* Q1: Find the names of all students who are friends with someone named Gabriel.*/
select 	name
From 	Highschooler
Where 	ID in 
(Select ID2
From Friend
Where ID1 in (select ID From Highschooler Where name='Gabriel' )
);

/*===============================*/
/* Q2: For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. 
 */

select * from Highschooler join Likes on Highschooler.ID = Likes.ID1;

Select H.name, H.grade, H.name2, H.grade2 	
From  	(
(Highschooler join Likes on Highschooler.ID = Likes.ID1)  
join
(select ID as ID2,name as name2, grade as grade2 from Highschooler where ID in (select ID2 from Likes)) using(ID2)) H
where	H.grade - H.grade2 >= 2;

Select 	H.name, H.grade, H2.name,H2.grade
From  	(Highschooler join Likes on Highschooler.ID = Likes.ID1) H, 
	Highschooler H2
Where	H.ID2=H2.ID
	and H.grade -H2.grade >=2;

/*===============================*/
/* Q3: For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. 
 */

select 	L1.ID1, L1.ID2
From	(Likes L1 join Likes L2 on L1.ID1 = L2.ID2) 
Where 	L1.ID2 = L2.ID1
	and L1.ID1 < L1.ID2;

select H1.name, H1.grade, H2.name, H2.grade
From    (
		(select  L1.ID1, L1.ID2
			From    (Likes L1 join Likes L2 on L1.ID1 = L2.ID2)
			Where   L1.ID2 = L2.ID1) L 
		join Highschooler H1 on L.ID1 = H1.ID),
	Highschooler H2
Where 	L.ID2 = H2.ID
	and H1.name < H2.Name;

/*===============================*/
/* Q4: Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. 
 */

Select 	name, grade
From 	Highschooler
Where	ID not in (select ID1 From Likes union select ID2 From Likes)
order by grade, name;

/*===============================*/
/* Q5: For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. */
Select 	LH.name1,LH.grade1, LH.name2, LH.grade2
From	((select ID1, ID2, name as name1, grade as grade1 From (Likes join Highschooler on Likes.ID1=Highschooler.ID)) 
	natural join
	(select ID1, ID2, name as name2, grade as grade2 From (Likes join Highschooler on Likes.ID2=Highschooler.ID)) 
) LH,
Likes
Where	LH.ID1 = Likes.ID1
	and LH.ID2 not in (select ID1 from Likes);


Select 	H1.name, H1.grade, H2.name, H2.grade
From 	Likes L1, Highschooler H1, Likes L2, Highschooler H2
Where	L1.ID1 = H1.ID
	and L1.ID1 = L2.ID1
	and L1.ID2 = L2.ID2
	and L2.ID2 = H2.ID
	and L2.ID2 not in (select ID1 from Likes)
	;

/*===============================*/
/* Q6: Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.  
 */
/*
Select distinct	 HF1.name, HF1.grade
*/

Select	name, grade
From 	Highschooler
Where 	ID not in
(
Select H1.ID
From Highschooler H1 join Friend join Highschooler H2
Where 	H1.ID = Friend.ID1
	and H2.ID = Friend.ID2
	and H1.grade <> H2.grade
)
	and ID in (select ID1 from Friend)
order by grade, name;	

/*===============================*/
/* Q7: For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.  */

Select * 
From	((select ID1 from Likes 
	Except
	Select 	ID1
	From	(Likes L2 join Friend using(ID1,ID2))
	) 
	natural join Likes) 
;

Select  *
From 	Likes
Where	ID1 not in (Select ID1 from Likes L2 join Friend using(ID1,ID2))
;

Select	L1.name, L1.grade, F2.name, F2.grade, F1.name, F1.grade
From	((Select  *
	From    Likes
	Where   ID1 not in (Select ID1 from Likes L2 join Friend using(ID1,ID2))
	) L0 join Highschooler on L0.ID1=Highschooler.ID
       	) L1,
	(Friend join Highschooler on Friend.ID2=Highschooler.ID)  F1, 
	(Friend join Highschooler on Friend.ID1=Highschooler.ID) F2
Where	L1.ID1 = F1.ID1
	and L1.ID2 = F2.ID1
	and F1.ID2 = F2.ID2;

/*===============================*/
/* Q8: Find the difference between the number of students in the school and the number of different first names. 
 */
select 	count(ID) - count(distinct name)
From 	Highschooler;

/*===============================*/
/* Q9: Find the name and grade of all students who are liked by more than one other student.
 */

select	name, grade
From 	(Likes join Highschooler on Likes.ID2 = Highschooler.ID) L
Group by ID2
having 	count(ID1) >= 2;


