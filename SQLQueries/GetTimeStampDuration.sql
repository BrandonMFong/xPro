select 
CONVERT(varchar,TimeOut.EventDate-Timein.EventDate, 8) [Time]
from Calendar TimeIn
join Calendar TimeOut
on TimeIn.ExternalID = TimeOut.ExternalID
where TimeIn.TypeContentID = (select id from TypeContent where ExternalID = 'TimeStampIn')
and TimeOut.TypeContentID = (select id from TypeContent where ExternalID = 'TimeStampOut')
and (CONVERT(VARCHAR(10), TimeIn.EventDate, 101) = CONVERT(VARCHAR(10), GETDATE(), 101))