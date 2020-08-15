<#
.Synopsis
   Checking if Greetings file was created if greetings is configured
#>
Write-Host `n -NoNewline;
[Byte]$RETURNVALUE = 0;
<# TEST START #>

Write-Host " - Is Greetings cached" -NoNewline;
[string]$string=$Global:XMLReader.Machine.Start.Greetings.InnerXml; # String 
[string]$TypeString = ".$($Global:XMLReader.Machine.Start.Greetings.Type)";
if(!(Test-Path $($Global:AppPointer.Machine.GitRepoDir + "\Cache\Greetings\" + $string + $TypeString + ".txt")))
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

<# TEST END #>
return $RETURNVALUE;