
Write-Host "`n";
$Hour = (Get-Date).Hour;
If ($Hour -lt 12) {"`n`nGood Morning Brandon`n"}
ElseIf ($Hour -gt 17) {"Good Eventing Brandon`n"}
Else {"Good Afternoon Brandon`n"}
$Calendar.GetCalendarMonth();
Write-Host "`n";