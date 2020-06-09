<#
.Synopsis
	A spin off of goto.ps1, instead uses the same aliases to open directories.
.Description
	Opens directory
#>
Param([Alias ('Dest')][String]$Destination)
Import-Module $($PSScriptRoot + "\..\Modules\FunctionModules.psm1") -Scope Local;
[bool]$ProcessExecuted = $false;
	
foreach ($Directory in $XMLReader.Machine.Directories.Directory)
{
	if($Directory.alias -eq $Destination){Start-Process $(Evaluate -value:$Directory -IsDirectory:$true); $ProcessExecuted = $true;break;}
}
if(!($ProcessExecuted)){throw "Parameter '$($Destination)' does match any aliases in the configuration.  Please check spelling.";}