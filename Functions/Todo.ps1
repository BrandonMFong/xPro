# Must have Todolist configured

Param
(
    [Alias('D')][string]$Day=$null
)
Set-Location $PSScriptRoot;
    Import-Module ..\Modules\FunctionModules.psm1;
    $var = $(GetObjectByClass('ToDoList'));

    switch($Day)
    {
        ("Monday") {$var.Monday();return;}
        ("Tuesday") {$var.Tuesday();return;}
        ("Wednesday") {$var.Wednesday();return;}
        ("Thursday") {$var.Thursday();return;}
        ("Friday") {$var.Friday();return;}
        ("Saturday") {$var.Saturday();return;}
        ("Sunday"){$var.Sunday();return;}
        ("Today") {$var.Today();return;}
        default {break;}
    }
Pop-Location;