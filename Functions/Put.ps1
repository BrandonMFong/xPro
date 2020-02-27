
Param([String[]] $dir, [String[]]$file)
#[xml]$x = Get-Content $ConfigFile;
[bool]$ProcessExecuted = $false;
	
foreach ($Directory in $XMLReader.Machine.Directories.Directory)
{
	if($Directory.alias -eq $dir)
	{
		move-item $file $Directory.InnerXml; $ProcessExecuted = $true;
	}
	
}
if(!($ProcessExecuted))
{
	throw "Parameter '$($dir)' does match any aliases in the configuration.  Please check spelling.";
}