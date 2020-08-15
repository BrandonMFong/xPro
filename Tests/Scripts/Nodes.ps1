<#
.Synopsis
   Confirming profile load
#>
Write-Host `n -NoNewline;
[Byte]$RETURNVALUE = 0;
<# TEST START #>

# Testing if the profile was loaded
Write-Host " - MachineName Attribute test" -NoNewline;
if($Global:XMLReader.Machine.MachineName -ne "GitHubVirtualMachine")
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

<# TEST END #>
return $RETURNVALUE;