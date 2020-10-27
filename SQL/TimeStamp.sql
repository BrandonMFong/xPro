/* Count total Time In time stamps */
declare @TimeInCount int = (select count(*) from Calendar where TypeContentID = (select id from typecontent where ExternalID = 'TimeStampIn'))
/* Count total Time Out time stamps */
declare @TimeOutCount int = (select count(*) from Calendar where TypeContentID = (select id from typecontent where ExternalID = 'TimeStampOut'))
declare @FixedApplied bit = 0;

if '@TCExterID' = 'TimeStampIn'/*If this is an insert query for Time In, then check if you are still timed in*/
begin
	/* Auto fill open ended time in stamps from days before */
	/* If there are more than 1 time in stamps */
	if (@TimeInCount-@TimeOutCount)>=1 /* Even if there is an extra one in the same day, AutoTimeOut query will check it */ 
	begin 
		@AutoTimeOutQuery

		SET @FixedApplied = 1; /* Flag that this query ran */
	end
	/* If you are not currently timed in, i.e. 0 time in stamps for the day */
	if ((@TimeInCount-@TimeOutCount)<1) or (@FixedApplied = 1)
	begin 
		@insertquery
	end
	
end
if '@TCExterID' = 'TimeStampOut'
begin

	/* Recall we only time out if there is a time in, so there will never be a case where we need to fix the data here. Only in Time In scenario */
	if @TimeInCount > @TimeOutCount /*Only Time out if there is a time in*/
	begin 
		@insertquery 
	end
end