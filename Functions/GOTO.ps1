
Param([String[]] $dir, [Alias('p')][Switch] $push )
#[xml]$x = Get-Content $ConfigFile;
[bool]$ProcessExecuted = $false;
	
foreach ($Directory in $XMLReader.Machine.Directories.Directory)
{
	if($Directory.alias -eq $dir)
	{
		if($push){Push-Location $Directory.InnerXml; $ProcessExecuted = $true;}
		else{Set-Location $Directory.InnerXml; $ProcessExecuted = $true;}
	}
	
}
if(!($ProcessExecuted))
{
	throw "Parameter '$($dir)' does match any aliases in the configuration.  Please check spelling.";
}
