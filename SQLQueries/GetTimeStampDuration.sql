select 
CONVERT(VARCHAR(10), GETDATE(), 101)[Date],
isnull(TimeOut.EventDate,GETDATE())[Max Time],
isnull(Timein.EventDate,0)[Min Time],
CONVERT(varchar,isnull(TimeOut.EventDate,GETDATE())-isnull(Timein.EventDate,0), 8) [Time]
from (select * from Calendar where TypeContentID = (select id from TypeContent where ExternalID = 'TimeStampIn'))TimeIn
full outer join (select * from Calendar where TypeContentID = (select id from TypeContent where ExternalID = 'TimeStampOut'))TimeOut
on TimeIn.ExternalID = TimeOut.ExternalID
where (CONVERT(VARCHAR(10), TimeIn.EventDate, 101) = CONVERT(VARCHAR(10), GETDATE(), 101))