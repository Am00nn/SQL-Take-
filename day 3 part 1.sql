

  use Company_SD

--1)	Display (Using Union Function)
--The name and the gender of the dependence that's gender is Female and depending on Female Employee
-- And the male dependence that depends on Male Employee.

select Dependent_name, d.Sex from Dependent d inner join Employee e ON d.ESSN = e.SSN
where d.Sex = 'F' AND e.Sex = 'F'
union
select d.Dependent_name, d.Sex from Dependent d inner join  Employee e on d.ESSN = e.SSN
where d.Sex = 'M' AND e.Sex = 'M'

--2)For each project, list the project name and the total hours per week (for all employees) spent on that project.

select Pname, SUM(Hours) as TotalHours from Works_for w inner join Project p on w.Pno = p.Pnumber group by  Pname

--3) Display the data of the department which has the smallest employee ID over all employees' ID.

select * from Departments where Dnum = (select Dno from Employee where SSN = (select min(SSN) from Employee))

--4)For each department, retrieve the department name and the max, min and average salary of its employees.
select Dname, max(Salary) as MaxSalary, min(Salary) as MinSalary, avg(Salary) as AvgSalary from Employee e inner join Departments d ON e.Dno = d.Dnum group by Dname;

--5)List the full name of all managers who have no dependents.

 select Fname, Lname from Employee where SSN in (select MGRSSN from Departments) and SSN not in (select ESSN from Dependent);

--6)For each department-- if its average salary is less than the average salary of all employees-- display its number, name and number of its employees.

select Dname,Dnum , count(*) as Employees_Number from Employee e
inner join Departments d on e.Dno = d.Dnum
group by Dnum, Dname
having avg(Salary) < (select avg(Salary) from Employee);

select Dname, Dnum, 
       (select count(*) 
        from Employee 
        where Dno = d.Dnum) as Employees_Number
from Departments d
where (select avg(Salary) 
       from Employee 
       where Dno = d.Dnum) < (select avg(Salary) from Employee)

 
--7)Retrieve a list of employees names and the projects names they are working on ordered by 
--department number and within each department, ordered alphabetically by last name, first name.


select e.Fname, e.Lname, (select p.Pname from Project p where p.Pnumber = w.Pno) as projects_names
from Employee e, Works_for w where e.SSN = w.ESSN order by e.Dno, e.Lname, e.Fname

--8) Try to get the max 2 salaries using subquery

select top 2 Fname + ' ' + Lname as full_name,Salary from Employee order by Salary desc

--9)Get the full name of employees that is similar to any dependent name


select Fname + ' ' + Lname as full_name
from Employee where EXISTS (select 1
from Dependent where Dependent_name like '%'+Fname+'%'or Dependent_name like '%'+Lname+'%')

--10) Display the employee number and name if at least one of them have dependents (use exists keyword) self-search.

select SSN, Fname, Lname from Employee e
where EXISTS (select 1 from Dependent d where d.ESSN = e.SSN)

--11) In the department table insert new department called "DEPT IT" , with id 100, employee with SSN = 112233 as a manager for 
--this department. The start date for this manager is '1-11-2006'

insert into Departments (Dname, Dnum, MGRSSN, [MGRStart Date])
values ('DEPT IT', 100, 112233, '2006-11-01')

--12)⦁	Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  moved to be the manager of the new department
--(id = 100), and they give you(your SSN =102672) her position (Dept. 20 manager) 

update Departments set MGRSSN = 968574 where Dnum = 100

update Departments set MGRSSN = 102672 where Dnum = 20

update Employee set Superssn = 102672 where SSN = 102660


--13)⦁	Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344) so try to delete his data 
--from your database in case you know that you will be temporarily in his position.


begin transaction

delete from Dependent where ESSN = 223344;


delete from Works_for where ESSN = 223344;


update Employee SET Superssn = NULL where Superssn = 223344;


delete from Employee where SSN = 223344;

commit




--14) Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%


update Employee set Salary = Salary * 1.30 where SSN in (select ESSN from Works_for where Pno = (select Pnumber from Project where Pname = 'Al Rabwah'));

------------------------------------------------------

