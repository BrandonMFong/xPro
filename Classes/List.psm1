
class List
{
    hidden [XML]$xml; # Will contain xml elements
    [string]$Title; # Must match the title attribute for List tag
    hidden [string]$FilePath; # The data file that will contain todo list

    List([string]$Title,[string]$XMLRedirectPath)
    {
        $this.Title = $Title;
        if([string]::IsNullOrEmpty($XMLRedirectPath)) # if using user config
        {
            [string]$File = (Get-Variable 'AppPointer').Value.Machine.ConfigFile; 
            $this.FilePath = ($PSScriptRoot + '\..\Config\' + $File);
        }
        else # if you're using another config
        {
            $this.FilePath = $XMLRedirectPath;
        }
    }

    Save(){$this.xml.Save($this.FilePath);}

    ListOut()
    {
        $this.LoadList();
        Write-Host "`n[$($this.Title)]`n" -ForegroundColor Green;
        $this.GetList();
        Write-host `n;
    }

    [void] Edit()
    {
        # I need to have an id for each item
        # should it be in the config or should I dynamically allocate id for item
    }

    hidden LoadList()
    {
        $this.xml = Get-Content $this.FilePath;
    }

    hidden GetList()
    {
        foreach($List in $this.xml.Machine.Lists.List)
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
            if($x.Completed)
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

    [void] ToggleItem([string]$string,[int]$begin=0,$List)
    {
        [string]$ID = "";
        for($i = $begin;$i -lt $string.Length;$i++)
        {
            if($string[$i] -eq ".")
            {
                foreach($Item in $List.Item)
                {
                    if(($Item.ID -eq $ID) -and ($Item.HasChildNodes)) # if last one
                    {
                        
                    }
                }
            }
            $ID += $string[$i];
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
