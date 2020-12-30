using module .\..\Classes\Calendar.psm1;
using module .\..\Classes\Math.psm1;
using module .\..\Classes\SQL.psm1;
# using module .\..\Classes\List.psm1;
using module .\..\Classes\Logs.psm1;

# These are functions used inside other functions

$Sql = [SQL]::new($Global:XMLReader.Machine.Objects.Database,$Global:XMLReader.Machine.Objects.ServerInstance); # This needs to be unique per config

function Get-LogObject
{
    [String]$DateStamp = Get-Date -Format "MMddyyyy"; # Only doing logs for one day
    [Logs]$x = [Logs]::new($($Global:AppPointer.Machine.GitRepoDir + "\Logs\User\" + $Global:AppPointer.Machine.ConfigFile + ".$($DateStamp).log"));
    return $x;
}
function MakeClass($XmlElement)
{
    try 
    {
        switch($XmlElement.Class.ClassName) 
        {
            "Calendar" 
            {
                [string]$EventsFile = $XmlElement.Class.Calendar.EventsFile;
                [string]$EventConfig = $XmlElement.Class.Calendar.EventConfig;
                [string]$TimeStampFilePath = $XmlElement.Class.Calendar.TimeStampFilePath;
                [string]$FirstDayOfWeek = $XmlElement.Class.Calendar.FirstDayOfWeek;
                $x = [Calendar]::new($EventsFile,$EventConfig,$TimeStampFilePath,$FirstDayOfWeek);
                return $x;
            }
            "Web" {$x = [Web]::new();return $x;}
            "Calculations" {$x = [Calculations]::new($XmlElement.Class.Math.QuantizedStepSize,$XmlElement.Class.Math.PathToGradeImport,$XmlElement.Class.Math.GradeColors);return $x;}
            "Email" {$x = [Email]::new();return $x;}
            "SQL" 
            {
                [string]$Database = $XmlElement.Class.SQL.Database;
                [string]$ServerInstance = $XmlElement.Class.SQL.ServerInstance;
                [System.Object[]]$Tables = $XmlElement.Class.SQL.Tables;
                [boolean]$Sync = $XmlElement.Class.SQL.SyncConfiguration.ToBoolean($null);
                [boolean]$UpdateVerbose = $XmlElement.Class.SQL.UpdateVerbose.ToBoolean($null);
                [string]$SQLConvertFlags = $XmlElement.Class.SQL.SQLConvertFlags;
                [boolean]$RunUpdates = $XmlElement.Class.SQL.RunUpdates.ToBoolean($null);
                [boolean]$Create = $XmlElement.Class.SQL.CreateDatabase.ToBoolean($null);
                $x = [SQL]::new($Database, $ServerInstance, $Tables, $Sync, $UpdateVerbose, $SQLConvertFlags,$RunUpdates,$Create);
                return $x;
            }
            "List"{$x = [List]::new($XmlElement.Class.List.Title,$XmlElement.Class.List.Redirect,$XmlElement.Class.List.DisplayCompleteWith);return $x;}
            default
            {
                Write-Warning "Class $($XmlElement.Class.ClassName) was not made.";
            }
        }
    }
    catch{$Global:LogHandler.WriteError($_);}
}

function _GetUserConfig 
{
    <#
    .Synopsis 
        returns either the path or content of the config file 
    #>
    Param([switch]$Content, [switch]$Path)
    
    if($Content){return Get-Content $($global:AppPointer.Machine.GitRepoDir + $Global:AppJson.Directories.UserConfig + $global:AppPointer.Machine.ConfigFile);}
    if($Path){return $($global:AppPointer.Machine.GitRepoDir + $Global:AppJson.Directories.UserConfig + $global:AppPointer.Machine.ConfigFile);}
}

function GetObjectByClass([string]$Class)
{
    <#
    .Synopsis 
        If an object is found that has methods we want to use, return that object
        Object must be configured
    #>
    [xml]$xml = $(_GetUserConfig -Content);
    [System.Boolean]$Found = $false;
    foreach($Object in $xml.Machine.Objects.Object)
    {
        if(($Object.Type -eq 'PowerShellClass') -and ($Object.Class.Classname -eq $Class))
        {
            $Found = $true;break;
        }
    }
    $Global:LogHandler.Write("Returning variable `$$($Object.VarName.InnerXml) for $($(Get-PSCallStack)[1].Location | Split-Path -Leaf;)");
    if($Found){return $(Get-Variable $Object.VarName.InnerXml).Value;}
    else{$Global:LogHandler.Write("Object not found for class $($class)");}
}

function IsNotPass($x){return ($x -ne "pass");}

function FindNodeInterval($value,[string]$Node,[ref]$start,[ref]$end)
{
    $n = 1; # This helps find the first index
    $u = 0; # This holds the value to figure out how far to look in the interval for another node
    $foundbeginning = $false;
    foreach($v in $value.Key)
    {
        if(($v.Node -eq $Node) -and !$foundbeginning)
        {
            $start.Value = $n-1;
            $u = 1;
            $foundbeginning = $true;
        }
        elseif($v.Node -eq $Node)
        {
            $n++; # Figure out what index this is and that it does not overlap
            $u = $n - $start.Value ; # Expands the interval to look for
        }
        else{$n++;}
    }
    $end.Value = $u;
}
function Evaluate([System.Object[]]$value,[Switch]$IsDirectory=$false)
{
    # param([Switch]$IsGoto)
    if([String]::IsNullOrEmpty($value))
    {
        return $null;
    }

    
    elseif($value.SecType -eq "private")
    {
        [String]$o = $Sql.InputReturn($value.InnerText);
        if([string]::IsNullOrEmpty($o)){$Global:LogHandler.Warning("$($value.InnerText) did not returning anything from database");}
        return $o;
    }
    elseif($null -ne $value.NodePointer)
    {
        return $( MakeHash -value $value.ParentNode -lvl $([int]$value.Lvl + 1) -Node $value.NodePointer);# The attributes lvl and nodepointer are not passing
    }
    # I am assuming that the link info method is the only method that does not use xmlelements
    # That is why I am checking if the value variable has the InnerText property because only an xmlelement would have that
    elseif([string]::IsNullOrEmpty($value.InnerText)){return $value;} # for the case of the link table 
    
    elseif($value.InnerText.Contains('$')) # if powershell object
    {
        # If user is using PSScriptRoot, must use it in the context that this file will return the script root
        if($value.InnerText.Contains('$PSScriptRoot'))
        {
            if($IsDirectory)
            {
                Push-Location $value.Innertext;
                    [String]$path = (Get-Location).Path;
                Pop-Location;
                return $path;
            }
            else
            {
                # Testing if the path exists
                if(!(Test-Path $value.InnerText))
                {
                    $Global:LogHandler.Warning("$($value.InnerText) does not exist.  Please check spelling");
                    return $null; # return nothing if it does not exist
                }
                else 
                {
                    return $(Get-ChildItem $value.InnerText).Fullname;
                }
            }
        }
        else{return $(Get-Variable $value.InnerText.Replace('$','')).Value;} # Else return the variable
    }
    else{return $value.InnerText;}
}

# Hmmmmm, what if a node is on difference indexes
# TODO finish.  This might not work out in terms of improving performance
function GetAllIntervals([System.Object[]]$Keys)
{
    # Goal: 
    # - Sweep all nodes [X]
    # - Find nodes and record index []
    # - sort all nodes in []
    #   - [0] A to [last index] Z
    # - implement binary search []
    $t = [Ordered]@{};
    $n = @{"Node"="";"Start"="";"End"="";}; # New node
    [bool]$StartFound = $false; [bool]$EndFound = $false;
    for([int]$i=0;$i -lt $Keys.Length;$i++)
    {
        # If the key has a node, the $n object node is empty and the $n start is empty
        if(![string]::IsNullOrEmpty($Keys[$i].Node) -and [string]::IsNullOrEmpty($n.Node) -and [string]::IsNullOrEmpty($n.Start))
        {
            $n.Start = $i.ToString();
            $n.Node = $Keys[$i].Node;
        }

        # End of the interval. Sort the nodes here
        if(($n.Node -ne $Keys[$i].Node) -and ![string]::IsNullOrEmpty($n.Node) -and ![string]::IsNullOrEmpty($n.Start)) # If node interval just passed
        {
            $n.End = $($i-1).ToString();
            SortHash -t ([ref]$t) -n ([ref]$n) -index:0 -Key $Keys[$i];
            $n = @{"Node"="";"Start"="";"End"="";}; # reset
        }

    }
    return $t;
}

# The higher the alphabet, the higher the index
# So 'A' would be [0]
function SortHash([ref]$t,[ref]$n,[int]$index,[System.Xml.XmlElement]$Key)
{
    [Calculations]$m = [Calculations]::new();
    # if Z > A
    # If the saved node is greater than the next node
    if($m.AsciiToDec($n.Value.Node[$index]) -gt $m.AsciiToDec($Key.Node[$index])){$t.Value.Add($n.Value.Node,$n);}

    # if Z < A
    # If the saved node is less than the next node
    elseif($m.AsciiToDec($n.Value.Node[$index]) -lt $m.AsciiToDec($Key.Node[$index]))
    {
        # sort
        $temp = $t.Value;
        $t.Value = @{};
        $t.Value.Add($n.Value.Node,$n);
        $t = $t + $temp; # Add on top of old
    }
    else{SorHash -t ([ref]$t) -n ([ref]$n) -index:$($index+1) -Key:$Key;}
}

# Making this function multi purpose for the link info method
function MakeHash([System.Object[]]$value,[int]$lvl,[string]$Node)
{
    [Hashtable]$t = @{}; # Init hash object 
    # $IntervalHolder = GetAllIntervals($value.Key);# Only using key because there always has to be a value
    
    if($value.Key.Count -ne $value.Value.Count)
    {
        $Global:LogHandler.Write("Objects must have equal key and values in config.");
        throw;
    }

    # When there is a node pointer
    elseif(![string]::IsNullOrEmpty($Node))
    {
        $start = 0;$end = 0;
        FindNodeInterval -value $value -Node $Node -start ([ref]$start) -end ([ref]$end);
        for($i=$start;$i -le $($start + $end + 1);$i++)
        {
            if($node -eq $value.Key[$i].Node)
            {
                if(!(($value.Key[$i].Lvl -ne $value.Value[$i].Lvl) -or ([int]$value.Key[$i].Lvl -ne $lvl)))
                {
                    try{$t.Add($(Evaluate($value.Key[$i])),$(Evaluate($value.Value[$i])));}
                    catch{$Global:LogHandler.WriteError("[Could not complete, remove this key and val] Key:$($value.Key[$i].InnerText), Value:$($value.Value[$i].InnerText)");}
                }
            }
        }
    }

    # For the leaf node
    else 
    {
        # For the corner case where there is only one node
        if([string]::IsNullOrEmpty($value.Key.Count)){$t.Add($(Evaluate($value.Key)),$(Evaluate($value.Value)));}
        else 
        {
            for($i=0;$i -lt $value.Key.Count;$i++)
            {
                if(!(($value.Key[$i].Lvl -ne $value.Value[$i].Lvl) -or ([int]$value.Key[$i].Lvl -ne $lvl)))
                {
                    try{$t.Add($(Evaluate($value.Key[$i])),$(Evaluate($value.Value[$i])));}
                    catch{$Global:LogHandler.WriteError("[Could not complete, remove this key and val] Key:$($value.Key[$i].InnerText), Value:$($value.Value[$i].InnerText)");}
                }
            }
        }
    }
    return $t;
}



function DoesFileExistInArchive($file)
{
    If(Test-Path $('.\archive\' + $file.Name))
    {

        [string]$NewName = $file.BaseName + " " + (Get-ChildItem $('.\archive\' + $file.Name)).Count.ToString() + $file.Extension;
        Rename-Item $file.Name $NewName;
        Move-Item $NewName .\archive\;
    }
    else{Move-Item $file.Fullname .\archive\;}
}

function LoadPrograms
{
    Param($Global:XMLReader=$Global:XMLReader,$Global:AppPointer=$Global:AppPointer,[switch]$Verbose)
    if(![String]::IsNullOrEmpty($Global:XMLReader.Machine.Programs))
    {
        [int]$Complete = 1;
        [int]$Total = $(CheckCount -Count:$Global:XMLReader.Machine.Programs.Program.Count);
        foreach($val in $Global:XMLReader.Machine.Programs.Program)
        {
            if(!$Verbose)
            {
                Write-Progress -Activity "Loading Programs" -Status "Program: $($val.InnerXML)" -PercentComplete (($Complete / $Total)*100);
                $Complete++;
            }

            # will return null if the program does not exist
            [string]$program = $(Evaluate -value $val); 
            try
            {
                # if the string is not null, then set the alias
                if(![string]::IsNullOrEmpty($program))
                {
                    Set-Alias $val.Alias $program -Verbose:$Verbose -Scope Global; $Global:LogHandler.Write("Set-Alias: $($val.Alias) => $($program)");
                }
            }
            catch{$Global:LogHandler.WriteError($_);}
        }
        if(!$Verbose){Write-Progress -Activity "Loading Programs" -Status "Program: Finished" -Completed;}
    }
}
function LoadModules
{
    Param($Global:XMLReader=$Global:XMLReader,[switch]$Verbose)
    if(![String]::IsNullOrEmpty($Global:XMLReader.Machine.Modules))
    {
        [int]$Complete = 1;
        [int]$Total = $(CheckCount -Count:$Global:XMLReader.Machine.Modules.Module.Count);
        foreach($val in $Global:XMLReader.Machine.Modules.Module)
        {
            if(!$Verbose)
            {
                Write-Progress -Activity "Loading Modules" -Status "Module: $($val)" -PercentComplete (($Complete / $Total)*100);
                $Complete++;
            }
            if(Test-Path $val)
            {
                try{Import-Module $($val) -Verbose:$Verbose -Scope Global -DisableNameChecking; $Global:LogHandler.Write("Import-Module: $($val)");}
                catch{$Global:LogHandler.WriteError($_);}
            }
        }
        if(!$Verbose){Write-Progress -Activity "Loading Modules" -Status "Module: Finished" -Completed;}
    }
}

function LoadObjects
{
    Param($Global:XMLReader=$Global:XMLReader,[switch]$Verbose)
    if(![String]::IsNullOrEmpty($Global:XMLReader.Machine.Objects))
    {
        [int]$Complete = 1;
        [int]$Total = $(CheckCount -Count:$Global:XMLReader.Machine.Objects.Object.Count);
        foreach($val in $Global:XMLReader.Machine.Objects.Object)
        {
            if(!$Verbose)
            {
                Write-Progress -Activity "Loading Objects" -Status "Object: $($val.VarName.InnerXML)" -PercentComplete (($Complete / $Total)*100);
                $Complete++;
            }
            [String]$VarName = Evaluate -value $val.VarName;
            try
            {
                switch ($val.Type)
                {
                    "PowerShellClass"{New-Variable -Name $VarName -Value $(MakeClass -XmlElement $val) -Force -Verbose:$Verbose -Scope Global;break;}
                    "XmlElement"
                    {
                        New-Variable -Name $VarName -Value $val.Values -Force -Verbose:$Verbose -Scope Global;

                        # Remove xsi:type attribute
                        [System.Xml.XmlElement]$_o = $(Get-Variable -Name $VarName).Value;
                        foreach($_n in $_o.ChildNodes)
                        {
                            if($_n.Name -ne "#comment")
                            {
                                $Global:LogHandler.Write("Adding $($_n.Name) to object `$$($VarName)");
                                $_n.RemoveAttribute("xsi:type");
                            }
                        }
                        break;
                    }
                    "HashTable"{New-Variable -Name $VarName -Value $(MakeHash -value $val -lvl 0 -Node $null) -Force -Verbose:$Verbose -Scope Global; break;}
                    "LinkedObject"{New-Variable -Name $VarName -Value $(GetLinkedInfo -Link:$val.Link) -Force -Verbose:$Verbose -Scope Global; break;}
                    default {New-Variable -Name $VarName -Value $val.Values -Force -Verbose:$Verbose -Scope Global;break;}
                }
                $Global:LogHandler.Write("New-Variable: $($VarName)");
            }
            catch{$Global:LogHandler.WriteError($_.ToString() + " creating object => `$$($VarName)");}
        } 
        if(!$Verbose){Write-Progress -Activity "Loading Objects" -Status "Object: Finished" -Completed;}
    }
}

# This function can be the same as the Make Hash method
# first let's just produce one node level
function GetLinkedInfo
{
    Param([string]$Link)
    [string]$querystring = "$(Get-Content $PSScriptRoot\..\SQL\LinkInfo.sql)";
    $querystring = $querystring.Replace("@Link","'$($Link)'");
    [System.Object[]]$results = $Sql.Query($querystring);

    return $(MakeHash -value:$results -lvl 0 -Node $null);
}

function LoadFunctions
{
    Param($Global:XMLReader=$Global:XMLReader,[switch]$Verbose)
    if(![String]::IsNullOrEmpty($Global:XMLReader.Machine.Functions))
    {
        [int16]$Complete = 1;
        [int16]$Total = $(CheckCount -Count:$Global:XMLReader.Machine.Functions.Function.Count);
        foreach($val in $Global:XMLReader.Machine.Functions.Function)
        {
            if(!$Verbose)
            {
                [string]$FunctionName = $null;
                [int16]$i = [int16]$([string]$($val.'#cdata-section').IndexOf(":"))+1;
                while($true){$FunctionName += [string]$($val.'#cdata-section')[$i];$i++; if([string]$($val.'#cdata-section')[$i] -eq "{"){break;}}
                Write-Progress -Activity "Loading Functions" -Status "Function: $($FunctionName)" -PercentComplete (($Complete / $Total)*100);
                $Complete++;
            }
            try{Invoke-Expression $val.'#cdata-section';$Global:LogHandler.Write("Successfully loaded $($val.'#cdata-section')");}
            catch{$Global:LogHandler.WriteError($_);}
        } 
        if(!$Verbose){Write-Progress -Activity "Loading Functions" -Status "Function: Finished" -Completed;}
    }
}


# splits string by delimiter
# There is already a function but wanted to try this myself
function SplitString
{
    Param([String]$originalstring,[String]$Delimiter,[int]$i=0,[string]$currentstring=$null,[string[]]$finalarray=[string[]]::new($null))
    
    if($i -lt $originalstring.Length)
    {
        $currentstring += $originalstring[$i]; # Concat the char
        [Byte]$IsAtSplit = $(($originalstring[$i+1] -eq $Delimiter) -or [String]::IsNullOrEmpty($originalstring[$i+1])).ToByte($null); # If the next index is the delimiter value, true; else false
        if($IsAtSplit){$finalarray += $currentstring; $currentstring = $null} # Add to the array
        SplitString -originalstring:$originalstring -Delimiter:$Delimiter -i:$($i+1+$IsAtSplit) -currentstring:$currentstring -finalarray:$finalarray;
    }

    # should return an array with a length of 4
    else{return $finalarray;} # return the array
}

function CheckCount # I guess in Powershell v5 the count on an xml with one node returns node
{
    Param([int]$Count)
    if(!$Count){return 1;}
    else{return $Count;}
}

function InsertFromCmd
{
    Param([string]$Tag,[string]$PathToAdd)
    [XML]$x = $(_GetUserConfig -Content);
    $add = $x.CreateElement($Tag); 

    $Alias = Read-Host -Prompt "Set Alias";
    $add.SetAttribute("Alias", $Alias);

    $Security = Read-Host -Prompt "Is this private? (y/n)?";
    if($Security -eq "y")
    {
        $add.SetAttribute("SecType", "private");
        
        $insert = GetObjectByClass('SQL');
        [int]$MaxID = $insert.GetMax('PersonalInfo');
        [string]$GuidString = $insert.GetGuidString();
        [string]$subject = Read-Host -Prompt "Subject?";
        [int]$TypeContentID = ($insert.Query("select id as ID from typecontent where externalid = '$(GetTCExtID($Tag))'")).ID; # id must exist
        $querystring = "insert into PersonalInfo values ($($MaxID), $($GuidString),'$($PathToAdd)', '$($subject)', $($TypeContentID), GETDATE(), GETDATE())";

        Write-Host "`nQuery: " -NoNewline;Write-Host "$($querystring)`n" -foregroundcolor Cyan;
        $insert.Query($querystring);

        $Var = ($insert.Query("select guid as Guid from personalinfo where id = $($MaxID)")).Guid;
        $add.InnerXml = $Var.Guid; # Adding guid
    }
    else
    {
        $add.SetAttribute("SecType", "public")
        $add.InnerXml = $PathToAdd; # Adding literally path
    }
    
    AppendCorrectChild -Tag $Tag -add $add -x $([ref]$x);
    $x.Save($(_GetUserConfig -Path));
}

function GetFullFilePath([string]$File)
{
    return (Get-ChildItem $File).FullName
}

function AppendCorrectChild([string]$Tag,$add,[ref]$x)
{
    switch($Tag)
    {
        "Directory"{$x.Value.Machine.Directories.AppendChild($add);}
        "Program"{$x.Value.Machine.Programs.AppendChild($add);}
        default{$Global:LogHandler.Write("$($Tag) was passed but isn't a choice. TODO combine with GetTCExtID");}
    }
}

function GetTCExtID([string]$Type)
{
    [string]$str = "";
    switch($Type)
    {
        "Directory"{$str = "PrivateDirectory"}
        "Program"{$str = "PrivateProgram"}
        default{$Global:LogHandler.Write("$($Type) was passed but isn't a choice. TODO combine with AppendCorrectChild");}
    }
    return $str;
}

function Test-KeyPress
{
    param
    (
        [Parameter(Mandatory)]
        [ConsoleKey]
        $Key,

        [System.ConsoleModifiers]
        $ModifierKey = 0
    )
    if ([Console]::KeyAvailable)
    {
        $pressedKey = [Console]::ReadKey($true)

        $isPressedKey = $key -eq $pressedKey.Key
        if ($isPressedKey)
        {
            return ($pressedKey.Modifiers -eq $ModifierKey);
        }
        else
        {
            return $false
        }
    }
}

function EmailOrder([int]$i,[int]$Max,[int]$OrderFactor)
{
    [System.Xml.XmlDocument]$xml = $(_GetUserConfig -Content);
    if($xml.Machine.Email.ListOrderBy -eq "Asc")
    {
        return ($i -lt ($Max - $OrderFactor));
    }
    elseif($xml.Machine.Email.ListOrderBy -eq "Desc")
    {
        return ($i -gt ($OrderFactor - $Max));
    }
    else
    {
        return $false;
    }
}

function CheckCredentials
{
    # If the security elements are configured
    if(![String]::IsNullOrEmpty($Global:XMLReader.Machine.ShellSettings.Security.Secure))
    {
        if($Global:XMLReader.Machine.ShellSettings.Security.Secure.ToBoolean($null) -and !$LoggedIn)
        {
            Write-Host "CONFIG: $($Global:AppPointer.Machine.ConfigFile)`n" -foregroundcolor Gray;
            $cred = Get-Content ($Global:AppPointer.Machine.GitRepoDir + "\bin\credentials\user.JSON") | ConvertFrom-Json  
            [string]$user = Read-Host -prompt "Username"; 

            # Get Secure string and then convert it back to plain text
            [System.Object]$var = Read-Host -prompt "Password" -AsSecureString; 
            [System.ValueType]$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($var);
            [String]$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
            
            if(($user -ne $cred.Username) -or ($cred.Password -ne $(GetPassWord -password:$password -cred:$cred)))
            {
                Write-Error "WRONG CREDENTIALS";
                Start-Sleep 1;
                Pop-Location;
                $Global:XMLReader = $null;$Global:AppPointer = $null;
                if($Global:XMLReader.Machine.ShellSettings.Security.CloseSessionIfIncorrect.ToBoolean($null)){Stop-Process -Id $PID;}
                else{exit;}
            }
            else{[Boolean]$x = $true; New-Variable -Name LoggedIn -Value $x -Scope Global;}
        }
    }
    Write-Host "`n";
}

function GetPassWord([String]$password, [System.Object[]]$cred) # Encrypts password
{
    # PlainText
    if($cred.Decode -eq "PlainText"){return $password;}
    # Binary
    elseif($cred.Decode -eq "Binary")
    {
        [string]$out = $null;
        [Calculations]$math = [Calculations]::new();
        for($i = 0;$i -lt $password.Length;$i++){$out += $math.IntToBinary($math.AsciiToDec($password[$i]))}
        return $out;
    }
    # HexMax
    elseif($cred.Decode -eq "HexMax")
    {
        [string]$out = $null;
        [Calculations]$math = [Calculations]::new();
        for($i = 0;$i -lt $password.Length;$i++)
        {
            $string = $math.IntToBinary($math.AsciiToDec($password[$i]));
            for($j = 0;$j -lt $string.Length;$j = $j + 4)
            {
                $out += $math.BinaryToInt($string.Substring($j,4));
            }
        }
        return $out;
    }
    else{return $password;}
}

function GenerateEncryption
{
    param
    (
        [ValidateSet('PlainText','Binary','HexMax')]
        [string]$Encryption,
        [Parameter(Mandatory)][string]$password
    )
    $t = @{"Decode"=$Encryption};
    GetPassWord -password:$password -cred:$t;
}

function CreateCredentials
{
    [System.Object[]]$user = @{"Username"="";"Password"="";"Decode"=""};
    if(Test-Path $($Global:AppPointer.Machine.GitRepoDir + "\bin\credentials\user.JSON").ToString())
    {
        Write-Warning "Credential file already exists!";
    }
    else 
    {
        [string]$CredPath = ($Global:AppPointer.Machine.GitRepoDir + "\bin\credentials\user.JSON").ToString();
        New-Item $CredPath -Force;
        $user | ConvertTo-Json | Out-File $CredPath;
        Write-Warning "`nCreated credential file.  Must manually ecrypt and apply." -ForegroundColor Gray;
    }
}

function GetSynopsisText
{
    Param([string]$script)
    [Boolean]$FoundSynopsis = $false;
    [string[]]$Content = Get-Content $script;
    for([int16]$i=0;$i -lt $script.Length;$i++)
    {
        if($Content[$i].Substring(0,2) -eq "#>"){break;}
        if($FoundSynopsis)
        {
            Write-Host "$($Content[$i])" -ForegroundColor Gray;
        }
        if(($Content[$i].Substring(0,$Content[$i].Length) -eq ".Synopsis") -and !$FoundSynopsis){$FoundSynopsis = $true;}
    }
}

function Test-KeyPress
{
    param
    (
        [Parameter(Mandatory)]
        [ConsoleKey]
        $Key,

        [System.ConsoleModifiers]
        $ModifierKey = 0
    )
    if ([Console]::KeyAvailable)
    {
        $pressedKey = [Console]::ReadKey($true)

        $isPressedKey = $key -eq $pressedKey.Key
        if ($isPressedKey)
        {
            return ($pressedKey.Modifiers -eq $ModifierKey);
        }
        else
        {
            return $false
        }
    }
}

