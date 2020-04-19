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
Param([String[]]$File, [Alias ('Dest')][String[]] $Destination)
[bool]$ProcessExecuted = $false;
	
foreach ($Directory in $XMLReader.Machine.Directories.Directory)
{
	if($Directory.alias -eq $Destination)
	{
		move-item $File $(EvaluateVar -value $Directory); $ProcessExecuted = $true;
	}
	
}
if(!($ProcessExecuted))
{
	throw "Parameter '$($Destination)' does match any aliases in the configuration.  Please check spelling.";
}