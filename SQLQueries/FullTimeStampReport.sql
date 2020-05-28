/*Bounds*/
 /*declare @MinDate datetime2(7) = '5/1/2020 00:00:00.0000000'*/
 /*declare @MaxDate datetime2(7) = '5/30/2020 00:00:00.0000000'*/
 declare @MinDate datetime2(7) = @MinDateExt
 declare @MaxDate datetime2(7) = @MaxDateExt


/*Time In Data*/
declare @TimeIn TABLE (RowNum int, EventDate datetime, TypContentID int);
insert into @TimeIn
select ROW_NUMBER() over(order by id) RowNum,tic.EventDate,tic.TypeContentID
from Calendar tic 
where tic.TypeContentID = (select id from TypeContent where ExternalID = 'TimeStampIn')
and tic.EventDate between @MinDate and @MaxDate
order by tic.EventDate asc /*Ordering so that I number the rows correctly*/

/*Time Out Data*/
declare @TimeOut TABLE (RowNum int, EventDate datetime, TypContentID int);
insert into @TimeOut
select ROW_NUMBER() over(order by id) RowNum,toc.EventDate,toc.TypeContentID
from Calendar toc 
where toc.TypeContentID = (select id from TypeContent where ExternalID = 'TimeStampOut')
and toc.EventDate between @MinDate and @MaxDate
order by toc.EventDate asc

select  
convert(varchar(10), TimeIn.EventDate, 101) [Date],
convert(varchar, TimeIn.EventDate, 20)[TimeIn],
case 
	when TimeOut.EventDate is null then (select '--:--:-- --')
	else convert(varchar, TimeOut.EventDate, 20)
end [TimeOut]
from @TimeIn TimeIn 
full outer join @TimeOut TimeOut 
on TimeIn.RowNum = TimeOut.RowNum