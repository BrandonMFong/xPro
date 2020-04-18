<#
.Synopsis
    Utilizes the SQL class
.Description
    Uses methods Query() and InputCopy()
.Parameter inputstring
    Runs a Read-Host command to read users query
.Parameter Decode
    Passes in a Guid and gets row related to it
.Example
    Query -Decode 79aeb6e5-7204-41b7-ac8b-f70b92ab0bcd
.Notes
    This is only useful if you have a sql server database like PersonalInfo with ID, Guid, Value, etc.
    TODO figure out how to create database from powershell
#>
param([alias('is')][switch]$inputstring,[string]$Decode="pass")
Push-Location $PSScriptRoot;
    Import-Module ..\Modules\FunctionModules.psm1;
    $var = $(GetObjectByClass('SQL'));
    if(IsNotPass($Decode)){$var.InputCopy($Decode);}
    elseif($inputstring)
    {
        $x = Read-Host -Prompt "Query";
        $var.query($x);
    }
    else{Write-Host "Nothing passed" -foregroundcolor Red};
Pop-Location;
