if($XMLReader.Machine.StartScript.ClearHost -eq "true"){Clear-Host;}
Write-Host "`n";
$Hour = (Get-Date).Hour;
$Date = Get-Date;
If ($Hour -lt 12) {"`n`nGood Morning Brandon"}
ElseIf ($Hour -gt 17) {"Good Eventing Brandon"}
Else {"Good Afternoon Brandon"}
Write-Host ("`n$Date`n")
$Calendar.GetCalendarMonth();
Write-Host "`n";