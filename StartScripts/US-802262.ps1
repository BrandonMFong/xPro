# Script after profile loads
 	Write-Host "`n";
	$Hour = (Get-Date).Hour;
	$Date = Get-Date;
	If ($Hour -lt 12) {"`n`nGood Morning Brandon"}
	ElseIf ($Hour -gt 17) {"Good Evening Brandon"}
	Else {"Good Afternoon Brandon"}
	Get-Weather -Today -Area "San Diego"
	$Calendar.GetCalendarMonth();
	Write-Host ("`n1. Start`n")
	$start = Read-Host 
	if($start -eq "1")
	{
		if(((Get-Date).Day -eq 1)) {Time -Archive; Time -Login;}
		else{Time -Login};
		Outlook;
		Tix; # The ticket app 
		if(($Date.Day%2) -eq 0){BankUrl -Reverse;}
		else {BankUrl;}
		$p = Read-Host -Prompt "Are you VPN'd in?";
		global;
		if($p -eq "yes")
		{
			goto repo;
			Get-ChildItem |
			Foreach-Object {Set-Location $_.Fullname;write-warning (Get-Location).Path;git pull --rebase;Set-Location ..;}
		}
		goto main;
		Write-Host "Inbox count: " -NoNewLine;
		Write-Host "$(Get-Email -Count)" -ForegroundColor Cyan -NoNewLine;
	}