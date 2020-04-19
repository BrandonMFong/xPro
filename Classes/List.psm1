
class List
{
    hidden [XML]$xml; # Will contain xml elements
    [string]$Title; # Must match the title attribute for List tag
    hidden [string]$FilePath; # The data file that will contain todo list
    hidden [boolean]$ExitLoop = $false;

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

    [void] Save(){$this.xml.Save($this.FilePath);}

    [void] ListOut()
    {
        $this.LoadList();
        Write-Host "`n[$($this.Title)]`n" -ForegroundColor Green;
        $this.GetItems($this.GetList());
        Write-host `n;
    }

    [void] Edit()
    {
        $this.LoadList();
        $string = Read-Host -Prompt "String";
        $this.SweepItems($string,0,$this.GetList());
        $this.Save();
    }

    hidden LoadList()
    {
        $this.xml = Get-Content $this.FilePath;
    }

    hidden [System.Xml.XmlElement] GetList()
    {
        foreach($List in $this.xml.Machine.Lists.List)
        {
            if($List.Title -eq $this.Title){return $List;}
        }
        throw "Couldn't find list"
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

    [void] SweepItems([string]$string,[int]$begin=0,$List)
    {
        [string]$ID = "";
        for($i = $begin;$i -lt $string.Length;$i++)
        {
            if($this.ExitLoop){break;}
            elseif($string[$i] -eq ".")# the . means there are more to the string
            {
                foreach($Item in $List.Item)
                {
                    # if last one
                    if(($Item.ID -eq $ID) -and ($Item.HasChildNodes)){$this.SweepItems($string,$i+1,$Item);}
                    elseif($this.ExitLoop){break;}
                    else{throw "String Error";}
                }
            }
            elseif([string]::IsNullOrEmpty($string[$i+1])) # this notifies that this is the end
            {
                [boolean]$val = $List.Completed.ToBoolean($null);
                $List.Completed = $val.ToString();
                $this.ExitLoop = $true;
            }
            else{$ID += $string[$i];}
        }
    }
}

class Item 
{
    hidden [int]$itemrank;
    hidden [string]$itemid;
    hidden [string]$name;
    [boolean]$Completed;
    [boolean]$HasChildNodes;
    Item($item)
    {
        $this.itemrank = $item.rank;
        $this.itemid = $item.ID;
        $this.name = $item.name;
        if($item.completed -eq "true"){$this.Completed = $true;}
        else{$this.Completed = $false;}
        $this.HasChildNodes = $item.HasChildNodes;
    }

    [string] String()
    {
        return "$($this.itemid) - $($this.name)";
    }

    [int] Rank()
    {
        return $this.itemrank;
    }
}

# [List]$test = [List]::new('Saturday To Do List','B:\Powershell\Config\List\List.xml')
# $test.Edit();