# Script after profile loads
 	Greetings;
	Get-Weather -Today -Area "San Diego"
	$Calendar.GetCalendarMonth();
	Write-Host ("`n1. Start`n")
	$start = Read-Host 
	if($start -eq "1")
	{
		if(((Get-Date).Day -eq 1)) {Time -Archive; Time -Login;}
		else{Time -Login};
		Outlook;
		Tix;
		if(($Date.Day%2) -eq 0){BankUrl -Reverse;}
		else {BankUrl;}
		global;
		$p = Read-Host -Prompt "Are you VPN'd in?(yes/no)";
		if($p -eq "yes")
		{
			goto repo;
			Get-ChildItem |
			Foreach-Object {Set-Location $_.Fullname;write-warning (Get-Location).Path;git pull --rebase;Set-Location ..;}
			pop-location;
		}
	}