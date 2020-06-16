# Script after profile loads
 	Param([switch]$ClearScreen)
	if($ClearScreen){Clear-Host;}
	Greetings;
	Write-Host "`n";
	Get-Calendar;
	Write-Host "`n[Special Days]" -ForegroundColor Green;
	$Calendar.Events();
	Write-Host "`n[Emails]" -ForegroundColor Green;
	Get-Email -BoundedList;
	Week-List;
	ConnectNetDrive;
	Write-Host "`n1. Start`n"
	$start = Read-Host 
	if($start -eq "1")
	{
		if(((Get-Date).Day -eq 1)) {Time -Archive; Time -Login;}
		else{Time -Login};
		Outlook;
		Tix;
		Teams;
		if(($Date.Day%2) -eq 0){BankUrl -Reverse;}
		else {BankUrl;}
		global;
		$p = Read-Host -Prompt "Are you VPN'd in?(yes/no)";
		if($p -eq "yes"){Pull-CC;}
	}