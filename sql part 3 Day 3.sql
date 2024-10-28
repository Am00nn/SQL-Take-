--Part 3:

--1. Display instructor name and department name (even if an instructor is not
--attached to a department)

select i.Ins_Name , d.Dept_Name
from instructor i left join Department d on i.Dept_Id = d.Dept_Id

--2. Display student full name and the name of the course
--they are taking (only for courses with a grade)

select s.St_Fname+' '+ s.St_Lname as full_name , c.Crs_Name
from Student s inner join Stud_Course sc on s.St_Id = sc.St_Id
inner join Course c on sc.Crs_Id = c.Crs_Id
where sc.Grade is not null

--3. Display the number of courses for each topic name

select * from Topic
select t.Top_Name , count(c.Crs_Id) as  Count_of_course
from Topic t inner join Course c  on  t.Top_Id = c.Top_Id group by t.Top_Name

 --4) Display max and min salary for instructors

select max(Salary) as MaxSalary , min(Salary) as MinSalary
from Instructor

--5. Display the department name that contains the instructor who receives the minimum salary

select d.Dept_Name from Instructor i inner join Department d  on  i.Dept_Id = d.Dept_Id where i.Salary = (select min(salary) from Instructor)

--6. Select instructor name and their salary, or "bonus" if salary is NULL (using COALESCE)

select Ins_Name, coalesce(cast(Salary as varchar) , 'bonus') as Salary_Bonus from Instructor

--7. Query to select the highest two salaries in each department (using ranking functions)

WITH RankedSalaries as (
    select
        I.Ins_Name,
        I.Salary,
        I.Dept_Id,
        RANK() OVER (PARTITION BY I.Dept_Id ORDER BY I.Salary DESC) as SalaryRank
    from
        Instructor I
    where
        I.Salary IS NOT NULL
)
select
    Ins_Name,
    Salary,
    Dept_Id
from
    RankedSalaries
where
    SalaryRank <= 2
ORDER BY
    Dept_Id, SalaryRank
select Ins_Name , Dept_Id ,Salary from Rank_Salary  where  TopTowSalaryas <= 2

--8. Query to select a random student from each department (using ranking functions)

with Student_rank as
( select St_Id ,St_Fname + ' ' + s.St_Lname AS Full_Name, Dept_Id ,row_number() over (partition by Dept_Id order by newid()) as rndom from Student s
)
select Full_Name, Dept_Id from Student_rank where rndom =2


----------------------------------------------------------

--p2)

--AdventureWorks2012 DB

use AdventureWorks2012
--1)

select * from production.Product
where Name like 'B%'


--2)
update Production.ProductDescription
set description = 'Chromoly steel_High of defects'
where ProductDescriptionID = 3
select * from production.ProductDescription
where description like '%[_]%'
---3)




select avg(distinct ListPrice) as AverageP
from Production.Product

--5) 
select concat('The ', Name, ' is only ', ListPrice) as [Product Price List]
FROM Production.Product
where ListPrice between 100 and 120

--6) 
select format(getdate(), 'MMMM dd, yyyy')
union
select format(getdate(), 'dd / MM / yyyy')
union
select format(getdate(), 'yyyyMMdd')