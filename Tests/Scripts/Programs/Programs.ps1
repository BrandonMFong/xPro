<#
.Synopsis
   Testing Programs
#>
Write-Host `n -NoNewline;
[Byte]$RETURNVALUE = 0;
<# TEST START #>

Write-Host " - Testing Aliases (Programs)";
Write-Host "   - Testing Alias 'Archive'" -NoNewline;
if((Get-Alias Archive).Definition -ne "D:\a\xPro\xPro\Functions\Archive.ps1")
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

Write-Host "   - Testing Alias 'Get-Calendar'" -NoNewline;
if((Get-Alias Get-Calendar).Definition -ne "D:\a\xPro\xPro\Functions\Calendar.ps1")
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

<# TEST END #>
return $RETURNVALUE;