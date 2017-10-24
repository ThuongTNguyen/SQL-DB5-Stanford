.mode columns
.headers on

.read CollegeSchema.sql
.read CollegeData.sql
.tables

/* =========  */
/* IDs and names of students who have applied to 'CS' at some college */
Select	sID, sName 
From 	Student 
Where 	sID in (Select sID From Apply Where major='CS');

/*OR w/o subquery */
Select distinct Student.sID, sName
From 		Student, Apply
Where 		Student.sID = Apply.sID and major='CS'; 

/* =========  */
/* DUPLICATEs matter: average GPA of 'CS' applicants */
Select 	GPA
From 	Student
Where 	sID in (Select sID From Apply Where major='CS');

/* The following doesn't give the right answer w/ or w/o 'distinct'*/
Select distinct GPA
From 	Student, Apply
Where 	Student.sID = Apply.sID and major='CS';

/* =========  */
/* Students who have applied to major in CS but have not applied to major in EE  */
/*OR using Except operator*/
Select 	sID, sName
From 	Student
Where 	sID in (Select sID From Apply Where major='CS')
	and sID not in (Select sID From Apply Where major='EE');

Select  sID, sName
From    Student
Where   sID = any (Select sID From Apply Where major='CS')
        and not sID = any (Select sID From Apply Where major='EE');
/* =========  */
/* EXIST operator: to test whether a subquery is empty or not rather than cheking whether values are in the sub query  */
/*All Colleges such that some other college is in the same state*/
Select cName, state
From College C1
Where exists (Select * From College C2
		where C2.state = C1.state and C1.cName <> C2.cName);

/*MAX value: College with highest enrollment = find the one that has no other having larger enrollment than its*/
Select cName
From College C1
Where not exists (Select * From College C2
                where C2.enrollment > C1.enrollment);
/* Students with highest GPA*/
Select sName, GPA
From Student C1
Where not exists (Select * From Student C2
                where C2.GPA > C1.GPA);

/* Cannot archive the same result w/o subquery */
/*Select S1.sName, S1.GPA
From Student S1, Student S2
where S1.GPA > S2.GPA;
*/
	
/* =========  */
/*SQLITE doesn't have the following KEYWORDS: ALL, ANY*/
/*However, any query using ALL/ANY can be expressed in terms of EXISTS/NOT EXISTS*/
/* ALL keyword: check whether the value has a certain relationship with all the results of a subquery  */

/*Students with highest GPA*/
Select sName, GPA
From Student
Where GPA >= all (Select GPA from Student);

Select sName, GPA
From Student
Where GPA in  (Select MAX(GPA) from Student);

/*Colleges wih highest enrollment*/
Select cName
From College S1
Where enrollment > any (select enrollment from College S2
			where S2.cName <> S1.cName); 

Select cName
From College S1
Where enrollment in (select MAX(enrollment) from College);

/*Students not from the smallest high school */
Select	sID, sName, sizeHS
From 	Student
Where	sizeHS > any (select sizeHS from Student);

Select  sID, sName, sizeHS
From    Student
Where   sizeHS not in (select MIN(sizeHS) from Student);

Select  sID, sName, sizeHS
From    Student S1
Where 	exists (select * from Student S2 
		where  S2.sizeHS < S1.sizeHS);


