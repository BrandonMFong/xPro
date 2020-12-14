<#
.Synopsis
   Function declaration test
#>
Write-Host `n -NoNewline;
[Byte]$RETURNVALUE = 0;
<# TEST START #>

Write-Host " - Testing function 1: GetNumber1" -NoNewline;
# if($(GetNumber1) -ne 1)
if($(GetNumber1) -ne $Global:TestReader.FunctionDecTest.Outcome[0])
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

Write-Host " - Testing function 2: GetNumber2" -NoNewline;
# if($(GetNumber2) -ne 2)
if($(GetNumber2) -ne $Global:TestReader.FunctionDecTest.Outcome[1])
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

<# TEST END #>
return $RETURNVALUE;