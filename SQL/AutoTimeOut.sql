/*Bounds*/
declare @TimeOutTypeContentID int = (select id from TypeContent where ExternalID = 'TimeStampOut')
declare @RecentID int = (select MAX(ID) from Calendar)

insert into Calendar
select /* all fixed data*/
(ROW_NUMBER() over(order by TimeIn.EventDate))+@RecentID ID, /*New ID*/
@TimeOutTypeContentID TypeContentID, 
TimeIn.ExternalID ExternalID, 
CONCAT('AUTO TIME OUT ON: ',TimeIn.Subject) Subject, 
CONVERT(datetime,CONCAT(CONVERT(date, TimeIn.EventDate), ' 23:59:59.000')) EventDate, /* Put at end of the day */
0 IsAnnual
from 
(
	select * from Calendar
	where TypeContentID = (select id from TypeContent where ExternalID = 'TimeStampIn')
)TimeIn 
left join 
(
	select * from Calendar
	where TypeContentID = @TimeOutTypeContentID
)TimeOut on TimeIn.ExternalID = TimeOut.ExternalID
where TimeOut.ID is null /* Means no time out stamp exists */
and CONVERT(date, TimeIn.EventDate) < CONVERT(date, GETDATE()) /* Make sure you aren't executing an auto time out on today's time in */
