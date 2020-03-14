using module .\..\Classes\Calendar.psm1;
using module .\..\Classes\Math.psm1;
using module .\..\Classes\SQL.psm1;
using module .\..\Classes\Web.psm1;
using module .\..\Classes\Windows.psm1;
using module .\..\Classes\ToDoList.psm1;
# using module .\..\Classes\PrivateObject.psm1;

$Sql = [SQL]::new('BrandonMFong','BRANDONMFONG\SQLEXPRESS', $null);
function MakeClass($XmlElement)
{
    switch($val.Class.ClassName)
    {
        "Calendar" {$x = [Calendar]::new();return $x;}
        "Web" {$x = [Web]::new();return $x;}
        "Calculations" {$x = [Calculations]::new();return $x;}
        "SQL" {$x = [SQL]::new($val.Class.Database, $val.Class.ServerInstance, $val.Class.Tables);return $x;}
        "Windows" {$x = [Windows]::new();return $x;}
        "ToDoList"{$x = [ToDoList]::new($val.Class.filename);return $x;}
        default
        {
            throw "Class $($val.Class.ClassName) was not made.";
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
        if(($Object.HasClass -eq 'true') -and ($Object.Class.Classname -eq $Class))
        {
            return $(Get-Variable $Object.VarName).Value;
        }
    }
    throw "Object not found!";
}

function IsNotPass($x){return ($x -ne "pass");}
function IsNotSpace($x){return ($x -ne " ");}

function FindNodeCount($val,[string]$Node)
{
    $n = 0;
    foreach($v in $val.Key)
    {
        if($v.Node -eq $Node){$n++;}
    }
    return $n;
}
function Evaluate($val)
{
    if($val.SecurityType -eq "private")
    {
        return $Sql.InputReturn($val.InnerText);
    }
    else 
    {
        if($null -ne $val.NodePointer)
        {
            return MakeHash($val.ParentNode,$val.Lvl+1,$val.NodePointer);
        }
        return $val.InnerText;
    }
}

function MakeHash($val,[int]$lvl,[string]$Node)
{
    $t = @{}; # Init hash object 
    # $lvl = 0;
    
    if($val.Key.Count -ne $val.Value.Count)
    {throw "Objects must have equal key and values in config."}

    # TODO figure this out
    elseif(!$Node.Equals($null))
    {
        # $n = 0;
        # foreach ($y in $val)
        for($i=FindNodeCount($val,$Node);$i -lt $val.Key.Count;$i++)
        {
            # Found the count but how do you know when to start/stop indexing?
            if($node -eq $val.Key[$i].Node)
            {
                if(($val.Key[$i].Lvl -ne $val.Value[$i].Lvl) -and ($val.Key[$i].Lvl -eq $lvl))
                {throw "Levels are not the same!"}
                else 
                {
                    $t.Add($(Evaluate($val.Key[$i])),$(Evaluate($val.Value[$i])));
                }
            }
        }
    }
    else 
    {
        for($i=0;$i -lt $val.Key.Count;$i++)
        # foreach($val in $val)
        {
            if(($val.Key[$i].Lvl -ne $val.Value[$i].Lvl) -and ($val.Key[$i].Lvl -eq $lvl))
            {throw "Levels are not the same!"}
            else 
            {
                $t.Add($(Evaluate($val.Key[$i])),$(Evaluate($val.Value[$i])));
            }
        }
    }

    return $t;
}
function MakeObject([xml]$x)
{
    #success now just decode 
    foreach($val in $x.Machine.Objects.Object)
    {
        if($val.HasClass -eq "true"){New-Variable -Name "$($val.VarName)" -Value $(MakeClass($val)) -Force -Verbose;}
        else{New-Variable -Name "$($val.VarName.InnerText)" -Value $(MakeHash($val,0,"null")) -Force -Verbose}
    }     
}

