
declare @TCID int = 
(
	select id from typecontent where description = ''
)
declare @PIID int = 
(
	select max(id)+1 from PersonalInfo
)
declare @Guid varchar(100) = Newid()
declare @Val varchar(100) = ''
declare @sub varchar(100) = ''

insert into PersonalInfo values
(@PIID, @Guid, @Val, @sub, @TCID)

select * from PersonalInfo 