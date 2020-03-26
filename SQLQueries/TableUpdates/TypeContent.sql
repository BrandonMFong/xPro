begin transaction 
-- New Column ExternalID
alter table typecontent add ExternalID varchar(50) null
rollback transaction 
--commit transaction