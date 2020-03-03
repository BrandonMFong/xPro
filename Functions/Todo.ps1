# Must have Todolist configured

Param
(
    [Alias('D')][string]$Day=$null
)

switch($Day)
{
    "Monday" {$Todo.ListMonday();return;}
    "Tuesday" {$Todo.ListTuesday();return;}
    "Wednesday" {$Todo.ListWednesday();return;}
    "Thursday" {$Todo.ListThursday();return;}
    "Friday" {$Todo.ListFriday();return;}
    "Saturday" {$Todo.ListSaturday();return;}
    "Sunday" {$Todo.ListSunday();return;}
    default {break;}
}
