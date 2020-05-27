using module .\..\Classes\Calendar.psm1;
using module .\..\Classes\Math.psm1;
using module .\..\Classes\SQL.psm1;
using module .\..\Classes\Web.psm1;
using module .\..\Classes\List.psm1;

# These are functions used inside other functions

$Sql = [SQL]::new($XMLReader.Machine.Objects.Database,$XMLReader.Machine.Objects.ServerInstance, $null, $false, $false, $null); # This needs to be unique per config

function MakeClass($XmlElement)
{
    switch($XmlElement.Class.ClassName) # TODO unique tag for classes under tag if have params
    {
        "Calendar" {$x = [Calendar]::new($XmlElement.Class.Calendar.PathToEventImport,$XmlElement.Class.Calendar.EventConfig,$XmlElement.Class.Calendar.TimeStampFilePath);return $x;}
        "Web" {$x = [Web]::new();return $x;}
        "Calculations" {$x = [Calculations]::new($XmlElement.Class.Math.QuantizedStepSize,$XmlElement.Class.Math.PathToGradeImport,$XmlElement.Class.Math.GradeColors);return $x;}
        "Email" {$x = [Email]::new();return $x;}
        "SQL" 
        {
            [string]$Database = $XmlElement.Class.SQL.Database;
            [string]$ServerInstance = $XmlElement.Class.SQL.ServerInstance;
            [System.Object[]]$Tables = $XmlElement.Class.SQL.Tables;
            [boolean]$SyncConfiguration = $XmlElement.Class.SQL.SyncConfiguration.ToBoolean($null);
            [boolean]$UpdateVerbose = $XmlElement.Class.SQL.UpdateVerbose.ToBoolean($null);
            [string]$SQLConvertFlags = $XmlElement.Class.SQL.SQLConvertFlags;
            $x = [SQL]::new($Database, $ServerInstance, $Tables, $SyncConfiguration, $UpdateVerbose, $SQLConvertFlags);
            return $x;
        }
        "List"{$x = [List]::new($XmlElement.Class.List.Title,$XmlElement.Class.List.Redirect,$XmlElement.Class.List.DisplayCompleteWith);return $x;}
        default
        {
            Write-Warning "Class $($XmlElement.Class.ClassName) was not made.";
        }
    }
}

