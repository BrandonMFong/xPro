
declare @TCID int = 
(
	select id from typecontent where description = 'Token'
)
declare @PIID int = 
(
	select max(id)+1 from PersonalInfo
)
declare @Guid varchar(100) = upper('eed5a3cb-fb2b-4e81-8b99-a0ea10fde10d')
declare @Val varchar(100) = 'Brandon.Fong'
declare @sub varchar(100) = 'Cloudcords & Kiran username'
update pi
set pi.TypeContentID = @TCID, pi.ID = @PIID, pi.GUID = @Guid, pi.Value = @Val, pi.Subject = @sub
	from PersonalInfo pi
	where
		pi.id in (13)

select * from PersonalInfo 