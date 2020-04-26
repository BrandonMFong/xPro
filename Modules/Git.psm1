
function Get-Tag
{
    [string]$gitstring = "Version: $(git describe --tags)"
    Write-Host "`n$($gitstring.Substring(0,$gitstring.IndexOf("-")))`n" -ForegroundColor Gray;
}

function Set-Tag
{
    Param([switch]$Major,[Switch]$Minor,[Switch]$BugPatch)
    [string]$str = "$(git describe --tags)"
    if($Major)
    {
        Write-Host "New Tag $(SweepTagAndSet -tag $str -begin 0 -TagType [TagType]::Major -tagstring $null)"
    }
    elseif($Minor)
    {
        Write-Host "New Tag $(SweepTagAndSet -tag $str -begin 0 -TagType [TagType]::Minor -tagstring $null)"
    }
    elseif($BugPatch)
    {
        Write-Host "New Tag $(SweepTagAndSet -tag $str -begin 0 -TagType [TagType]::BugPatch -tagstring $null)"
    }
    else{Write-Warning "Not Tagging"}
}

[int]$Tagnum = 0;
function SweepTagAndSet($tag,$begin,$TagType,$tagstring) # Parameters aren't working
{
    # Param([string]$tag,[int]$begin,[int]$TagType,[string]$tagstring) # got this from list.psm1
    [string]$temptag = $tagstring;
    [string]$NewTag = "";

    for($i = $begin;$i -le $tag.Length;$i++)
    {
        if($tag[$i] -eq ".")# the . means there are more to the string
        {
            
        }
        else{$temptag += $tag[$i];}
    }
    return $NewTag;
}

function GetRestOfTag([string]$Tag,[int]$index)
{
    [string]$RestTag = "";
    for($i = $index;$i -lt $Tag.Length;$i++)
    {
        $RestTag += $Tag[$i];
    }
    return $RestTag;
}

class TagType 
{
    static [int] $Major = 1;
    static [int] $Minor = 2;
    static [int] $BugPatch = 3;
}

Set-Tag -Major