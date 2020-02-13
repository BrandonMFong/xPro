# TODO read through xml objects
Param([String[]] $dir, [Alias('p')][Switch] $push )
[xml]$x = Get-Content $ConfigPath;
	
	foreach ($Directory in $x.BrandonMFong.Directories.Directory)
	{
		if($Directory.alias -eq $dir)
		{
			if($push){Push-Location $Directory.InnerXml;}
			else{Set-Location $Directory.InnerXml;}
		}
	}
