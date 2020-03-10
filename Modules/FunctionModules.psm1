
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
    [bool]$foundobject = $false;
    $obj;
    foreach($Object in $xml.Machine.Objects.Object)
    {
        if(($Object.HasClass -eq 'true') -and ($Object.Class.Classname -eq $Class))
        {
            $foundobject = $true;
            $obj = $(Get-Variable $Object.VarName).Value;
        }
    }
    if($foundobject){return $obj;}
    else{throw "Object not found!";}
}

function IsNotPass($x){return ($x -ne "pass");}
function IsNotSpace($x){return ($x -ne " ");}
