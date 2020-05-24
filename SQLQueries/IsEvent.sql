if exists 
(
    select * from Calendar 
    where externalid = @DayString
    and 
    (
        (IsAnnual = 1) /*If the event is an annual event*/
        or 
        (YEAR(EventDate) = YEAR(GetDate())) /*Or if this event is from this year*/
    )
) 
begin 
    select 1 as [Exists] 
end