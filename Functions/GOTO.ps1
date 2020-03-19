
Param([String[]] $dir, [Alias('p')][Switch] $push, [switch]$AddDirectory)
[bool]$ProcessExecuted = $false;

if($AddDirectory)
{
	$PathToAdd = (Get-Location).path; # Get the directory you are adding
	$XMLFile = $env:COMPUTERNAME.ToString() + ".xml"; 
	Push-Location $PSScriptRoot;
		Get-ChildItem $('..\Config\' + $XMLFile) |
			ForEach-Object {$PathToXMLFile = $_.FullName;} # Get path to xml file
		[xml]$x = Get-Content $PathToXMLFile;
		$add = $x.CreateElement("Directory"); 
		$Alias = Read-Host -Prompt "Set Alias";
		$add.SetAttribute("alias", $Alias);
		$add.InnerXml = $PathToAdd;
		$x.Machine.Directories.AppendChild($add);
		$x.Save($PathToXMLFile);
	Pop-Location;
}
	
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
