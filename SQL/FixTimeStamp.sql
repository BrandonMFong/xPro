/*Time In Data*/
declare @TimeIn TABLE 
(RowNum int, ID int, TypContentID int, ExternalID varchar(100), Subject varchar(100), EventDate datetime, IsAnnual bit);
insert into @TimeIn
select ROW_NUMBER() over(order by id) RowNum,tic.* from Calendar tic 
where tic.TypeContentID = (select id from TypeContent where ExternalID = 'TimeStampIn')
order by tic.EventDate asc /*Ordering so that I number the rows correctly*/

/*Time Out Data*/
declare @TimeOut TABLE 
(RowNum int, ID int, TypContentID int, ExternalID varchar(100), Subject varchar(100), EventDate datetime, IsAnnual bit);
insert into @TimeOut
select ROW_NUMBER() over(order by id) RowNum,toc.* from Calendar toc 
where toc.TypeContentID = (select id from TypeContent where ExternalID = 'TimeStampOut')
order by toc.EventDate asc


declare @TimeFix TABLE 
(RowNum int, ID int, TypContentID int, ExternalID varchar(100), Subject varchar(100), EventDate datetime, IsAnnual bit);
insert into @TimeFix
select top 1 TimeIn.* from @TimeIn TimeIn 
left join @TimeOut TimeOut 
on TimeIn.RowNum = TimeOut.RowNum
and TimeIn.ExternalID = TimeOut.ExternalID
where TimeOut.RowNum is null 
order by TimeIn.EventDate desc /* Get the most recent instance */


declare @EventDateFix datetime = dateadd(DAY, 1, Convert(date, (select EventDate from @TimeFix))) /* Get start of the next day */
declare @MaxID int = (select MAX(ID)+1 from Calendar)
declare @TCExtID int = (select id from TypeContent where ExternalID = 'TimeStampOut') 
declare @CalendarExternalID varchar(100) = (select ExternalID from @TimeFix)
declare @Subject varchar(100) = concat('[TIME OUT] Fix on Calendar ID: ',(select id from @TimeFix))
declare @IsAnnual bit = 0
insert into Calendar values
(
	@MaxID,@TCExtID,@CalendarExternalID,
	@Subject,(select EventDate from @TimeFix),@IsAnnual
)
/*This will insert again.  I need to put a check on it*/