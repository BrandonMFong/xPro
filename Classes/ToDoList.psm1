
class ToDoList
{
    [XML]$xml;
    [string]$FileName;
    [int]$Completed;
    [int]$Uncompleted;

    ToDoList($filename)
    {
        $this.FileName = $filename;
        $this.LoadList($this.FileName);
    }

    ListWeek()
    {
        $this.LoadList($this.FileName);
        foreach($Days in $this.xml.Todo.DayOfWeek)
        {
            $this.ListItems($Days);
        }
    }

    ListMonday(){$this.LoadList($this.FileName);$this.GetDayList("Monday");}
    ListTuesday(){$this.LoadList($this.FileName);$this.GetDayList("Tuesday");}
    ListWednesday(){$this.LoadList($this.FileName);$this.GetDayList("Wednesday");}
    ListThursday(){$this.LoadList($this.FileName);$this.GetDayList("Thursday");}
    ListFriday(){$this.LoadList($this.FileName);$this.GetDayList("Friday");}
    ListSaturday(){$this.LoadList($this.FileName);$this.GetDayList("Saturday");}
    ListSunday(){$this.LoadList($this.FileName);$this.GetDayList("Sunday");}
    
    hidden LoadList($file)
    {
        Push-Location $PSScriptRoot;
            $this.xml = Get-Content $('..\Data\' + $file);
        Pop-Location;
    }

    hidden GetDayList([string]$Day)
    {
        $this.LoadList($this.FileName);
        foreach($Days in $this.xml.Todo.DayOfWeek)
        {
            if($Day -eq $Days.day)
            {
                $this.ListItems($Days);
            }
        }
    }

    hidden ListItems($Days)
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