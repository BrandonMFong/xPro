# Must have Todolist configured

Param
(
    [Alias('D')][string]$Day=$null
)
Set-Location $PSScriptRoot;
    Import-Module .\FunctionModules.psm1;
    $var = $(GetObjectByClass('ToDoList'));

    switch($Day)
    {
        "Monday" {$var.ListMonday();return;}
        "Tuesday" {$var.ListTuesday();return;}
        "Wednesday" {$var.ListWednesday();return;}
        "Thursday" {$var.ListThursday();return;}
        "Friday" {$var.ListFriday();return;}
        "Saturday" {$var.ListSaturday();return;}
        "Sunday" {$var.ListSunday();return;}
        default {break;}
    }
Pop-Location;