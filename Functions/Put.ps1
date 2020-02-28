
Param([String[]]$File, [Alias ('Dest')][String[]] $Destination)
#[xml]$x = Get-Content $ConfigFile;
[bool]$ProcessExecuted = $false;
	
foreach ($Directory in $XMLReader.Machine.Directories.Directory)
{
	if($Directory.alias -eq $Destination)
	{
		move-item $File $Directory.InnerXml; $ProcessExecuted = $true;
	}
	
}
if(!($ProcessExecuted))
{
	throw "Parameter '$($Destination)' does match any aliases in the configuration.  Please check spelling.";
}