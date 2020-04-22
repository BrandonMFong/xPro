Param([switch]$Tomorrow,[Switch]$All,[switch]$EditToday)
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
if($EditToday)
{
    LoadObjects -NoVerbose;
    switch ((Get-Date).DayOfWeek)
    {
        "Monday" {$(Get-Variable 'MonList').Value.Edit();}
        "Tuesday" {$(Get-Variable 'TueList').Value.Edit();}
        "Wednesday" {$(Get-Variable 'WedList').Value.Edit();}
        "Thursday" {$(Get-Variable 'ThuList').Value.Edit();}
        "Friday" {$(Get-Variable 'FriList').Value.Edit();}
        "Saturday" {$(Get-Variable 'SatList').Value.Edit();}
        "Sunday" {$(Get-Variable 'SunList').Value.Edit();}
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
