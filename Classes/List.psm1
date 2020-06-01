using module .\Math.psm1;

class List
{
    hidden [System.Xml.XmlDocument]$xml = [System.Xml.XmlDocument]::new(); # Will contain xml elements
    [string]$Title; # Must match the title attribute for List tag
    hidden [string]$FilePath; # The data file that will contain todo list
    hidden [boolean]$ExitLoop = $false;
    hidden [string]$DisplayFormat;
    hidden [bool]$FoundNode = $false;

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

    [void] Mark()
    {
        $this.LoadList();
        [string]$Node = Read-Host -Prompt "Node";
        $this.SweepItems($Node,0,$this.GetList(),$null,'Mark',$null);
        $this.Save();
    }

    [void] Add()
    {
        $this.LoadList();
        [string]$Node = Read-Host -Prompt "Node";
        [string]$string = Read-Host -Prompt "String";
        $this.SweepItems($Node,0,$this.GetList(),$null,'Add',$string);
        $this.Save();
    }

    [void] Delete()
    {
        $this.LoadList();
        [string]$Node = Read-Host -Prompt "Node";
        $this.SweepItems($Node,0,$this.GetList(),$null,'Delete',$null);
        $this.Save();
    }

    [void] Edit() # TODO
    {
        $this.LoadList();
        [string]$Node = Read-Host -Prompt "Node";
        $this.SweepItems($Node,0,$this.GetList(),$null,'Delete',$null);
        $this.Save();
    }

    [void] Help()
    {
        Write-Host "@: New Item";
        Write-Host "Mark: path.to.id"
        Write-Host "Delete: path.to.id, everything below is deleted"
        Write-Host "Add: path.to.id, adds new node below last"
    }

    hidden LoadList()
    {
        $this.ExitLoop = $false;
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

    [void] SweepItems([string]$string,[int]$begin=0,[System.Xml.XmlElement]$List,[string]$IDString,[string]$Method,[string]$ItemName)
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
                    if(($Item.ID -eq $ID) -and ($Item.HasChildNodes)){$this.SweepItems($string,$i+2,$Item,$string[$i+1],$Method,$ItemName);}
                }
                if($this.ExitLoop){break;}
                throw "Something Bad Happened";
            }
            elseif([string]::IsNullOrEmpty($string[$i+1])) # this notifies that this is the end
            {
                if([string]::IsNullOrEmpty($ID)){$ID = $string;}
                foreach($Item in $List.Item)
                {
                    # if last one
                    if(($Item.ID -eq $ID) -or ($ID -eq "@"))
                    {
                        switch($Method)
                        {
                            "Mark"
                            {
                                [boolean]$val = !$Item.Completed.ToBoolean($null);
                                $Item.Completed = $val.ToString();
                                $this.FoundNode = $true;
                            }
                            "Add" # Don't need to save
                            {
                                [Calculations]$Math = [Calculations]::new();
                                $New = $this.xml.CreateElement("Item");
                                
                                # checks for @ indicating that user is creating a new item hierarchy within list
                                # @ signifies adding a new top item node
                                if($ID -eq "@")
                                {
                                    # Passes parent node
                                    $New.SetAttribute("ID",$Math.DecToAscii($Math.AsciiToDec($this.GetLastIDFromChildNode($Item.ParentNode)) + 1))

                                    # This might be null everytime I am adding something new
                                    if([string]::IsNullOrEmpty($Item.rank)){[string]$Rank = "1"}
                                    else{[string]$Rank = "$($Item.rank.ToInt16($null))"}
                                    $New.SetAttribute("rank","$($Rank)"); # Keeps rank
                                } 
                                else
                                {
                                    $New.SetAttribute("ID",$Math.DecToAscii($Math.AsciiToDec($this.GetLastIDFromChildNode($Item)) + 1));
                                    $New.SetAttribute("rank","$($Item.rank.ToInt16($null) + 1)");
                                }
                                
                                $New.SetAttribute("name",$ItemName);
                                $New.SetAttribute("Completed","false");

                                # If creating a new item hierarchy then must append to list node
                                if($ID -eq "@")
                                {
                                    # Maybe it's null because there is nothing under the list node
                                    if([String]::IsNullOrEmpty($Item.ParentNode)){$List.AppendChild($New);}
                                    else{$Item.ParentNode.AppendChild($New);}
                                }
                                else{$Item.AppendChild($New);}

                                $this.FoundNode = $true;
                            }
                            "Delete" 
                            {
                                $List.RemoveChild($Item);
                                $this.FoundNode = $true;
                            }
                            Default {throw "Something bad happened!";}
                        }
                    }
                }
                $this.ExitLoop = $true; # If we are here then we are at the end of the string
            }
            else{$ID += $string[$i];}
        }
        if(!$this.FoundNode){Write-Warning "$($string) was not found.  Please check the node string.";}
    }

    hidden [string] GetLastIDFromChildNode([System.Xml.XmlElement]$Item)
    {
        # If there is only one item in the node, it can't count because its the only leaf in that node
        # This is a temp/bad fix (and ghetto) but it works out
        if([string]::IsNullOrEmpty($Item.Item.Count)){return $Item.Item.ID}
        elseif([String]::IsNullOrEmpty($Item)){return "@";}
        else{return $this.CheckIfIDIsNull(($Item.Item[$Item.Item.Count - 1].ID));}
    }

    hidden [string] CheckIfIDIsNull([string]$ID) # A little work around because the '`' is before 'a' in the ascii table
    {
        if([string]::IsNullOrEmpty($ID)){return "@";}# index before all caps
        else {return $ID;}
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

# [List]$test = [List]::new('Monday To Do List','B:\Powershell\Config\User\List.xml','ColorCoded')
# $test.ListOut();
# $test.Add()