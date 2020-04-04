<#
.Synopsis
	Get's weather data from http://wttr.in/
.Description
    Credits to https://github.com/chubin/wttr.in & 
    https://gist.github.com/PrateekKumarSingh/cf641670f89be6c8e0c3c4af73caf914#file-get-weather-ps1
.Parameter Area
    
.Example
    Weather.ps1 -Area "San Diego" -Today
.Notes
    This takes a while, this may start the idea of threading
#>

Param
(
    [string]$f=$null,
    [string]$d=$null
)

class Folder 
{
    [object[]]$FullPaths;

    Folder([Object[]]$Paths,[string]$BaseFolder)
    {
        $this.$FullPaths = $Paths;
        
    }
}

if (!(Test-Path $($PSScriptRoot + $f))){throw "$($f) does not exist."}
if (!(Test-Path $($PSScriptRoot + $d))){throw "$($d) does not exist."}


if(($null -ne $f) -and ($null -ne $d))
{
    $Folder = [Folder]::new((Get-ChildItem $((get-location).Path + "powershell\Config").FullName , (get-location).path); 
}
else 
{
    throw "Cannot move $($f) to $($d).";
}