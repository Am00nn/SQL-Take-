select * from Course
select * from Department
select * from Instructor
select * from Ins_Course

select * from Stud_Course
select * from Student
select * from Topic

drop database ITI 
--1) Create a view that displays student full name, course name if the student has a grade more than 50. 
create view stdavg_50 AS
select  St_Fname + ' ' + St_Lname as FullName, Crs_Name
from Student s
inner join Stud_Course g on s.St_Id = g.St_Id
inner join Course c on g.Crs_Id = c.Crs_Id
where g.Grade > 50;
 
select FullName , Crs_Name from stdavg_50

--2) Create an Encrypted view that displays manager names and the topics they teach. 

use ITI

create view vEncrypted
as
select Ins_Name,(select Crs_Name from Course where Crs_Id in(select Crs_Id from Ins_Course  where Ins_Id = Instructor.Ins_Id))as  Crs_Name from Instructor
where ins_id in (select Dept_manager from Department where Dept_manager in (select Ins_Id from Ins_Course where Crs_Id in(select Crs_Id from Course )))


select * from vEncrypted



--3)Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department 

create view Instructors_JavaAndSDDD 
as
select Ins_Name , Dept_Name 
from Instructor i inner join Department d on i.Dept_Id = d.Dept_Id where d.Dept_Name in ( 'SD' , 'Java') 

select Ins_Name , Dept_Name  from Instructors_JavaAndSDDD


--4)Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
--Note: Prevent the users to run the following query 
--Update V1 set st_address=’tanta’
--Where st_address=’alex’;

use ITI
create  view v1 as
select St_Id, St_Fname+' ' + St_Lname as fullName, St_Address, St_Age, Dept_Id, St_super
from Student
where St_Address in ('Alex', 'Cairo');


create trigger No_change_addres 
on v1
instead of update 
as 
begin 
if exists (select * from inserted where St_Address ='Alex')
begin 
print 'you are not allow update address'
end 
end 


--5.Create a view that will display the project name and the number of employees work on it. “Use Company DB”

use Company_SD

create view countEmployee AS
select p.Pname, count(e.SSN) as Num_employe from
Project p left join  Employee e ON p.Dnum = e.Dno
group by  p.Pname

select * from countEmployee


--6.	Create the following schema and transfer the following tables to it (Self Search )
--a.	Company Schema
--Add ? Department table and Project table
--b.	Human Resource Schema
--            Add ?Employee table
create schema company;
create table company.Department (
    D_id int primary key,
    D_name varchar(50) not null
)
create table company.project (
    P_id int primary key,
    P_name varchar(50) not null
)
create schema humanresource;
create table humanresource.Employee (
    E_id int primary key,
    E_name varchar(50) not null
)
--7.Try to generate script from DB ITI that describes all tables and views in this DB (Self Search)
select
    table_name
from
    information_schema.tables
where
    table_type = 'BASE TABLE' AND table_schema = 'dbo'
select
    table_name
from
    information_schema.views
where
    table_schema = 'dbo'





