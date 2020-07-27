<#
.Synopsis
	This relates an alias to a directory and sets the directory location to alias/dir relationship
.Description
	Useful to easily jump to a directory without writing out the whole path
.Parameter push
	Push-Location instead of set-location
.Example
	Goto CDrive -p 
.Notes

#>
Param([String]$dir, [Alias('p')][Switch]$push)
Import-Module $($PSScriptRoot + "\..\Modules\FunctionModules.psm1") -Scope Local;
[bool]$ProcessExecuted = $false;
	foreach ($Directory in $(Get-Variable 'XMLReader').Value.Machine.Directories.Directory)
	{
		if($Directory.alias -eq $dir)
		{
			[String]$result = $(Evaluate -value:$Directory -IsDirectory:$true);
			if($push){Push-Location $result; $ProcessExecuted = $true;break;}
			else{Set-Location $result; $ProcessExecuted = $true;break;}
		}
		
	}
	if(!($ProcessExecuted))
	{
		$global:LogHandler.Write("Parameter '$($dir)' does match any alias in the configuration.  Please check spelling or add another <Directory> tag");
		Write-Warning "Parameter '$($dir)' does match any alias in the configuration.  Please check spelling or add another <Directory> tag";
	}
	else{$global:LogHandler.Write("Jumped to $($result)");}
