if exists 
(
    select * from Calendar 
    where externalid = '05252020'
    and 
    (
        (IsAnnual = 1) /*If the event is an annual event*/
        or 
        (YEAR(EventDate) = YEAR(GetDate())) /*Or if this event is from this year*/
    )
	and TypeContentID = (select id from TypeContent where ExternalID = 'Event')
) 
begin 
    select 1 as [Exists] 
end