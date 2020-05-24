if not exists 
(
    select * from @tablename 
    where ExternalID = '@CalendarExtID'
    and TypeContentID = (select id from TypeContent where ExternalID = '@TCExterID')
) 
begin 
    @insertquery 
end