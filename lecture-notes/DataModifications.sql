/* =======================================  */
/* SQL: Data Modifications.

- Inserting new data
	+ Insert Into table Values(A1, A2, ..., An)
	+ Insert Into table select-statement

 - Deleting data
	Delete From table Where condition

 - Updating existing data: one attibute or a number of them
	+ Update table 
	  Set attr = expression
	  Where condition
	+ Update table
	  Set A1=Expr1, A2=Expr2, ..., An=Exprn
	  Where condition
 */
/* =======================================  */
/* =======================================  */
.mode columns
.headers on

.read CollegeSchema.sql
.read CollegeData.sql
.tables

/* =======================================  */
/* Inserting data */
/* =======================================  */
Insert Into College Values ('Carnegie Mellon', 'PA', 11500); 

Select * From College;

/* =======================================  */
/* Have all students who didn't apply anywhere apply to CS at Carnegie Mellon */
Select 	*
From 	Student
Where sID not in (select sID from Apply);

Select  sID, 'Carnegie Mellon', 'CS', null
From    Student
Where 	sID not in (select sID from Apply);

Insert Into Apply
Select  sID, 'Carnegie Mellon', 'CS', null
From    Student
Where   sID not in (select sID from Apply);

Select * From Apply;

/* =======================================  */
/* Admit to Carnegie Mellon major EE all students who were turned down in EE elsewhere */
Select  sID, 'Carnegie Mellon', 'EE', 'Y'
From Student
Where sID in (select distinct sID from Apply
	                where major='EE' and decision='N' and cName<>'Carnegie Mellon');

Insert Into Apply
Select	sID, 'Carnegie Mellon', 'EE', 'Y'
From Student
Where sID in (select distinct sID from Apply 
		where major='EE' and decision='N' and cName<>'Carnegie Mellon');

Select * From Apply;

/* =======================================  */
/* Deleting data */
/* =======================================  */
/* =======================================  */
/* Delete all students who applied to more than two different majors */
Select	sID, count(distinct major)
From 	Apply
Group By sID
Having count(distinct major) > 2;

Delete from 	Student
Where 	sID in
	(Select  sID
		From    Apply
		Group By sID
		Having count(distinct major) > 2
	);

Select	* From Student;

/* Note: some systems don't allow deletion commands where the subquery includes
the same relation that we delete from.
	But SQLite, PostGre do.
In case, we need to rewrite the query, we can create a temporary table to put in the result of the subquery, then delete the temporary table from the relation.
 */
Delete from     Apply
Where   sID in
        (Select  sID
		From    Apply
		Group By sID
		Having count(distinct major) > 2
	);

Select * From Apply;

/* =======================================  */
/* Delete colleges with no CS applicants */
Select 	* 
From 	College
Where 	cName not in (Select cName from Apply where major = 'CS');

Delete  
From    College
Where   cName not in (Select cName from Apply where major = 'CS');

Select * From College;

/* =======================================  */
/* Update data */
/* =======================================  */
/* =======================================  */
/* Accept applicants to Carnegie Mellon with GPA < 3.6 
	but turn them into economics major */
Select	* 
From 	Apply
Where 	cName='Carnegie Mellon' 
	and sID in (select sID from Student where GPA < 3.6);


Update  Apply
Set	decision = 'Y', major = 'economics'
Where   cName='Carnegie Mellon'
        and sID in (select sID from Student where GPA < 3.6);

Select	* From Apply;

/* =======================================  */
/* Turn the highest-GPA history applicant into a CSE applicant */
Select 	*
From 	Student
Where 	sID in (select sID from Apply where major='history');
	
Select  * 
From 	Apply
Where   major = 'history'
	and sID in (select sID from Student
			where GPA>= (select GPA from Student where sID in 
				(select sID from Apply where major='history'))
			);	


Update Apply 
set major= 'CSE'
Where   major = 'history'
        and sID in (select sID from Student
		   where GPA>= (select GPA from Student where sID in
			    (select sID from Apply where major='history'))
			);

Select * from Apply;

/* =======================================  */
Update 	Student
set 	GPA= (select max(GPA) from Student),
	sizeHS = (select min(sizeHS) from Student);

select * from Student;
/* =======================================  */