function GetXMLContent
{
    return Get-Content $($PSScriptRoot + '\..\Config\' + $(Get-Variable -Name 'AppPointer').Value.Machine.ConfigFile);
}

# If an object is found that has methods we want to use, return that object
# Object must be configured
function GetObjectByClass([string]$Class)
{
    [xml]$xml = GetXMLContent;
    foreach($Object in $xml.Machine.Objects.Object)
    {
        if(($Object.Type -eq 'PowerShellClass') -and ($Object.Class.Classname -eq $Class))
        {
            return $(Get-Variable $Object.VarName.InnerXml).Value;
        }
    }
    throw "Object not found!";
}

function IsNotPass($x){return ($x -ne "pass");}
function IsNotSpace($x){return ($x -ne " ");}

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
function Evaluate($value)
{
    if($value.SecType -eq "private")
    {
        return $Sql.InputReturn($value.InnerText);
    }
    elseif($null -ne $value.NodePointer)
    {
        return $( MakeHash -value $value.ParentNode -lvl $([int]$value.Lvl + 1) -Node $value.NodePointer);# The attributes lvl and nodepointer are not passing
    }
    elseif($value.InnerText.Contains('$')) # if powershell object
    {
        return $(Get-Variable $value.InnerText.Replace('$','')).Value;
    }
    else
    {
        return $value.InnerText;
    }
}

function MakeHash($value,[int]$lvl,$Node)
{
    $t = @{}; # Init hash object 
    
    if($value.Key.Count -ne $value.Value.Count)
    {throw "Objects must have equal key and values in config."}
    elseif($null -ne $Node)
    {
        $start = 0;$end = 0;
        FindNodeInterval -value $value -Node $Node -start ([ref]$start) -end ([ref]$end);
        for($i=$start;$i -le $($start + $end + 1);$i++)
        {
            if($node -eq $value.Key[$i].Node)
            {
                if(!(($value.Key[$i].Lvl -ne $value.Value[$i].Lvl) -or ([int]$value.Key[$i].Lvl -ne $lvl)))
                {
                    $t.Add($(Evaluate($value.Key[$i])),$(Evaluate($value.Value[$i])));
                }
            }
        }
    }
    else 
    {
        for($i=0;$i -lt $value.Key.Count;$i++)
        {
            if(!(($value.Key[$i].Lvl -ne $value.Value[$i].Lvl) -or ([int]$value.Key[$i].Lvl -ne $lvl)))
            {
                $t.Add($(Evaluate($value.Key[$i])),$(Evaluate($value.Value[$i])));
            }
        }
    }

    return $t;
}



function Test 
{
    if(!(Test-Path .\archive\))
    {
        mkdir archive;
    }
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
    Param($XMLReader=$XMLReader,$AppPointer=$AppPointer,[switch]$Verbose)
    [int]$Complete = 0;
    [int]$Total = $XMLReader.Machine.Programs.Program.Count;
    foreach($val in $XMLReader.Machine.Programs.Program)
    {
        if(!$Verbose)
        {
            Write-Progress -Activity "Loading Programs" -Status "Program: $($val.InnerXML)" -PercentComplete (($Complete / $Total)*100);
            $Complete++;
        }
        Set-Alias $val.Alias "$(Evaluate -value $val)" -Verbose:$Verbose -Scope Global;
    }
    Write-Progress -Activity "Loading Programs" -Status "Program: $($val.InnerXML)" -Completed;
}
function LoadModules
{
    Param($XMLReader=$XMLReader,[switch]$Verbose)
    [int]$Complete = 0;
    [int]$Total = $XMLReader.Machine.Modules.Module.Count;
    foreach($val in $XMLReader.Machine.Modules.Module)
    {
        if(!$Verbose)
        {
            Write-Progress -Activity "Loading Modules" -Status "Module: $($val)" -PercentComplete (($Complete / $Total)*100);
            $Complete++;
        }
        Import-Module $($val) -Verbose:$Verbose -Scope Global -DisableNameChecking;
    }
    Write-Progress -Activity "Loading Modules" -Status "Module: $($val.InnerXML)" -Completed;
}
function LoadObjects
{
    Param($XMLReader=$XMLReader,[switch]$Verbose)
    [int]$Complete = 0;
    [int]$Total = $XMLReader.Machine.Objects.Object.Count;
    foreach($val in $XMLReader.Machine.Objects.Object)
    {
        if(!$Verbose)
        {
            Write-Progress -Activity "Loading Objects" -Status "Object: $($val.VarName.InnerXML)" -PercentComplete (($Complete / $Total)*100);
            $Complete++;
        }
        switch ($val.Type)
        {
            "PowerShellClass"{New-Variable -Name "$($val.VarName.InnerXml)" -Value $(MakeClass -XmlElement $val) -Force -Verbose:$Verbose -Scope Global;break;}
            "XmlElement"{New-Variable -Name "$($val.VarName.InnerXml)" -Value $val.Values -Force -Verbose:$Verbose -Scope Global;break;}
            "HashTable"{New-Variable -Name "$(Evaluate -value $val.VarName)" -Value $(MakeHash -value $val -lvl 0 -Node $null) -Force -Verbose:$Verbose -Scope Global; break;}
            default {New-Variable -Name "$($val.VarName.InnerXml)" -Value $val.Values -Force -Verbose:$Verbose -Scope Global;break;}
        }
        Write-Progress -Activity "Loading Objects" -Status "Object: $($val.VarName.InnerXML)" -Completed;
    } 
}



function InsertFromCmd
{
    Param([string]$Tag,[string]$PathToAdd)
        [XML]$x = Get-Content $($(Get-Variable 'AppPointer').Value.Machine.GitRepoDir + '\Config\' + $(Get-Variable 'AppPointer').Value.Machine.ConfigFile);
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
        $x.Save($(Get-Variable 'AppPointer').Value.Machine.GitRepoDir + '\Config\' + $(Get-Variable 'AppPointer').Value.Machine.ConfigFile);
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
        default{throw "Something Bad Happened"}
    }
}

function GetTCExtID([string]$Type)
{
    [string]$str = "";
    switch($Type)
    {
        "Directory"{$str = "PrivateDirectory"}
        "Program"{$str = "PrivateProgram"}
        default{throw "Something Bad Happened"}
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
    [System.Xml.XmlDocument]$xml = GetXMLContent;
    if($xml.Machine.Email.ListOrderBy -eq "Asc")
    {
        return ($i -lt ($Max - $OrderFactor));
    }
    elseif($xml.Machine.Email.ListOrderBy -eq "Desc")
    {
        return ($i -ge 0);
    }
    else
    {
        return $false;
    }

}