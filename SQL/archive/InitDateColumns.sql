begin transaction 

update PersonalInfo
set LastAccessDate = GETDATE()
where Guid = 'F0349632-EABF-49D3-BCDD-E2D801FEDD08'

select * from PersonalInfo order by id desc

rollback transaction