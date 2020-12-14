<#
.Synopsis
	A spin off of goto.ps1, instead uses the same aliases to open directories.
.Description
	Opens directory
#>
Param([Alias ('Dest')][String]$Destination)
Import-Module $($PSScriptRoot + "\..\Modules\FunctionModules.psm1") -Scope Local;
[System.Xml.XmlDocument]$x = $(_GetUserConfig -Content);
[bool]$ProcessExecuted = $false;
	
foreach ($Directory in $x.Machine.Directories.Directory)
{
	[String]$result = $(Evaluate -value:$Directory -IsDirectory:$true);
	if($Directory.alias -eq $Destination)
	{
		[String]$result = $(Evaluate -value:$Directory -IsDirectory:$true);
		Start-Process $result; $ProcessExecuted = $true;break;
	}
}
if(!($ProcessExecuted))
{
	$global:LogHandler.Write("Parameter '$($Destination)' does match any alias in the configuration.  Please check spelling or add another <Directory> tag");
	Write-Warning "Parameter '$($Destination)' does match any alias in the configuration.  Please check spelling or add another <Directory> tag";
}
else{$global:LogHandler.Write("Opened $($Destination)");}