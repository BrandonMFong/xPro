if '@TCExterID' = 'TimeStampIn'/*If this is an insert query for Time In, then check if you are still timed in*/
begin
	declare @TimeInCount int = (select count(*) from Calendar where ExternalID = '@CalendarExtID' /*Isolates search just for today*/
	and TypeContentID = (select id from typecontent where ExternalID = 'TimeStampIn'))
	declare @TimeOutCount int = (select count(*) from Calendar where ExternalID = '@CalendarExtID' 
	and TypeContentID = (select id from typecontent where ExternalID = 'TimeStampOut'))
	if (@TimeInCount-@TimeOutCount)<1 /*This means you are still timed in so you cannot insert*/
	begin 
		@insertquery
	end
end
else /*Else this is a time out query*/
begin
	@insertquery
end