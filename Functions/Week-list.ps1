Param([switch]$Today,[Switch]$All)
Import-Module $($PSScriptRoot + "\..\Modules\FunctionModules.psm1") -Scope Local;
if($Today)
{
    switch ((Get-Date).DayOfWeek)
    {
        "Monday" {$Todo.Monday.ListOut()}
        "Tuesday" {$Todo.Tuesday.ListOut()}
        "Wednesday" {$Todo.Wednesday.ListOut()}
        "Thursday" {$Todo.Thursday.ListOut()}
        "Friday" {$Todo.Friday.ListOut()}
        "Saturday" {$Todo.Saturday.ListOut()}
        "Sunday" {$Todo.Sunday.ListOut()}
        default{Write-Host "`n";}
    }
}
if($All)
{
    $Todo.Monday.ListOut();
    $Todo.Tuesday.ListOut();
    $Todo.Wednesday.ListOut();
    $Todo.Thursday.ListOut();
    $Todo.Friday.ListOut();
    $Todo.Saturday.ListOut();
    $Todo.Sunday.ListOut();
}
