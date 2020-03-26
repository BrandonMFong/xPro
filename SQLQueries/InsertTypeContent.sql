declare @ID int = 
(
	select max(id)+1
	from typecontent
)
begin transaction
declare @Desc varchar(50) = ''
declare @ExtID varchar(50) = ''
insert into TypeContent 
values (@ID, @Desc, @ExtID)

select * from TypeContent
select * from PersonalInfo
rollback transaction
--commit transaction 