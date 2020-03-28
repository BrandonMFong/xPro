
class List
{
    [XML]$xml; # Will contain xml elements
    [string]$Title;
    [string]$FilePath; # The data file that will contain todo list
    [int]$Completed = 0; # Completed="true"
    [int]$Uncompleted = 0; # Completed="false"

    List($Title)
    {
        $this.Title = $Title;
        $this.FilePath = $((Get-Location).Path + '\..\Config\BRANDONMFONG.xml');
    }

    Save(){$this.xml.Save($this.FilePath);}

    ListOut()
    {
        $this.LoadList();
        $this.GetList($this.xml.Machine.Lists);
    }

    hidden LoadList()
    {
        $this.xml = Get-Content $this.FilePath;
    }

    hidden GetList($Lists)
    {
        foreach($List in $Lists.List)
        {
            if($List.Title -eq $this.Title){$this.GetItems($List)}
        }
    }

    hidden GetItems($List)
    {
        foreach($item in $List.Item)
        {
            $x = [Item]::new($item)
            [string]$tab = "";
            for($i=0;$i -lt $x.Rank();$i++){$tab = $tab + "  ";}
            if($x.Completed -eq "true")
            {
                Write-Host "$($tab)$($x.String())" -ForegroundColor Green;
            }
            else
            {
                Write-Host "$($tab)$($x.String())" -ForegroundColor Red;
            }
            if($x.HasChildNodes){$this.GetItems($item);}
        }
    }

}

class Item 
{
    hidden [int]$itemrank;
    hidden [string]$name;
    [boolean]$Completed;
    [boolean]$HasChildNodes;
    Item($item)
    {
        $this.itemrank = $item.rank;
        $this.name = $item.name;
        if($item.completed -eq "true"){$this.Completed = $true;}
        else{$this.Completed = $false;}
        $this.HasChildNodes = $item.HasChildNodes;
    }

    [string] String()
    {
        return "$($this.itemrank) - $($this.name)";
    }

    [int] Rank()
    {
        return $this.itemrank;
    }
}

$test = [List]::new("To Do List");
$test.ListOut();
