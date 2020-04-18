function WeekList 
{
    Param([switch]$Today,[Switch]$All)
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
    
} 

function Greetings
{
    Write-Host  "__          __  _                            ____                      _             ";
    Write-Host  "\ \        / / | |                          |  _ \                    | |            ";
    Write-Host  " \ \  /\  / /__| | ___ ___  _ __ ___   ___  | |_) |_ __ __ _ _ __   __| | ___  _ __  ";
    Write-Host  "  \ \/  \/ / _ \ |/ __/ _ \| '_ `` _ \ / _ \ |  _ <| '__/ _`` | '_ \ / _`` |/ _ \| '_ \ ";
    Write-Host  "   \  /\  /  __/ | (_| (_) | | | | | |  __/ | |_) | | | (_| | | | | (_| | (_) | | | |";
    Write-Host  "    \/  \/ \___|_|\___\___/|_| |_| |_|\___| |____/|_|  \__,_|_| |_|\__,_|\___/|_| |_|";
}