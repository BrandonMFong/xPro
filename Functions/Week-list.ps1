<#
.Synopsis
	An interface to work with the list configuration 
.Description
    With this list you can toggle switches to access the essential parts of the List class.
.Notes
    You must have the list class configured and it must be named 'Todo'
#>
Param([switch]$Tomorrow,[Switch]$All,[switch]$Mark,[switch]$Delete,[switch]$Add,[switch]$Yesterday)
Import-Module $($PSScriptRoot + "\..\Modules\FunctionModules.psm1") -Scope Global;
$x = $(Get-Variable "Todo").Value
if($Tomorrow)
{
    switch (((Get-Date).AddDays(1)).DayOfWeek)
    {
        "Monday" {$x.Monday.ListOut()}
        "Tuesday" {$x.Tuesday.ListOut()}
        "Wednesday" {$x.Wednesday.ListOut()}
        "Thursday" {$x.Thursday.ListOut()}
        "Friday" {$x.Friday.ListOut()}
        "Saturday" {$x.Saturday.ListOut()}
        "Sunday" {$x.Sunday.ListOut()}
        default{Write-Host "`n";}
    }
    break;
}
if($Yesterday)
{
    switch (((Get-Date).AddDays(-1)).DayOfWeek)
    {
        "Monday" {$x.Monday.ListOut()}
        "Tuesday" {$x.Tuesday.ListOut()}
        "Wednesday" {$x.Wednesday.ListOut()}
        "Thursday" {$x.Thursday.ListOut()}
        "Friday" {$x.Friday.ListOut()}
        "Saturday" {$x.Saturday.ListOut()}
        "Sunday" {$x.Sunday.ListOut()}
        default{Write-Host "`n";}
    }
    break;
}
if($Mark)
{
    switch ((Get-Date).DayOfWeek)
    {
        "Monday" {$(Get-Variable 'MonList').Value.Mark();}
        "Tuesday" {$(Get-Variable 'TueList').Value.Mark();}
        "Wednesday" {$(Get-Variable 'WedList').Value.Mark();}
        "Thursday" {$(Get-Variable 'ThuList').Value.Mark();}
        "Friday" {$(Get-Variable 'FriList').Value.Mark();}
        "Saturday" {$(Get-Variable 'SatList').Value.Mark();}
        "Sunday" {$(Get-Variable 'SunList').Value.Mark();}
        default{Write-Host "`n";}
    }
    break;
}
if($Delete)
{
    switch ((Get-Date).DayOfWeek)
    {
        "Monday" {$(Get-Variable 'MonList').Value.Delete();}
        "Tuesday" {$(Get-Variable 'TueList').Value.Delete();}
        "Wednesday" {$(Get-Variable 'WedList').Value.Delete();}
        "Thursday" {$(Get-Variable 'ThuList').Value.Delete();}
        "Friday" {$(Get-Variable 'FriList').Value.Delete();}
        "Saturday" {$(Get-Variable 'SatList').Value.Delete();}
        "Sunday" {$(Get-Variable 'SunList').Value.Delete();}
        default{Write-Host "`n";}
    }
    break;
}
if($Add)
{
    switch ((Get-Date).DayOfWeek)
    {
        "Monday" {$(Get-Variable 'MonList').Value.Add();}
        "Tuesday" {$(Get-Variable 'TueList').Value.Add();}
        "Wednesday" {$(Get-Variable 'WedList').Value.Add();}
        "Thursday" {$(Get-Variable 'ThuList').Value.Add();}
        "Friday" {$(Get-Variable 'FriList').Value.Add();}
        "Saturday" {$(Get-Variable 'SatList').Value.Add();}
        "Sunday" {$(Get-Variable 'SunList').Value.Add();}
        default{Write-Host "`n";}
    }
    break;
}
if($All)
{
    $x.Monday.ListOut();
    $x.Tuesday.ListOut();
    $x.Wednesday.ListOut();
    $x.Thursday.ListOut();
    $x.Friday.ListOut();
    $x.Saturday.ListOut();
    $x.Sunday.ListOut();
    break;
}
else
{
    switch ((Get-Date).DayOfWeek)
    {
        "Monday" {$x.Monday.ListOut()}
        "Tuesday" {$x.Tuesday.ListOut()}
        "Wednesday" {$x.Wednesday.ListOut()}
        "Thursday" {$x.Thursday.ListOut()}
        "Friday" {$x.Friday.ListOut()}
        "Saturday" {$x.Saturday.ListOut()}
        "Sunday" {$x.Sunday.ListOut()}
        default{Write-Host "`n";}
    }
}
