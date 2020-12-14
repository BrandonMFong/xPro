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
# [string]$path = $($Global:AppPointer.Machine.GitRepoDir + "\Cache\WebRequests\Greetings\" + $string + $TypeString + "." + $($Global:AppPointer.Machine.ConfigFile | Split-Path -Leaf) + ".txt");
[string]$path = $($Global:AppPointer.Machine.GitRepoDir + $Global:TestReader.GreetingsTest.Outcome + $string + $TypeString + "." + $($Global:AppPointer.Machine.ConfigFile | Split-Path -Leaf) + ".txt");
if(!(Test-Path $path))
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

<# TEST END #>
return $RETURNVALUE;