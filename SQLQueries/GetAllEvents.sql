select * from Calendar where TypeContentID = (select id from typecontent where externalid = 'Event') /*Get event type*/
and ((IsAnnual = 1) /*If the event is an annual event*/
or (EventDate >= CONVERT(DATE,GetDate())) /*Get all up to date events*/)