Param([switch]$ClearScreen)
if($ClearScreen){Clear-Host;}
Greetings -Big;
Get-Calendar;
Write-Host "`n[Special Days]" -ForegroundColor Green;
$Calendar.SpecialDays();
Write-Host "`n[Emails]" -ForegroundColor Green;
Get-Email -BoundedList;
Week-List;

