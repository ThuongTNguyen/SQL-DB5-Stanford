/* =======================================  */
/* SQL NULL values that are unknown or undefined. 
 */
/* =======================================  */
/* =======================================  */
.mode columns
.headers on

.read CollegeSchema.sql
.read CollegeData.sql
.tables

insert into Student values (432, 'Kevin', null, 1500);
insert into Student values (321, 'Lori', null, 2500);

select * from Student;

/* =======================================  */
/* Note: Sometimes one needs to call those Null values explicitly if one wants to include them into the result */

Select	sID, sName, GPA
from 	Student
Where	GPA > 3.5 or GPA <3.5 or GPA is null;

/* This query won't include student whose GPA are unknown */
Select  sID, sName, GPA
from    Student
Where   GPA > 3.5 or GPA <3.5;

/* =======================================  */
/* Students with null GPA will be included if their sizeHS satisfies 
	the other condition in the where clause */
Select  sID, sName, GPA, sizeHS
from    Student
Where   GPA > 3.5 or sizeHS < 1600;

/* Below should return all students in the database*/
Select  sID, sName, GPA, sizeHS
from    Student
Where   GPA > 3.5 or sizeHS < 1600 or sizeHS > 1600;

/* =======================================  */
/* Interaction betwwen NULL values and aggregation
 There are a few subtleties about NULL values and aggregation
 and also about null values and subqueries.
 */
/* =======================================  */
/* number of students whose GPAs are known*/
Select 	count(*)
From	Student
Where 	GPA is not null;

/* GPA of students: NULL values is listed in the result: 8 GPAs */
Select  distinct GPA
From    Student;

/* But if we count number of distinct GPAs, Null is not counted as a value
	=>> the query result: 7
 */
Select  count(distinct GPA)
From    Student;

/* Above is one example in which the select clause includes Null values in the result,
 but when we do the count operator, null value is not counted as one value.
 So be careful when writing queries over databases that do contain null values.
 */
