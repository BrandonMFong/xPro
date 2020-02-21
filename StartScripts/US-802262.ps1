# Script after profile loads
    $Hour = (Get-Date).Hour;
	$Date = Get-Date;
	If ($Hour -lt 12) {"`n`nGood Morning Brandon"}
	ElseIf ($Hour -gt 17) {"Good Eventing Brandon"}
	Else {"Good Afternoon Brandon"}
	Write-Host ("`n$Date`n")
	Write-Host ("1. Start`n")
	$start = Read-Host 
	if($start -eq "1")
	{
		if(((Get-Date).Day -eq 1)) {Time -Archive; Time -Login;}
		Outlook;
		Tix; # The ticket app 
		if(($Date.Day%2) -eq 0){BankUrl -Reverse;}
		else {BankUrl;}
		Spotify;
		goto main;
	}