
--1) Create a scalar function that takes date and returns Month name of that date. 

use ITI

create function ITI.getManthe (@date date)
returns nvarchar (50)
as 
begin 
return DateName (month , @date )
end

select ITI.getManthe('2022-11-21')

--2)  Create a multi-statements table-valued function that takes 
-- integers and returns the values  between them

create function ITI.GetValues ( @start_value int , @end_value int )
returns @ValuesTable table (value int)
as 
begin 
declare @x int = @start_value
while @x <= @end_value
begin 
insert into @ValuesTable (value ) values (@x)
set @x = @x +1 
end 
return 
end 

select * from ITI.GetValues(20, 22);


--3) Create inline function that takes Student No and returns Department Name with Student full name.
create function StudentDepartment (@ID int )
returns table 
as 
return 
(
select D.Dept_Name, concat(s.St_Fname,' ', S.St_Lname)as fullName
from Student s inner join Department d on s.Dept_Id = D.Dept_Id 
where s.St_Id = @ID
)

select * from dbo.StudentDepartment (1)

--------------------

--4. Create a scalar function that takes Student ID and returns a message to user  
--a. If first name and Last name are null then display 'First name & last name are null' 
--b. If First name is null then display 'first name is null' 
--c. If Last name is null then display 'last name is null' 
--d. Else display 'First name & last name are not null' 



create function studentName(@ID int )
returns nvarchar(100)
as
begin 
declare @massage nvarchar(200)
declare @FName nvarchar (20) , @LName nvarchar (20)

select @FName = St_Fname , @LName = St_Lname from Student where St_Id = @ID  

if @FName is null and @Lname is null 
set @massage ='First name and Last name are null'
else if @FName is null 
set @massage ='First name is null'
else if @LName is null 
set @massage ='last name is null'
else 
set @massage ='frist and last name are not null'

return @massage 
end 

select dbo.studentName(1)


--5) Create inline function that takes integer which represents manager ID and displays department 
-- name, Manager Name and hiring date 

create function Manger (@ID int)
returns table
as
return
(
    select 
        d.dept_name, 
        i.ins_name as managername, 
        d.manager_hiredate as hiredate
    from 
        department d
    inner join 
        instructor i on d.dept_manager = i.ins_id
    where 
        d.dept_manager = @ID
);

select * from Manger(10);

--6 ) Create multi-statements table-valued function that takes a string 
--If string='first name' returns student first name 
--If string='last name' returns student last name  
--If string='full name' returns Full Name from student table 
--Note: Use “ISNULL” function 
create function StudentNamee (@data nvarchar(50))
returns @result table (studentName nvarchar(100))
as
begin
if @data = 'first name'
insert into @result (studentName) select isnull(st_fname, ' first name null ') from student;
else if @data = 'last name'
insert into @result (studentName) select isnull(st_lname, 'last name null') from student;
else if @data = 'full name'
insert into @result (studentName) select isnull(concat(st_fname, ' ', st_lname), 'full name null') from student;
return
end


select * from studentnamee('first name');
select * from studentnamee('last name');
select * from studentnamee('full name');


use Company_SD
--7)Create a cursor for Employee table that increases Employee salary by 10% if Salary <3000 
--and increases it by 20% if Salary >=3000. Use company DB 

select * from Departments
select * from Dependent
select * from Employee
select * from Project
select * from Works_for




select SSN , Salary from Employee

declare @employee_ID int , @salary money 
declare employee_cursor cursor for select SSN, Salary from Employee

open employee_cursor 

fetch next from employee_cursor into @employee_ID , @salary

while @@FETCH_STATUS = 0
begin 
if @salary < 3000
update Employee set Salary *= 1.10 where SSN =  @employee_ID

else 
update Employee set Salary *= 1.20 where SSN =  @employee_ID

fetch next from employee_cursor into @employee_ID , @salary 
end 
close employee_cursor 
deallocate employee_cursor 


------------------------------------------------------------------------

--8) Display Department name with its manager name using cursor. 

declare @Manger_Name nvarchar(50) , @Department_name nvarchar (50)

declare D_coursor cursor for select  e.Fname +' '+ e.Lname as mangerName , d.Dname from Employee e inner join Departments d  on d.MGRSSN = e.SSN
open D_coursor

fetch next from D_coursor into @Manger_Name, @Department_name

while @@FETCH_STATUS = 0
begin 

print 'manger name ' + @Manger_Name  + '  Dapartment ' + @Department_name
 
fetch next from D_coursor into  @Manger_Name, @Department_name

end 
close D_coursor
deallocate D_coursor 

------------------------------------------------------------------
--9) Try to display all instructor names in one cell separated by comma. Using Cursor 

declare @instr_names nvarchar(max) = ''
declare @instr_name nvarchar (200)
declare instr_cursor cursor for select Fname + ' ' + Lname as FullName  from Employee where Dno =(select Dno from Department where Dname = 'Instructor')
open instr_cursor
fetch next from instr_cursor into @instr_name 
while @@FETCH_STATUS = 0
begin 
set @instr_names =  @instr_names + @instr_name + ' , '
fetch next from instr_cursor into @instr_name 
end 



set @instr_names = left (@instr_names , len(@instr_names)-2)
print @instr_names 
close instr_cursor

deallocate instr_cursor 



