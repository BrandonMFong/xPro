
class ToDoList
{
    [XML]$xml;
    [string]$FileName;
    [int]$Completed;
    [int]$Uncompleted;
    [Hierarchy]$Level;
    [string]$XMLFilePath;

    ToDoList($filename)
    {
        $this.FileName = $filename;
        $this.LoadList($this.FileName);
        $this.Level = [Hierarchy]::new($this.xml.Todo.HierarchyLevels.DayOfWeek, 
            $this.xml.Todo.HierarchyLevels.Item, 
            $this.xml.Todo.HierarchyLevels.SubItem);
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

    Mark() # TODO finish logic to mark done
    {
        $index = 0;
        $currentlevel = $this.xml.Todo.DayOfWeek;
        $this.LoadList($this.FileName);
        Write-Host "`n# for item, press enter to go to subitems, or q to quit`n" -ForegroundColor Green;
        while($true)
        {
            $this.ListLevel($currentlevel)
            $index = Read-Host -Prompt "Which item"
            if($index -eq 'q'){break;}
            elseif($index -ne $null){$currentlevel = $currentlevel[$index].Item;break;}
            else
            {
                Write-Host "`n# for item, press enter to go to subitems, or q to quit`n" -ForegroundColor Green;
            }
        }
        while($true)
        {
            $this.ListLevel($currentlevel)
            $index = Read-Host -Prompt "Which item"
            if($index -eq 'q'){break;}
            elseif($index -ne $null){$currentlevel = $currentlevel[$index].SubItem;break;}
            else
            {
                Write-Host "`n# for item, press enter to go to subitems, or q to quit`n" -ForegroundColor Green;
            }
        }
        while($true)
        {
            $this.ListLevel($currentlevel)
            $index = Read-Host -Prompt "Which item"
            if($index -eq 'q'){break;}
            elseif($index -ne $null){$this.ToggleDone($currentlevel[$index])}
            else
            {
                Write-Host "`n# for item, press enter to go to subitems, or q to quit`n" -ForegroundColor Green;
            }
        }
        $this.Save();
    }

    Save(){$this.xml.Save($this.XMLFilePath);}

    
    hidden LoadList($file)
    {
        Push-Location $PSScriptRoot;
            Set-Location ..\Data\;
            $this.xml = Get-Content $file;
            Get-ChildItem $file |
                ForEach-Object{$this.XMLFilePath = $_.FullName;}
        Pop-Location;
    }

    # Listing the items in the hierarchy
    hidden ListLevel($elements)
    {
        foreach($element in $elements)
        {
            $this.Evaluate_WriteElementNameAndID($element,$null)
        }
        $index = Read-Host -Prompt "Which item"
    }

    hidden ToggleDone($element)
    {
        [string]$booleanliteral = $element.done;
        if($booleanliteral.Length -eq 4){$element.done = 'false';break;}
        else{$element.done = 'true';break;}
        Write-Host "didn't break";
    }

    hidden GetDayList([string]$Day)
    {
        $this.LoadList($this.FileName);
        foreach($Days in $this.xml.Todo.DayOfWeek)
        {
            if($Day -eq $Days.name)
            {
                $this.ListItems($Days);
            }
        }
    }

    # this can be dynamic
    hidden ListItems($Days)
    {
        $this.WriteElementNameAndID($Days)
        foreach($Item in $Days.Item)
        {
            $this.WriteElementNameAndID($Item)
            foreach($SubItem in $Item.SubItem)
            {
                $this.WriteElementNameAndID($SubItem);
            }
        }
    }

    hidden WriteElementNameAndID($element)
    {
        
        switch($element.hierarchy)
        {
            $this.Level.DayOfWeek 
            {
                [string]$tab = "";
                $this.Evaluate_WriteElementNameAndID($element,$tab);
                break;
            }
            $this.Level.Item 
            {
                [string]$tab = "    ";
                $this.Evaluate_WriteElementNameAndID($element,$tab);
                break;
            }
            $this.Level.SubItem 
            {
                [string]$tab = "        ";
                $this.Evaluate_WriteElementNameAndID($element,$tab);
                break;
            }
            default {throw "something bad happened";break;}
        }
    }

    hidden Evaluate_WriteElementNameAndID($element, [string]$tab)
    {
        if($element.done -eq "true"){Write-Host "$($tab)$($element.id) - $($element.name)" -ForegroundColor Green;}
        else{Write-Host "$($tab)$($element.id) - $($element.name)" -ForegroundColor Red;}
    }
    
    hidden WriteElementNameAndID_NoWhitespace($element)
    {
        [string]$NoWhitspace="";
        switch($element.hierarchy)
        {
            $this.Level.DayOfWeek 
            {
                $this.Evaluate_WriteElementNameAndID($element,$NoWhitspace);
                break;
            }
            $this.Level.Item 
            {
                $this.Evaluate_WriteElementNameAndID($element,$NoWhitspace);
                break;
            }
            $this.Level.SubItem 
            {
                $this.Evaluate_WriteElementNameAndID($element,$NoWhitspace);
                break;
            }
            default {throw "something bad happened";break;}
        }
    }
}
class Hierarchy 
{
    [int]$DayOfWeek;
    [int]$Item;
    [int]$SubItem;
    Hierarchy($dayofweek, $item, $subitem)
    {
        $this.DayOfWeek = $dayofweek;
        $this.Item = $item;
        $this.SubItem = $subitem;
    }
}