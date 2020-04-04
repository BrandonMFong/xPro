<#
.Synopsis

.Description

.Notes
    I'm assuming the paths provided in the params do not start with \
    How to make it stop at the base dir
#>

Param
(
    [string]$f="null",
    [string]$d="null"
)

class Folder 
{
    [object[]]$FullPaths;
    [string]$CommonPath = "";

    Folder([Object[]]$Paths)
    {
        $this.FullPaths = $Paths;
        $this.FindCommonPath();
    }

    [void]FindCommonPath()
    {
        $common = $false;
        for($i = 0;$i -lt $this.FullPaths[0].Length;$i++)# comparing against the first 
        {
            for($j = 1; $j -lt $this.FullPaths.Length;$j++)
            {
                if($this.FullPaths[0][$i] -eq $this.FullPaths[$j][$i])
                {
                    $common = $true;
                }
                else{$common = $false;}
            }
            if($common){$this.CommonPath = $this.CommonPath + $this.FullPaths[0][$i];}
            else{break;}
        }
    }

    [void]CopyOver()
    {

    }
}
$f = $f.Replace('.','');
$d = $d.Replace('.','');
if (!(Test-Path $((Get-Location).Path + $f))){throw "$($f) does not exist."}
if (!(Test-Path $((Get-Location).Path + $d))){throw "$($d) does not exist."}


if(("null" -ne $f) -and ("null" -ne $d))
{
    $A_Folder = [Folder]::new((Get-ChildItem -Recurse ((get-location).Path + $f)).FullName); 
    $B_Folder = (Get-ChildItem -Recurse ((Get-Location).Path + '\Donations\')).FullName|Split-Path -Parent;
    $A_Folder.CommonPath;
    $B_Folder;
}
else 
{
    throw "Cannot move $($f) to $($d).";
}