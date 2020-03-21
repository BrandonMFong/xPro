<#
.Synopsis
    Utilizes the Calendar class to display months
.Description
    
.Parameter <Name>

.Example

.Notes
    TODO finish calendar class with displaying special days
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
