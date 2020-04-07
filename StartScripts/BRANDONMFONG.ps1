
Write-Host "`n";
$Hour = (Get-Date).Hour;
If ($Hour -lt 12) {"`n`nGood Morning Brandon`n"}
ElseIf ($Hour -gt 17) {"Good Eventing Brandon`n"}
Else {"Good Afternoon Brandon`n"}
Get-Weather -Today -Area "San Diego"
$Calendar.GetCalendarMonth();
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