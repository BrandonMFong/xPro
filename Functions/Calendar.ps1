<#
.Synopsis
    Utilizes the Calendar class to display months
.Description
    
.Parameter <Name>

.Example

.Notes
    
#>
param
(
    [ValidateSet(
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
    )]
    [string]$month,
    [switch]$Current,
    [switch]$Events,
    [switch]$InsertEvents
)
Import-Module $($PSScriptRoot + "\..\Modules\FunctionModules.psm1");
$var = $(GetObjectByClass('Calendar'));

if($Events)
{
    Write-Host "`n";
    $var.Events();
    Write-Host "`n";
    break;
}
if($InsertEvents){$var.InsertEvents();break;}
else 
{
    Write-Host "`n";
    switch ($month)
    {
        "January"{$var.GetMonth("January");break;}
        "February"{$var.GetMonth("February");break;}
        "March"{$var.GetMonth("March");break;}
        "April"{$var.GetMonth("April");break;}
        "May"{$var.GetMonth("May");break;}
        "June"{$var.GetMonth("June");break;}
        "July"{$var.GetMonth("July");break;}
        "August"{$var.GetMonth("August");break;}
        "September"{$var.GetMonth("September");break;}
        "October"{$var.GetMonth("October");break;}
        "November"{$var.GetMonth("November");break;}
        "December"{$var.GetMonth("December");break;}
        default{$var.GetMonth();break;}
    }
    Write-Host "`n";
}
