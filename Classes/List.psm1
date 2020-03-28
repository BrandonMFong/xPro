
class List
{
    [XML]$xml; # Will contain xml elements
    [string]$Title; # Must match the title attribute for List tag
    [string]$FilePath; # The data file that will contain todo list

    List($Title)
    {
        $this.Title = $Title;
        $this.FilePath = $($PSScriptRoot.ToString() + '\..\Config\BRANDONMFONG.xml');
    }

    Save(){$this.xml.Save($this.FilePath);}

    ListOut()
    {
        $this.LoadList();
        Write-Host "`n$($this.Title)`n" -ForegroundColor Green;
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
