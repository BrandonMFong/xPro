<#
.Synopsis
`
.Description

.Parameter <Name>

.Example

.Notes

#>
param([switch]$Current)

Push-Location $PSScriptRoot;
    Import-Module ..\Modules\FunctionModules.psm1;
    $var = $(GetObjectByClass('Calendar'));

    if($Current)
    {
        $var.GetCalendarMonth();
    }

Pop-Location;
