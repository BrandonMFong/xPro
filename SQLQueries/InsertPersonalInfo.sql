
declare @TCID int = 
(
	select id from typecontent where description = 'Token'
)
declare @PIID int = 
(
	select max(id)+1 from PersonalInfo
)
declare @Guid varchar(100) = upper('853d8fe4-664f-4993-8407-a8da4cce8999')
declare @Val varchar(100) = '4246'
declare @sub varchar(100) = 'Default Passcode'

insert into PersonalInfo values
(@PIID, @Guid, @Val, @sub, @TCID)

select * from PersonalInfo 
