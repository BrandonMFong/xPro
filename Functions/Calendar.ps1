<#
.Synopsis
    Utilizes the Calendar class to display months
.Description
    
.Parameter <Name>

.Example

.Notes
    
#>
param([string]$month,[switch]$Current,[switch]$SpecialDays,[switch]$InsertEvents)
Import-Module $($PSScriptRoot + "\..\Modules\FunctionModules.psm1");
$var = $(GetObjectByClass('Calendar'));

if($SpecialDays)
{
    Write-Host "`n";
    $var.SpecialDays();
    Write-Host "`n";
}
if($InsertEvents)
{
    $var.InsertEvents();
}
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
