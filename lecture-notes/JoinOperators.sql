/* =======================================  */
/* The JOIN family of operators */
/* Inner Join On (condition): like the theta-join in Relational Algebra
 			   - do cross product and keep only tuples that satisfy the condition*/
/* Natural Join: same in RA; 
		- equate columns across tables of the same name, 
		  require the values on those columns to be the same to keep the tuples in the result
		- eliminate the duplicate columns */
/* Inner Join Using (attributes): - similar to Natural Join 
				    but only equate those columns specified 
					in the attibute list */
/* Left/Right/Full Outer Join: 	- combine tuples similar to the theta join
				- but when tuples don't match the theta condition, 
				  they are still added to the result and patted with no values				
 */
/* Join operators don't give any expressive power to SQL.
   It means all the queries with join operator can be rewriten in regular SQL without join operators
 */
/* =======================================  */
.mode columns
.headers on

.read CollegeSchema.sql
.read CollegeData.sql
.tables

/* =========================  */
/* Inner Join On*/
/* =========================  */
/* Name of students paired with the majors to which they applied */
Select distinct	sName, major 
From	Student, Apply
Where 	Student.sID = Apply.sID; /*Theta-join and also natural join*/

Select distinct sName, major 
From 	Student Inner Join Apply on Student.sID = Apply.sID;

Select distinct sName, major
From    Student Join Apply on Student.sID = Apply.sID;

/* =========================  */
/* Names and GPAs of students who come from a high school with size <1000
			and applied to 'CS' major in Stanford university */
Select 	sName, GPA
From 	Student, Apply
Where 	Student.sID = Apply.sID
	and sizeHS < 1000 and major='CS' and cName='Stanford';

Select  sName, GPA
From    Student join Apply
on   	Student.sID = Apply.sID
Where 	sizeHS < 1000 and major='CS' and cName='Stanford';

Select  sName, GPA
From    Student join Apply
on      Student.sID = Apply.sID
	and sizeHS < 1000 and major='CS' and cName='Stanford';

Select  sName, GPA
From    Student join Apply
on      Student.sID = Apply.sID
Where   sizeHS < 1000 and major='CS' and cName='Stanford';

/* =========================  */
/* info about students */
Select distinct	Apply.sID, sName, GPA, Apply.cName, enrollment
From 	Apply, Student, College
Where 	Apply.sID = Student.sID and Apply.cName = College.cName;

/* MySQL and SQLite support >2 table join */
Select distinct  Apply.sID, sName, GPA, Apply.cName, enrollment
From    Apply join Student join College
On	Apply.sID = Student.sID and Apply.cName = College.cName;

/* Some systems, like PostgreSQL, allow only 2table join */
Select distinct  Apply.sID, sName, GPA, Apply.cName, enrollment
From    (Apply join Student on Apply.sID = Student.sID) 
	join College
	On Apply.cName = College.cName;

/* In practice, changing the order in which the query is executed by moving parentheses 
and choosing which tables to be joined first can tune te performance. */

/* =========================  */
/* Natural Join */
/* =========================  */
/* Name of students paired with the majors to which they applied */
Select distinct sName, major
From    Student, Apply
Where   Student.sID = Apply.sID; /*Theta-join and also natural join*/

Select distinct sName, major
From    Student natural join Apply;

/* =========================  */
/* Natural join eleminate one sID column in the result */
Select *
From Student natural join Apply;

Select distinct sID
From Student natural join Apply;

/* without natual join, it gives error because of ambiguity: there are two sID columns, 
 			one for each table*/
Select distinct sID
From Student, Apply;

/* =========================  */
/* Join Using = Natural Join with condition */
/* A better practice using this than Natural Join since there are more than one columns 
	having the same names in those tables, but not all of them are meant to be equated */
/* =========================  */
/* Names and GPAs of students who come from a high school with size <1000
                        and applied to 'CS' major in Stanford university */
Select  sName, GPA
From    Student join Apply
on      Student.sID = Apply.sID
Where   sizeHS < 1000 and major='CS' and cName='Stanford';

Select  sName, GPA
From    Student natural join Apply 
Where   sizeHS < 1000 and major='CS' and cName='Stanford';

Select  sName, GPA
From    Student join Apply using(sID)
Where   sizeHS < 1000 and major='CS' and cName='Stanford';

/* =========================  */
/* Case where there are more than one instance of the same relation */
/* Pairs of students who have the same GPA */
Select	S1.sID, S1.sName, S1.GPA, S2.sId, S2.sName, S2.GPA
From 	Student S1, Student S2
Where 	S1.GPA = S2.GPA and S1.sID < S2.sID;

Select 	S1.sID, S1.sName, S1.GPA, S2.sId, S2.sName, S2.GPA
From 	Student S1 join Student S2 using(GPA)
Where 	S1.sID < S2.sID;
/* Most systems don't allow using 'using' together with 'on', 
 so replacing the above 'where' by 'on' will cause error */

/* =========================  */
/* OUTER JOIN */
/* =========================  */
/* Students who applied to a college and major to which they applied */
Select 	sName, sID, cName, major
From	Student inner join Apply using(sID);

/* the above but includes also students who have not applied anywhere */
Select  sName, sID, cName, major
From    Student left outer join Apply using(sID);

Select  sName, sID, cName, major
From    Student left join Apply using(sID);

Select  sName, sID, cName, major
From    Student natural left outer join Apply;
/*******
Left Outer Join: put the tuples on the table on the left that 
		have no matching tuples on the right relation to the result
		 of the query but fill the right tuple places with NULL values
Right Outer join: similar; put into the result tuples on the tables on the right 
		that don't have matching tuples on the left. 
*********/
/* Can be rewriten without using join */
Select 	sName, Student.sID, cName, major
From 	Student, Apply
Where	Student.sID = Apply.sID
Union
Select 	sName, sID, NULL, NULL
from 	Student
Where	sID not in (select sID from Apply);

/* =========================  */
/***** full outer join: retain all tuples that have no matching tuples on both sides 
 *****/
Select	sName, sID, cName, major
From 	Student full outer join Apply using(sID);

Select  sName, sID, cName, major
From    Student left outer join Apply using(sID)
Union
Select  sName, sID, cName, major
From    Student right outer join Apply using(sID);
/* Uniton automatically eleminate duplicates */

Select  sName, Student.sID, cName, major
From    Student, Apply
Where   Student.sID = Apply.sID
Union
Select  sName, sID, NULL, NULL
from    Student
Where   sID not in (select sID from Apply)
Union
Select  NULL, sID, cName, major
from    Apply
Where   sID not in (select sID from Student);

/* =========================  */
/* All left/right/full outer join are not associative 
	(i.e (A op B) op C != A op (B op C))
  The full outer join is communiative (A op B = B op A) 
	but the other two are not.
 */
/* =========================  */
create table T1 (A int, B int);
create table T2 (B int, C int);
create table T3 (A int, C int);
insert into T1 values (1,2);
insert into T2 values (2,3);
insert into T3 values (4,5);

select A,B,C
from (T1 natural full outer join T2) natural full outer join T3;

select A,B,C
from T1 natural full outer join (T2 natural full outer join T3);

drop table T1;
drop table T2;
drop table T3;


