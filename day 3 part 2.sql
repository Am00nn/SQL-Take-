--part(2): 


--1)Create a stored procedure without parameters to show the number of students per department name.[use ITI DB] 
use ITI
create Procedure sttudent_count
as
begin
select   count(s.St_Id) as Name_of_student ,d.Dept_Name as department_name
from department d left join student s on d.Dept_Id = s.Dept_Id group by d.Dept_Name
end       

exec sttudent_count

--2)Create a stored procedure that will check for the # of employees in the project p1 if they are more than
--3 print message to the user “'The number of employees in the project p1 is 3 or more'” if they are less display
--a message to the user “'The following employees work for the project p1'” in addition to the first name and last name of each one. [Company DB] 

use Company_SD

create procedure check_employees_in_p1_project
as
begin
declare @NumberEmployee int;
select @NumberEmployee = count(*) from works_for w inner join project p on w.pno = p.pnumber where p.pname = 'p1';
if @NumberEmployee >= 3
begin
print ' number of employees in  p1 is 3 or more';
end
else
begin
print ' employees work in project 1:';
select e.fname, e.lname from Employee e inner join works_for w on e.ssn = w.essn inner join project p on w.pno = p.pnumber where p.pname = 'p1';
end
end  

exec check_employees_in_p1_project 



--3)Create a stored procedure that will be used in case there is an old employee has 
--left the project and a new one become instead of him. The procedure should take 3 parameters
--(old Emp. number, new Emp. number and the project number) 
--and it will be used to update works_on table. [Company DB]


--4.	add column budget in project table and insert any draft values in it then 
--then Create an Audit table with the following structure 
--ProjectNo 	UserName 	ModifiedDate 	Budget_Old 	Budget_New 
--p2 	Dbo 	2008-01-31	95000 	200000 

--This table will be used to audit the update trials on the Budget column (Project table, Company DB)
--Example:
--If a user updated the budget column then the project number, user name that made that update, the 
--date of the modification and the value of the old and the new budget will be inserted into the Audit table
--Note: This process will take place only if the user updated the budget column

alter table project
add budget int

create table audit (
   projectno int,
   username nvarchar(50),
   modifieddate datetime,
   budget_old int,
   budget_new int
)

create trigger trg_audit_budget_update
on project
after update
as
begin
   if update(budget)
   begin
       insert into audit (projectno, username, modifieddate, budget_old, budget_new)
       select
           i.pnumber as projectno,            
           system_user as username,          
           getdate() as modifieddate,         
           d.budget as budget_old,              
           i.budget as budget_new               
       from
           inserted i
       inner join
           deleted d on i.pnumber = d.pnumber;
   end
end
-------------------------------
update project
set budget = 5000
where pname = 'p1'
update project
set budget = 2000
where pname = 'p2'

--5) Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
--“Print a message for user to tell him that he can’t insert a new record in that table
use ITI
create trigger trg_no_insert_department
on Department
instead of insert
as
begin
   print 'insertion into the department table is not allowed.';
end


--6)⦁	 Create a trigger that prevents the insertion Process for Employee table in March [Company DB].
use Company_SD
create trigger trg_no_insert_in_march
on Employee
instead of insert
as
begin
  
   if month(getdate()) = 3
   begin
       print 'cannot insert records into the employee table during march.';
       return;
   end
   
   insert into Employee
   select * from inserted;
end


--7)⦁	Create a trigger on student table after insert to add Row in Student Audit table (Server User Name , Date, Note)
--where note will be “[username] Insert New Row with Key=[Key Value] in table [table name]”
use ITI
create trigger trg_student_audit_insert
on Student
after insert
as
begin

   insert into StudentAudit (ServerUserName, Date, Note)
   select
       SYSTEM_USER AS ServerUserName, -- Get the current server username
       GETDATE() AS Date,              -- Get the current date and time
       concat(SYSTEM_USER, ' insert new row with key=', i.[Key], ' in table [student]') AS Note -- Construct the note
   from
       inserted i; -- Get data from the inserted pseudo-table
end

create trigger trigger_student_audit_insert 
on Student 
after insert 
as 
begin 
insert into StudentAudit (serverUserName , date_of_change , note)
select 
system_user as serverUserName,getdate() as date_of_change , concat(system_user ,'insert new row -> key=', i.[Key],' in table [student]') as note
from inserted i
end 




==
insert into StudentAudit (ServerUserName, Date, Note)
select
   SYSTEM_USER AS ServerUserName, -- Get the current server username
   GETDATE() AS Date,              -- Get the current date and time
   concat(SYSTEM_USER, ' Insert New Row with Key=', i.[Key], ' in table [student]') AS Note -- Construct the note
from
   inserted i; -- Get data from the inserted pseudo-table
8) create trigger trg_student_audit_delete
on student
instead of delete
as
begin
-- Insert a record into the StudentAudit table
insert into StudentAudit (ServerUserName, Date, Note)
select
SYSTEM_USER AS ServerUserName, -- Get the current server username
GETDATE() AS Date, -- Get the current date and time
'Try to delete row with key=' + CAST(i.[Key] AS VARCHAR(255)) AS Note -- Construct the note
from
deleted i; -- Get data from the deleted pseudo-table
end;