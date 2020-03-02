
class ToDoList
{
    [XML]$xml;
    [string]$FileName;

    ToDoList($filename)
    {
        $this.FileName = $filename;
        $this.LoadList($this.FileName);
    }

    hidden LoadList($file)
    {
        Push-Location $PSScriptRoot;
            $this.xml = Get-Content $('..\Config\' + $file);
        Pop-Location;
    }

    GetWeekList()
    {
        $this.LoadList($this.FileName);
        foreach($Days in $this.xml.Todo.DayOfWeek)
        {
            if($Days.done -eq "true"){Write-Host "$($Days.day)" -ForegroundColor Green}
            else{Write-Host "$($Days.day)" -ForegroundColor Red}
            foreach($Item in $Days.Item)
            {
                if($Item.done -eq "true"){Write-Host "  -   $($Item.name)" -ForegroundColor Green}
                else{Write-Host "  -   $($Item.name)" -ForegroundColor Red}
                foreach($Item in $Item.Item)
                {
                    if($Item.done -eq "true"){Write-Host "     -   $($Item.name)" -ForegroundColor Green}
                    else{Write-Host "     -   $($Item.name)" -ForegroundColor Red}
                }
            }
        }
    }
}