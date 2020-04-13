
declare @TCID int = 
(
	select id from typecontent where ExternalID = ''
)
declare @PIID int = 
(
	select count(id)+1 from PersonalInfo
)
begin transaction 
declare @Guid varchar(100) = upper(Newid())
declare @Val varchar(100) = ''
declare @sub varchar(100) = ''

insert into PersonalInfo values
(@PIID, @Guid, @Val, @sub, @TCID)

select pi.*, tc.Description 'Type' 
from PersonalInfo pi 
join TypeContent tc on pi.TypeContentID = tc.ID 
order by pi.ID desc
rollback transaction 
--commit transaction 