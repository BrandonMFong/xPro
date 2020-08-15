<#
.Synopsis
   Running through replacements for tags
#>
Write-Host `n -NoNewline;
[Byte]$RETURNVALUE = 0;
<# TEST START #>
Import-Module $($PSScriptRoot + "\..\..\..\Modules\Terminal.psm1") -Scope Local;

Write-Host " - Checking replacements";

# @fulldir
Write-Host "   - Tag @fulldir" -NoNewline;
[string]$string="@fulldir";
_Replace([ref]$string)
if($PSScriptRoot -eq "D:\a\XmlPSProfile\XmlPSProfile\Tests\Scripts\Terminal") # On VM
{
    [string]$CheckString = 'D:\a\XmlPSProfile\XmlPSProfile\Tests';
    if($string -ne $CheckString)
    {
       Write-Host " != $($string) [FAILED]" -ForegroundColor Red;
       $RETURNVALUE = 1;
    }
    else{Write-Host " [PASSED]" -ForegroundColor Green;}
}
else
{
    Write-Host " [WARNING]" -ForegroundColor DarkYellow;
    Write-Host "    - Not on VM, @fulldir = $($string)" -ForegroundColor Gray;
}

# @currdir
Write-Host "   - Tag @currdir" -NoNewline;
[string]$string="@currdir";
_Replace([ref]$string)
if($PSScriptRoot -eq "D:\a\XmlPSProfile\XmlPSProfile\Tests\Scripts\Terminal") # On VM
{
    [string]$CheckString = 'Tests';
    if($string -ne $CheckString)
    {
       Write-Host " != $($string) [FAILED]" -ForegroundColor Red;
       $RETURNVALUE = 1;
    }
    else{Write-Host " [PASSED]" -ForegroundColor Green;}
}
else
{
    Write-Host " [WARNING]" -ForegroundColor DarkYellow;
    Write-Host "    - Not on VM, @currdir = $($string)" -ForegroundColor Gray;
}

# @date
Write-Host "   - Tag @date" -NoNewline;
[string]$string="@date";
_Replace([ref]$string)
[string]$CheckString = Get-Date -Format $Global:XMLReader.Machine.ShellSettings.Format.Date;
if($string -ne $CheckString)
{
    Write-Host " != $($string) [FAILED]" -ForegroundColor Red;
    $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}


<# TEST END #>
return $RETURNVALUE;