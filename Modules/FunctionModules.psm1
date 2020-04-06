using module .\..\Classes\Calendar.psm1;
using module .\..\Classes\Math.psm1;
using module .\..\Classes\SQL.psm1;
using module .\..\Classes\Web.psm1;
using module .\..\Classes\List.psm1;

$Sql = [SQL]::new($XMLReader.Machine.Objects.Database,$XMLReader.Machine.Objects.ServerInstance, $null); # This needs to be unique per config

function MakeClass($XmlElement)
{
    switch($XmlElement.Class.ClassName)
    {
        "Calendar" {$x = [Calendar]::new();return $x;}
        "Web" {$x = [Web]::new();return $x;}
        "Calculations" {$x = [Calculations]::new();return $x;}
        "SQL" {$x = [SQL]::new($XmlElement.Class.SQL.Database, $XmlElement.Class.SQL.ServerInstance, $XmlElement.Class.SQL.Tables);return $x;}
        "List"{$x = [List]::new($XmlElement.Class.Title);return $x;}
        default
        {
            Write-Warning "Class $($XmlElement.Class.ClassName) was not made.";
        }
    }
}

function GetXMLContent
{
    Push-Location $PSScriptRoot;
        return Get-Content $('..\Config\' + $env:COMPUTERNAME.ToString() + '.xml');
    Pop-Location;
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
    if($value.SecurityType -eq "private")
    {
        return $Sql.InputReturn($value.InnerText);
    }
    else 
    {
        if($null -ne $value.NodePointer)
        {
            return $( MakeHash -value $value.ParentNode -lvl $([int]$value.Lvl + 1) -Node $value.NodePointer);# The attributes lvl and nodepointer are not passing
        }
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

function GetVarName($value)
{
    switch ($value.SecurityType)
    {
        "private"
        {
            return $Sql.InputReturn($value.InnerXML);
        }
        default{return $value.InnerXML}
    }
}

function EvaluateDir($value)
{
    if($value.SecurityType -eq "private")
    {
        return $Sql.InputReturn($value.InnerText);
    }
    else {return $value.InnerText;}
}
function Test 
{
    if(!(Test-Path .\archive\))
    {
        throw "Directory .\archive\ does not exist."; 
        exit; # Exists because if archive doesn't exist then why zip
    }
}
function DoesFileExist($file)
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
    Param($XMLReader=$XMLReader,$AppPointer=$AppPointer)
    foreach($val in $XMLReader.Machine.Programs.Program)
    {
        switch($val.Type)
        {
            "External"{Set-Alias $val.Alias "$($val.InnerXML)" -Verbose -Scope Global;}
            "Internal"{Set-Alias $val.Alias "$($AppPointer.Machine.GitRepoDir + $val.InnerXML)" -Verbose -Scope Global;}
            default {Write-Error "$($val.Alias) => $($val.InnerXML)`n Not set!"}
        }
    }
}
function LoadModules
{
    Param($XMLReader=$XMLReader,$AppPointer=$AppPointer)
    foreach($val in $XMLReader.Machine.Modules.Module)
    {
        Import-Module $($AppPointer.Machine.GitRepoDir + $val) -Scope Global;
    }
}
function LoadObjects
{
    Param($XMLReader=$XMLReader,$AppPointer=$AppPointer)
    foreach($val in $XMLReader.Machine.Objects.Object)
    {
        switch ($val.Type)
        {
            "PowerShellClass"{New-Variable -Name "$($val.VarName.InnerXml)" -Value $(MakeClass -XmlElement $val) -Force -Verbose -Scope Global;break;}
            "XmlElement"{New-Variable -Name "$($val.VarName.InnerXml)" -Value $val.Values -Force -Verbose -Scope Global;break;}
            "HashTable"{New-Variable -Name "$(GetVarName -value $val.VarName)" -Value $(MakeHash -value $val -lvl 0 -Node $null) -Force -Verbose -Scope Global; break;}
            default {New-Variable -Name "$($val.VarName.InnerXml)" -Value $val.Values -Force -Verbose -Scope Global;break;}
        }
    } 
}

