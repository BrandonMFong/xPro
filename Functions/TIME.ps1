<#
.Synopsis
	Keeps time stamps in a .csv file or in the local database
.Description
	
.Notes
	Default Report is week
#>
Param
(
	[Alias('In')][Switch]$Login, 
	[Alias('Out')][Switch]$Logout, 
	[Alias('V')][Switch]$View, 
	[Alias('C')][Switch]$Clear, 
	[Alias('A')][Switch]$Archive, 
	[Alias('R')][Switch]$Report, 
	[Alias('T')][Switch]$Today, 
	[Alias('W')][Switch]$Week, 
	[Switch]$All, 
	[Alias('E')][Switch]$Export
)
Import-Module $($PSScriptRoot + "\..\Modules\FunctionModules.psm1") -Scope Local;
$var = GetObjectByClass('Calendar');

if($Report) # Default is week view
{
	if($Today){$var.Report("$((Get-Date).ToString('MM/dd/yyyy')) 00:00:00.0000000","$((Get-Date).AddDays(1).ToString('MM/dd/yyyy')) 00:00:00.0000000");} # this returns two tables
	elseif($Week)
	{
		Write-Host "`nView: Week" -ForegroundColor Gray;
		$var.Report("$($var.ThisWeek.su.Date.ToString('MM/dd/yyyy')) 00:00:00.0000000","$($var.ThisWeek.sa.AddDays(1).Date.ToString('MM/dd/yyyy')) 00:00:00.0000000");
	}
	elseif($All){$var.Report();}
	else
	{
		Write-Host "`nView: Week" -ForegroundColor Gray;
		$var.Report("$($var.ThisWeek.su.Date.ToString('MM/dd/yyyy')) 00:00:00.0000000","$($var.ThisWeek.sa.AddDays(1).Date.ToString('MM/dd/yyyy')) 00:00:00.0000000");
	}
	break;
}
if($Export){$var.Export();break;}
if([string]::IsNullOrEmpty($var.TimeStampFilePath))# Database config
{
	if($Login){$var.TimeIn();}
	if($Logout){$var.TimeOut();}
	if($View)
	{
		if($Week){Write-Host "Log Time: $($var.GetTimeStampDuration("$($var.ThisWeek.su.Date.ToString('MM/dd/yyyy')) 00:00:00.0000000","$($var.ThisWeek.sa.AddDays(1).Date.ToString('MM/dd/yyyy')) 00:00:00.0000000"))";}
		else{Write-Host "Log Time: $($var.GetTimeStampDuration())";}
	}
}
