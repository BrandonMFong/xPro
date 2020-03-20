<#
.Synopsis
`
.Description

.Parameter <Name>

.Example

.Notes

#>
param([switch]$Google,[switch]$Sharepoint,[switch]$Dictionary,[switch]$Youtube)
Push-Location $PSScriptRoot;
    Import-Module ..\Modules\FunctionModules.psm1;
    $var = $(GetObjectByClass('Web'));

    if($Google)
    {
        $v = read-host -prompt "Google"
        $var.Google($v);
    }
    elseif($Sharepoint)
    {
        $v = read-host -prompt "Sharepoint"
        $var.Sharepoint($v);
    }
    elseif($Dictionary)
    {
        $v = read-host -prompt "Dictionary"
        $var.Dictionary($v);
    }
    elseif($Youtube)
    {
        $v = read-host -prompt "Youtube"
        $var.Youtube($v);
    }
    else{throw "Nothing searched";}

Pop-Location