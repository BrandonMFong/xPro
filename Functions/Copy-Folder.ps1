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
    [string]$BaseDir
    [string]$CommonPath = "";

    Folder([Object[]]$Paths,[string]$BaseDir)
    {
        $this.FullPaths = $Paths;
        $this.BaseDir = $BaseDir;
    }

    [void]FindCommonPath() # I don't think I need this for this function but it is probably a good method to save
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

    [void]CopyOver([string]$NewBaseDir)
    {
        foreach($path in $this.FullPaths)
        {
            [string]$p = $path.ToString();
            Copy-Item $p $p.Replace($this.BaseDir,$NewBaseDir);
        }
    }
}

$f = $f.Replace('.','');
$d = $d.Replace('.','');
if (!(Test-Path $((Get-Location).Path + $f))){throw [GlobalScriptsException] "$($f) does not exist."}
if (!(Test-Path $((Get-Location).Path + $d))){throw [GlobalScriptsException] "$($d) does not exist."}


if(("null" -ne $f) -and ("null" -ne $d))
{
    [System.Object[]]$APaths = (Get-ChildItem -Recurse ((get-location).Path + $f)).FullName;
    [string]$ABaseDir = (((Get-Location).Path + $f) | Split-Path -Parent);
    $AFolder = [Folder]::new($APaths,$ABaseDir); 
    $BFolder = ((Get-Location).Path + $d).FullName; # Gets the full directory of the folder you are trying to copying to
    $AFolder.CopyOver($BFolder);
}
else 
{
    throw [GlobalScriptsException] "Cannot move $($f) to $($d).";
}