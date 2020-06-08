declare @TimeInCount int = (select count(*) from Calendar where ExternalID = '@CalendarExtID' /*Isolates search just for today*/
and TypeContentID = (select id from typecontent where ExternalID = 'TimeStampIn'))
declare @TimeOutCount int = (select count(*) from Calendar where ExternalID = '@CalendarExtID' 
and TypeContentID = (select id from typecontent where ExternalID = 'TimeStampOut'))

if '@TCExterID' = 'TimeStampIn'/*If this is an insert query for Time In, then check if you are still timed in*/
begin
	if (@TimeInCount-@TimeOutCount)<1 /*This means you are still timed in so you cannot insert*/
	begin 
		@insertquery
	end
end
if '@TCExterID' = 'TimeStampOut'
begin
	if @TimeInCount > @TimeOutCount /*Only Time out if there is a time in*/
	begin 
		@insertquery
	end
end