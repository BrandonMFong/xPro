<#
.Synopsis
    Utilizes the Calendar class to display months
.Description
    
.Parameter <Name>

.Example

.Notes
    TODO finish calendar class with displaying special days
#>
param([string]$month,[switch]$Current,[switch]$SpecialDays)

Push-Location $PSScriptRoot;
    Import-Module ..\Modules\FunctionModules.psm1;
    $var = $(GetObjectByClass('Calendar'));

    if($Current)
    {
        $var.GetCalendarMonth();
    }
    else 
    {
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
    }

Pop-Location;
