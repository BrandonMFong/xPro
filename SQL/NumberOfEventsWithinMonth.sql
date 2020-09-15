select count(*) COUNT 
from Calendar c 
where TypeContentID = (select ID from TypeContent where ExternalID = 'Event') 
and c.EventDate between @mindate and @maxdate
/* and c.EventDate between '6/1/2020' and '6/30/2020' */