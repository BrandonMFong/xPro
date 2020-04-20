
class List
{
    hidden [System.Xml.XmlDocument]$xml = [System.Xml.XmlDocument]::new(); # Will contain xml elements
    [string]$Title; # Must match the title attribute for List tag
    hidden [string]$FilePath; # The data file that will contain todo list
    hidden [boolean]$ExitLoop = $false;
    hidden [string]$DisplayFormat;

    List([string]$Title,[string]$XMLRedirectPath,[string]$DisplayFormat)
    {
        $this.Title = $Title;
        $this.DisplayFormat = $DisplayFormat
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
        $this.SweepItems($string,0,$this.GetList(),$null);
        $this.Save();
    }

    hidden LoadList()
    {
        # $this.xml.PreserveWhitespace = $true;
        $this.xml.Load($this.FilePath);
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
            $this.Display($x,$tab); # Display item string
            if($x.HasChildNodes){$this.GetItems($item);}
        }
    }

    hidden [void] Display([Item]$x,[string]$tab)
    {
        switch ($this.DisplayFormat)
        {
            "ColorCoded"
            {
                if($x.Completed){Write-Host "$($tab)$($x.String())" -ForegroundColor Green;}
                else{Write-Host "$($tab)$($x.String())" -ForegroundColor Red;}
            }
            "Markup"
            {
                if($x.Completed){Write-Host "$($tab)[X]$($x.String())" -ForegroundColor Yellow;}
                else{Write-Host "$($tab)[O]$($x.String())" -ForegroundColor Yellow;}
            }
            Default
            {
                if($x.Completed){Write-Host "$($tab)$($x.String())" -ForegroundColor Green;}
                else{Write-Host "$($tab)$($x.String())" -ForegroundColor Red;}
            }
        }
    }

    [void] SweepItems([string]$string,[int]$begin=0,[System.Xml.XmlElement]$List,[string]$IDString)
    {
        [string]$ID = $IDString;
        for($i = $begin;$i -le $string.Length;$i++)
        {
            if($this.ExitLoop){break;}
            elseif($string[$i] -eq ".")# the . means there are more to the string
            {
                foreach($Item in $List.Item)
                {
                    # if last one
                    if(($Item.ID -eq $ID) -and ($Item.HasChildNodes)){$this.SweepItems($string,$i+2,$Item,$string[$i+1]);}
                }
                if($this.ExitLoop){break;}
                throw "String Error";
            }
            elseif([string]::IsNullOrEmpty($string[$i+1])) # this notifies that this is the end
            {
                if([string]::IsNullOrEmpty($ID)){$ID = $string;}
                foreach($Item in $List.Item)
                {
                    # if last one
                    if($Item.ID -eq $ID)
                    {
                        [boolean]$val = !$Item.Completed.ToBoolean($null);
                        $Item.Completed = $val.ToString();
                    }
                }
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

# [List]$test = [List]::new('Git Hub Roadmap - GlobalScripts','B:\Powershell\Config\BRANDONMFONG.xml',$null)
# $test.ListOut();
# $test.Edit();