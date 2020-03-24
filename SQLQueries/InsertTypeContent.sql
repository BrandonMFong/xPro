declare @ID int = 
(
	select max(id)+1
	from typecontent
)
begin transaction
declare @Desc varchar(50) = ''
insert into TypeContent 
values (@ID, @Desc)

select * from TypeContent
select * from PersonalInfo
rollback transaction 
--commit transaction

