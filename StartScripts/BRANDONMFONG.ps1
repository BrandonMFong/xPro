
Write-Host "`n";
Get-Weather -Today -Area "San Diego"
$Calendar.GetCalendarMonth();
Write-Host "`n[Special Days]" -ForegroundColor Green;
$Calendar.SpecialDays();
$x = 
@{
    Monday = $MonList;
    Tuesday = $TueList;
    Wednesday = $WedList;
    Thursday = $ThuList;
    Friday = $FriList;
    Saturday = $SatList;
    Sunday = $SunList
} 
New-Variable -Name "Todo" -Value $x -Scope Global -Force;
switch ((Get-Date).DayOfWeek)
{
    "Monday" {$Todo.Monday.ListOut()}
    "Tuesday" {$Todo.Tuesday.ListOut()}
    "Wednesday" {$Todo.Wednesday.ListOut()}
    "Thursday" {$Todo.Thursday.ListOut()}
    "Friday" {$Todo.Friday.ListOut()}
    "Saturday" {$Todo.Saturday.ListOut()}
    "Sunday" {$Todo.Sunday.ListOut()}
    default{Write-Host "`n";}
}