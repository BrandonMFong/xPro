Param([switch]$ClearScreen)
if($ClearScreen){Clear-Host;}
Greetings;
Write-Host "`n";
# Get-Weather -Today -Area "San Diego"
$Calendar.GetCalendarMonth();
Write-Host "`n[Special Days]" -ForegroundColor Green;
$Calendar.SpecialDays();
Write-Host "`n[Emails]" -ForegroundColor Green;
Get-Email -ListInbox;
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
Week-List -Today;

