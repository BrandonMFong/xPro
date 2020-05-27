/*Time In Data*/
declare @TimeIn TABLE (RowNum int, EventDate datetime, TypContentID int);
insert into @TimeIn
select ROW_NUMBER() over(order by id) RowNum,tic.EventDate,tic.TypeContentID
from Calendar tic 
where tic.TypeContentID = (select id from TypeContent where ExternalID = 'TimeStampIn')
order by tic.EventDate asc /*Ordering so that I number the rows correctly*/

/*Time Out Data*/
declare @TimeOut TABLE (RowNum int, EventDate datetime, TypContentID int);
insert into @TimeOut
select ROW_NUMBER() over(order by id) RowNum,toc.EventDate,toc.TypeContentID
from Calendar toc 
where toc.TypeContentID = (select id from TypeContent where ExternalID = 'TimeStampOut')
order by toc.EventDate asc

select  
convert(varchar(10), TimeIn.EventDate, 101) [Date],
convert(varchar, TimeIn.EventDate, 9) [Time In],
case 
	when TimeOut.EventDate is null then 
	(
		select 'Still Timed in'
	)
	else convert(varchar, TimeOut.EventDate, 9)
end 
[Time Out]
from @TimeIn TimeIn 
full outer join @TimeOut TimeOut 
on TimeIn.RowNum = TimeOut.RowNum