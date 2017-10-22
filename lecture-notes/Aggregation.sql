/* =======================================  */
/* SQL Aggregation functions:
 	min, max, sum, avg, count */
/* Clauses only used in junction with aggregation: 
	Group By columns
 	Having condition 
	 */
/* =======================================  */
/* =======================================  */
.mode columns
.headers on

.read CollegeSchema.sql
.read CollegeData.sql
.tables

/* =======================================  */
/* AVERAGE */
/* =======================================  */
/* Calculate the average GPA of the students in the database */
Select	avg(GPA)
From	Student;

/* =======================================  */
/* Lowest GPA of students applying to CS */
Select 	min(GPA)
From 	Student, Apply
Where	Student.sID = Apply.sID and major = 'CS';

/* =======================================  */
/* Average GPA of students applying to CS */
/* below is not correct because it counts one student who applied to CS
	at more than 1 college more than 1*/
Select  avg(GPA) as wrongavgGPA
From    Student, Apply
Where   Student.sID = Apply.sID and major = 'CS';

/* Correct: use subquery*/
Select 	avg(GPA)
From 	Student 
Where 	sID in (select sID from Apply where major='CS');

/* =======================================  */
/* COUNT */
/* =======================================  */
/* Number of colleges bigger than 15000 */
Select 	count(*)
From 	College
Where 	enrollment > 15000;

/* =======================================  */
/* Number of students applying to Cornell
 Each student should be count once no matter how many time/majors they applied */
Select	count(distinct sID)
From 	Apply
Where 	cName='Cornell';

/* without distinct sID: overcount students */
Select  count(*) as overcounted
From    Apply
Where   cName='Cornell';

/* =======================================  */
/* Students such that number of other students with same GPA 
 is equal to number of other students with same sizeHS 
 */
Select	*
From 	Student S1
Where	(select count(*) from Student S2 where S1.sID<>S2.sID and S1.GPA=S2.GPA)
	=
	(select count(*) from Student S2 where S1.sID<>S2.sID and S1.sizeHS=S2.sizeHS);

/* =======================================  */
/* Amount by which average GPA of students applying to CS 
	exceeds average of students not applying to CS
 */
Select 	CS.avgGPA - NonCS.avgGPA
From 	(select avg(GPA) as avgGPA from Student 
	 where sID in (select sID from Apply where major='CS')
	) as CS,
	(select avg(GPA) as avgGPA from Student
	 where sID not in (select sID from Apply where major='CS')
	) as NonCS;

Select distinct (select avg(GPA) as avgGPA from Student
        where sID in (select sID from Apply where major='CS'))
	-
	(select avg(GPA) as avgGPA from Student
	 where sID not in (select sID from Apply where major='CS')
	) as d
from Student;

/* =======================================  */
/* GROUP BY */
/* Take a relation and partition it by values of a given attributes 
 or a set of attributes 
 */
/* =======================================  */
/* Number of application to each college */
Select	cName, count(*)
From 	Apply
Group By cName;

/* to illustrate */
Select  *
From    Apply
order by cName;

/* =======================================  */
/* College enrollments by state */
Select 	state, sum(enrollment)
From 	College
Group By state;

/* =======================================  */
/* Minimum and maximum GPAs of applicants to each college and major */
Select	cName, major, min(GPA), max(GPA)
From	Student, Apply
Where 	Student.sID=Apply.sID
Group By cName, major;

/* for illustration */
Select  cName, major, GPA
From    Student, Apply
Where   Student.sID=Apply.sID
order By cName, major;

/* Spread of GPA of applicants to each college and major */
Select M.cName, M.maxGPA - M.minGPA
From 	(Select  cName, major, min(GPA) as minGPA, max(GPA) as maxGPA
	From    Student, Apply
	Where   Student.sID=Apply.sID
	Group By cName, major)
	as M;

/* =======================================  */
/* Number of colleges applied to by each student  */
Select 	Student.sID, sName, count(distinct cName), cName
From 	Student, Apply
Where 	Student.sID = Apply.sID
Group By Student.sID;

/* NOTE: When we put in the SELECT clause of the grouping query 
	an attribute that is not one of the grouping attributes,
	some systems (MySQL, SQLite) will put a random value from that attibute;
	some (Posgre) will give error.
 That is what happens when we put cName in the above query.
 With sName, it gives correct result because in each group by sID, there's only one sName.
 */

/* The above but also students who didn't apply anywhere */
Select 	Student.sID, count(distinct cName)
From 	Student, Apply
Where 	Student.sID = Apply.sID
Group By Student.sID
Union
Select	sID, 0
From 	Student
where	sID not in (select sID from Apply);

/* =======================================  */
/* HAVING clause: only used in conjunction with aggregation 
 Useage: applied after Group By to check conditions that involve the entire group.
	Note: Having is in contrast with Where since the latter applies to 
	only one tuple at a time.
 */	
/* =======================================  */

/* Colleges with fewer 5 applications */
Select 	cName, sID
From	Apply
order By cName;

Select  cName
From    Apply
Group By cName
Having count(*) < 5;

/* rewriting query w/o using groupby/having */
Select distinct  cName
From    Apply A1
Where 5 > (select count(*) from Apply A2 where A2.cName= A1.cName);

/* NOTE: All queries with group by/having can be rewritten w/o using those clauses. */

/* =======================================  */
/* Colleges with fewer 5 applicants */
Select  cName
From    Apply
Group By cName
Having 	count(distinct sID) < 5;

/* =======================================  */
/* Majors whose applicant's maximum GPA is below the average */
Select	major
From 	Apply, Student
Where 	Apply.sID = Student.sID
Group By major
Having	max(GPA) < (select avg(GPA) from Student);


