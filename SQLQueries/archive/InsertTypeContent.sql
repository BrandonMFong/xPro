declare @ID int = 
(
	select count(id)+1
	from typecontent
)
begin transaction
declare @Desc varchar(50) = ''
declare @ExtID varchar(50) = ''
insert into TypeContent 
values (@ID, @Desc, @ExtID)

select * from TypeContent
rollback transaction 
--commit transaction

