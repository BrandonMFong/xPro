
class ToDoList
{
    [XML]$xml; # Will contain xml elements
    [string]$FileName; # The data file that will contain todo list
    [string]$XMLFilePath; # Full file path
    [int]$Completed = 0; # Completed="true"
    [int]$Uncompleted = 0; # Completed="false"

    ToDoList($filename)
    {
        $this.FileName = $filename;
        $this.ScanCompleted();
    }

    Save(){$this.xml.Save($this.XMLFilePath);}

    hidden LoadList() # Will always run, just in case the xml file is editted
    {
        Push-Location $PSScriptRoot;
            $this.xml = Get-Content $('..\Data\' + $this.FileName); 
            Get-ChildItem $('..\Data\' + $this.FileName) |
                ForEach-Object{$this.XMLFilePath = $_.FullName;} # For full file path
        Pop-Location;
    }

    hidden ScanCompleted()
    {
        $this.LoadList();
        $this.CountCompletedAttribute($this.xml.Todo.Item);
    }

    hidden CountCompletedAttribute([System.object[]]$Item) # converting system.object to xml    
    {
        foreach ($val in $Item)
        {
            if($val.HasChildNodes)
            {
                $this.CheckIfCompleted($val);
                $this.CountCompletedAttribute($val.Item)
            }
            else
            {
                $this.CheckIfCompleted($val);
            }
        }
    }

    hidden CheckIfCompleted([System.Object[]]$val)
    {
        if($val.Completed -eq "true"){$this.Completed++;}
        else {$this.Uncompleted++;}
    }
}