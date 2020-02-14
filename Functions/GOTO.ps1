
Param([String[]] $dir, [Alias('p')][Switch] $push )
[xml]$x = Get-Content $ConfigPath;
	
foreach ($Directory in $x.Machine.Directories.Directory)
{
	if($Directory.alias -eq $dir)
	{
		if($push){Push-Location $Directory.InnerXml;}
		else{Set-Location $Directory.InnerXml;}
	}
}
