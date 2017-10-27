/* =======================================  */
/* Subqueries in the FROM and SELECT clauses*/
/* =======================================  */
.mode columns
.headers on

.read CollegeSchema.sql
.read CollegeData.sql
.tables

/* =========================  */
/* Students whose scaled GPA changes GPA by more than 1*/

Select 	sID, sName, GPA, GPA*(sizeHS/1000.0) as scaledGPA
From 	Student
Where 	abs(GPA*(sizeHS/1000.0) - GPA) > 1.0;

Select	*
From 	(select sID, sName, GPA, GPA*(sizeHS/1000.0) as scaledGPA
	from Student) G
Where   abs(G.scaledGPA - GPA) > 1.0;

/* =========================  */
/* Colleges paired with the highest GPA of their applicants */
Select	College.cName, state, GPA
From	College, Apply, Student
Where	College.cName = Apply.cName
	and Apply.sID = Student.sID
	and GPA >= all (select GPA from Student, Apply
			where Student.sID = Apply.sID 
			and Apply.cName = College.cName);

Select  distinct 	College.cName, state, GPA
From    College, Apply, Student
Where   College.cName = Apply.cName
        and Apply.sID = Student.sID
	        and GPA >= (select MAX(GPA) from Student, Apply
			 where Student.sID = Apply.sID
		         and Apply.cName = College.cName);

Select 	cName, state,
	(select distinct GPA from Apply, Student
		where College.cName = Apply.cName
        	and Apply.sID = Student.sID
                and GPA >= (select MAX(GPA) from Student, Apply
		                         where Student.sID = Apply.sID
				                         and Apply.cName = College.cName))
	as GPA
from College;

/* =========================  */
/* Subquery in the SELECT clause is right only when its result is a single value because the value is being to put into just one cell of a tuple*/
/* Therefore we get error in the following query */
/* Colleges paired with names of its applicants */

Select  cName, state,
        (select  sName from Apply, Student
		where College.cName = Apply.cName
		and Apply.sID = Student.sID)
	as sNamesdfs
from College;

select distinct cName, state,
  (select distinct sName
	   from Apply, Student
	   where College.cName = Apply.cName
	     and Apply.sID = Student.sID) as sName
from College;

