<#
.Synopsis
   Function declaration test
#>
Write-Host `n -NoNewline;
[Byte]$RETURNVALUE = 0;
<# TEST START #>

Write-Host " - Testing function 1: GetNumber1" -NoNewline;
if($(GetNumber1) -ne 1)
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

Write-Host " - Testing function 2: GetNumber2" -NoNewline;
if($(GetNumber2) -ne 2)
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

<# TEST END #>
return $RETURNVALUE;