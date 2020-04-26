Param([switch]$Tomorrow,[Switch]$All,[switch]$EditToday,[switch]$Yesterday)
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
