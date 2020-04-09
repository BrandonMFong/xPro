function WeekList 
{
    Param([switch]$Today)
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
    
} 