Param([switch]$ClearScreen)
if($ClearScreen){Clear-Host;}
Import-Module ($PSScriptRoot + "\StartMods\BRANDONMFONG.psm1")
Greetings;
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
WeekList -Today;

