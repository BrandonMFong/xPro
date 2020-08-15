<#
.Synopsis
   Checking if Greetings file was created if greetings is configured
#>
Write-Host `n -NoNewline;
[Byte]$RETURNVALUE = 0;
<# TEST START #>
Import-Module $($PSScriptRoot + "\..\..\..\Modules\Terminal.psm1") -Scope Local;

Write-Host " - Checking replacements";
Write-Host "   - Tag @fulldir" -NoNewline;
[string]$string="@fulldir";
_Replace([ref]$string)
if($PSScriptRoot -eq "D:\a\XmlPSProfile\XmlPSProfile\Tests\Scripts\Terminal") # On VM
{
    [string]$CheckString = 'D:\a\XmlPSProfile\XmlPSProfile\Tests';
    if($string -eq $CheckString)
    {
       Write-Host " [FAILED]" -ForegroundColor Red;
       $RETURNVALUE = 1;
    }
    else{Write-Host " [PASSED]" -ForegroundColor Green;}
}
else
{
    Write-Host " [WARNING]" -ForegroundColor DarkYellow;
    Write-Host "    - Not on VM, @fulldir = $($string)" -ForegroundColor Gray;
}
Write-Host "   - Tag @currdir" -NoNewline;
[string]$string="@currdir";
_Replace([ref]$string)
if($PSScriptRoot -eq "D:\a\XmlPSProfile\XmlPSProfile\Tests\Scripts\Terminal") # On VM
{
    [string]$CheckString = 'Tests';
    if($string -eq $CheckString)
    {
       Write-Host " [FAILED]" -ForegroundColor Red;
       $RETURNVALUE = 1;
    }
    else{Write-Host " [PASSED]" -ForegroundColor Green;}
}
else
{
    Write-Host " [WARNING]" -ForegroundColor DarkYellow;
    Write-Host "    - Not on VM, @currdir = $($string)" -ForegroundColor Gray;
}


<# TEST END #>
return $RETURNVALUE;