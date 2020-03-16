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
    switch($value.Class.ClassName)
    {
        "Calendar" {$x = [Calendar]::new();return $x;}
        "Web" {$x = [Web]::new();return $x;}
        "Calculations" {$x = [Calculations]::new();return $x;}
        "SQL" {$x = [SQL]::new($value.Class.Database, $value.Class.ServerInstance, $value.Class.Tables);return $x;}
        "Windows" {$x = [Windows]::new();return $x;}
        "ToDoList"{$x = [ToDoList]::new($value.Class.filename);return $x;}
        default
        {
            throw "Class $($value.Class.ClassName) was not made.";
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

function FindNodeInterval($value,[string]$Node,[ref]$start,[ref]$end)
{
    $n = 1; $u = 0;
    $foundbeginning = $false;
    foreach($v in $value.Key)
    {
        if(($v.Node -eq $Node) -and !$foundbeginning){$start.Value = $n;$u = 1;$foundbeginning = $true;}
        elseif($v.Node -eq $Node){$u++;}
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
            return $( MakeHash -value $value.ParentNode -lvl $($value.Lvl + 1) -Node $value.NodePointer);# The attributes lvl and nodepointer are not passing
        }
        return $value.InnerText;
    }
}

function MakeHash($value,[int]$lvl,$Node)
{
    $t = @{}; # Init hash object 
    # $lvl = 0;
    
    if($value.Key.Count -ne $value.Value.Count)
    {throw "Objects must have equal key and values in config."}

    # TODO figure this out
    elseif($null -ne $Node)
    {
        $start = 0;$end = 0;
        FindNodeInterval -value $value -Node $Node -start ([ref]$start) -end ([ref]$end);
        for($i=$start;$i -lt $end;$i++)
        {
            # Found the count but how do you know when to start/stop indexing?
            if($node -eq $value.Key[$i].Node)
            {
                if(($value.Key[$i].Lvl -ne $value.Value[$i].Lvl) -and ($value.Key[$i].Lvl -eq $lvl))
                {throw "Levels are not the same!"}
                else 
                {
                    $t.Add($(Evaluate($value.Key[$i])),$(Evaluate($value.Value[$i])));
                }
            }
        }
    }
    else 
    {
        for($i=0;$i -lt $value.Key.Count;$i++)
        # foreach($value in $value)
        {
            if(($value.Key[$i].Lvl -ne $value.Value[$i].Lvl) -and ($value.Key[$i].Lvl -eq $lvl))
            {throw "Levels are not the same!"}
            else 
            {
                $t.Add($(Evaluate($value.Key[$i])),$(Evaluate($value.Value[$i])));
            }
        }
    }

    return $t;
}

# function MakeObject([xml]$x)
# {
#     #success now just decode 
#     foreach($value in $x.Machine.Objects.Object)
#     {
#         if($value.HasClass -eq "true"){New-Variable -Name "$($value.VarName)" -Value $(MakeClass($value)) -Force -Verbose;}
#         else{New-Variable -Name "$($value.VarName.InnerText)" -Value $(MakeHash($value,0,"null")) -Force -Verbose}
#     }     
# }

