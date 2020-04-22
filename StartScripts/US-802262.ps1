# Script after profile loads
 	Param([switch]$ClearScreen)
	if($ClearScreen){Clear-Host;}
	Greetings;
	Write-Host "`n";
	Get-Calendar;
	Write-Host "`n[Special Days]" -ForegroundColor Green;
	$Calendar.SpecialDays();
	Write-Host "`n[Emails]" -ForegroundColor Green;
	Get-Email;
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
	Week-List;
	Write-Host "`n1. Start`n"
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
			goto repo -push;
			Get-ChildItem |
			Foreach-Object {Set-Location $_.Fullname;write-warning (Get-Location).Path;git pull --rebase;Set-Location ..;}
			pop-location;
		}
	}