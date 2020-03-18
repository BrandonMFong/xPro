
class ToDoList
{
    [XML]$xml; # Will contain xml elements
    [string]$FileName; # The data file that will contain todo list
    [string]$XMLFilePath; # Full file path
    [int]$Completed = 0; # Completed="true"
    [int]$Uncompleted = 0; # Completed="false"
    hidden [string]$Folder = '\Config\';

    ToDoList($filename)
    {
        $this.FileName = $filename;
        $this.ScanCompleted();
    }

    # Public
    Save(){$this.xml.Save($this.XMLFilePath);}

    GetAllItems() # Todo this enters an infinite loop
    {
        $this.LoadList();
        $this.NodeSweep($this.xml.Machine.Todo);
    }

    # Private
    hidden NodeSweep([System.Object[]]$val)
    {
        foreach($val in $val.Item)
        {
            if($val.HasChildNodes)
            {
                $this.ItemToString($val);
                $this.NodeSweep($val.Item)
            }
            else{$this.NodeSweep($val);}
        }
    }
    
    hidden ItemToString([System.Object[]]$val)
    {
        [string]$tab = "";
        $i = 0;
        while($i -lt $val.Rank){$tab = $tab + "    ";$i++;}
        if($val.Complete -eq "true"){Write-Host "$($tab)$($val.Rank) - ($val.Name)" -ForegroundColor Green}
        else{Write-Host "$($tab)$($val.Rank) - ($val.Name)" -ForegroundColor Red}
    }

    hidden LoadList() # Will always run, just in case the xml file is editted
    {
        Push-Location $PSScriptRoot;
            $this.xml = Get-Content $($this.Folder + $this.FileName); 
            Get-ChildItem $('..' + $this.Folder + $this.FileName) |
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