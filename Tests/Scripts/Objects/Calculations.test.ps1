<#
.Synopsis
   Checking math calculations
#>
Write-Host `n -NoNewline;
[Byte]$RETURNVALUE = 0;
<# TEST START #>

Write-Host " - Kilograms to Pounds" -NoNewline;
# if($Math.KgToPounds(12) -ne 26.4554930422053)
if($Math.KgToPounds(12) -ne $Global:TestReader.CalculationsTest.Outcome[0])
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

Write-Host " - Pounds to Kilograms" -NoNewline;
# if($Math.PoundsToKg(12) -ne 5.443104)
if($Math.PoundsToKg(12) -ne $Global:TestReader.CalculationsTest.Outcome[1])
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

Write-Host " - Fahrenheit to Celsius" -NoNewline;
# if($Math.FtoC(100) -ne 37.7777777777778)
if($Math.FtoC(100) -ne $Global:TestReader.CalculationsTest.Outcome[2])
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

Write-Host " - Celsius to Fahrenheit" -NoNewline;
# if($Math.CtoF(100) -ne 212)
if($Math.CtoF(100) -ne $Global:TestReader.CalculationsTest.Outcome[3])
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

# TODO finish
# Write-Host " - Swapping variables `$x=1 & `$y=2" -NoNewline;
# [int16]$x=1;[int16]$y=2;
# $Math.SwapTwoVariables([ref]$x,[ref]$y);
# Write-Host " - Swapping variables `$x=$x & `$y=$y"
# if(($x -ne 2) -and ($y -ne 1))
# {
#    Write-Host " [ERROR]" -ForegroundColor Red;
#    $RETURNVALUE = 1;
# }
# else{Write-Host " [PASSED]" -ForegroundColor Green;}

Write-Host " - Log base 2" -NoNewline;
# if($Math.Log2(256) -ne 8)
if($Math.Log2(256) -ne $Global:TestReader.CalculationsTest.Outcome[4])
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

Write-Host " - Is Prime on 9" -NoNewline;
# if($Math.IsPrime(9))
if($Math.IsPrime($Global:TestReader.CalculationsTest.Outcome[5]))
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

Write-Host " - Is Prime on 11" -NoNewline;
if(!$Math.IsPrime($Global:TestReader.CalculationsTest.Outcome[6]))
# if(!$Math.IsPrime(11))
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

Write-Host " - From Ascii to Decimal: B = 0x42" -NoNewline;
if($Math.AsciiToDec('B') -ne 0x42)
# if($Math.AsciiToDec('B') -ne $Global:TestReader.CalculationsTest.Outcome[7]) # Todo check to see if this works
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

Write-Host " - From Decimal to Ascii: 0x42 = B" -NoNewline;
if($Math.DecToAscii(0x45) -ne $Global:TestReader.CalculationsTest.Outcome[8])
# if($Math.DecToAscii(0x45) -ne 'E')
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

# BINARY TO INT
Write-Host " - From Binary to Integer: 1001 = 9" -NoNewline;
if($Math.BinaryToInt('1001') -ne $Global:TestReader.CalculationsTest.Outcome[9])
# if($Math.BinaryToInt('1001') -ne 9)
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

# BINARY TO INT
Write-Host " - From Binary to Integer: 10110110 = 182" -NoNewline;
if($Math.BinaryToInt('10110110') -ne $Global:TestReader.CalculationsTest.Outcome[10])
# if($Math.BinaryToInt('10110110') -ne 182)
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

# OR
Write-Host " - 0101 | 0001 = 0101" -NoNewline;
# if($Math.Or('0101','0001') -ne '0101')
if($Math.Or('0101','0001') -ne $Global:TestReader.CalculationsTest.Outcome[11])
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

# XOR
Write-Host " - 0101 ^ 0001 = 0100" -NoNewline;
# if($Math.Xor('0101','0001') -ne '0100')
if($Math.Xor('0101','0001') -ne $Global:TestReader.CalculationsTest.Outcome[12])
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

# AND
Write-Host " - 0101 & 0001 = 0001" -NoNewline;
# if($Math.And('0101','0001') -ne '0001')
if($Math.And('0101','0001') -ne $Global:TestReader.CalculationsTest.Outcome[13])
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

# BADD
Write-Host " - 0110 + 0010 = 1000" -NoNewline;
# if($Math.badd('0110','0010') -ne '1000')
if($Math.badd('0110','0010') -ne $Global:TestReader.CalculationsTest.Outcome[14])
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

<# TEST END #>
return $RETURNVALUE;