begin transaction 
-- New Column ExternalID
alter table typecontent add ExternalID varchar(50) null

update tc 
set tc.ExternalID = REPLACE(description, ' ', '')
from TypeContent tc 
select * from TypeContent
rollback transaction 
--commit transaction