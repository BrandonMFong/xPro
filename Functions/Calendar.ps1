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
        "January"{$var.GetCalendarMonth("January");break;}
        "February"{$var.GetCalendarMonth("February");break;}
        "March"{$var.GetCalendarMonth("March");break;}
        "April"{$var.GetCalendarMonth("April");break;}
        "May"{$var.GetCalendarMonth("May");break;}
        "June"{$var.GetCalendarMonth("June");break;}
        "July"{$var.GetCalendarMonth("July");break;}
        "August"{$var.GetCalendarMonth("August");break;}
        "September"{$var.GetCalendarMonth("September");break;}
        "October"{$var.GetCalendarMonth("October");break;}
        "November"{$var.GetCalendarMonth("November");break;}
        "December"{$var.GetCalendarMonth("December");break;}
        default{$var.GetCalendarMonth();break;}
    }
    Write-Host "`n";
}
