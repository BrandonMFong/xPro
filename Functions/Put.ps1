<#
.Synopsis
	A spin off of goto.ps1, instead uses the same aliases to put files to the directory specified.
.Description
	Puts files to a directory
.Parameter File
	File you are moving
.Parameter Destination
	The directory you are putting it in
.Example
	Puty -File sample.txt -Destination ~\Downloads
.Notes
	This reads the items under <Directories> in your xml file
#>
Param([String]$File, [Alias ('Dest')][String[]] $Destination)
Import-Module $($PSScriptRoot + "\..\Modules\FunctionModules.psm1") -Scope Local;
[System.Xml.XmlDocument]$x = $(_GetUserConfig -Content);
[bool]$ProcessExecuted = $false;
	
foreach ($Directory in $x.Machine.Directories.Directory)
{
	if($Directory.alias -eq $Destination)
	{
		[String]$result = $(Evaluate -value:$Directory -IsDirectory:$true);
		Move-Item $File $result; $ProcessExecuted = $true;break;
	}
	
}
if(!($ProcessExecuted))
{
	$global:LogHandler.Write("Parameter '$($Destination)' does match any alias in the configuration.  Please check spelling or add another <Directory> tag");
	Write-Warning "Parameter '$($Destination)' does match any alias in the configuration.  Please check spelling or add another <Directory> tag";
}
else{$global:LogHandler.Write("Put $($File) $($result)");}