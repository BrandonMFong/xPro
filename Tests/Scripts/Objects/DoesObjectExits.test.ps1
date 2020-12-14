<#
.Synopsis
   Testing if important objects exist
#>
Write-Host `n -NoNewline;
[Byte]$RETURNVALUE = 0;
<# TEST START #>

# XmlElement
Write-Host " - Checking object existence";
Write-Host "   - Testing `$XMLReader" -NoNewline;
# if([string]::IsNullOrEmpty($(Get-Variable "XMLReader")))
if([string]::IsNullOrEmpty($(Get-Variable $Global:TestReader.DoesObjExistTest.Outcome[0])))
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

Write-Host "   - Testing `$AppPointer" -NoNewline;
if([string]::IsNullOrEmpty($(Get-Variable $Global:TestReader.DoesObjExistTest.Outcome[1])))
# if([string]::IsNullOrEmpty($(Get-Variable "AppPointer")))
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}


Write-Host "   - Testing `$AppJson" -NoNewline;
if([string]::IsNullOrEmpty($(Get-Variable $Global:TestReader.DoesObjExistTest.Outcome[2])))
# if([string]::IsNullOrEmpty($(Get-Variable "AppJson")))
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}


<# TEST END #>
return $RETURNVALUE;