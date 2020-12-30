<#
.Synopsis
   Testing goto function
#>
Write-Host `n -NoNewline;
[Byte]$RETURNVALUE = 0;
<# TEST START #>

# This will fail if you are running locally
Write-Host " - Goto test on ConfigDir config" -NoNewline;

# If we are on github's VM
# if($PSScriptRoot -eq "D:\a\xPro\xPro\Tests\Scripts\Scripts")
if($PSScriptRoot -eq $Global:TestReader.GotoTest.Outcome[0])
{
   try{Goto1 ConfigDir1 -push;}
   catch
   {
      Write-Host " [ERROR]" -ForegroundColor Red;
      $RETURNVALUE = 1;
   }
   # if((Get-Location).Path -eq 'D:\a\xPro\xPro\Config')
   if((Get-Location).Path -eq $Global:TestReader.GotoTest.Outcome[1])
   {
       Write-Host " [PASSED]" -ForegroundColor Green;
       Pop-Location;
   }
}
else
{
   try{Goto2 ConfigDir2 -push;}
   catch
   {
      Write-Host " [ERROR]" -ForegroundColor Red;
      $RETURNVALUE = 1;
   }
   # if((Get-Location).Path -eq 'B:\SOURCE\Repo\xPro\Config') # Good to be this way because it is local 
   if((Get-Location).Path -eq $Global:TestReader.GotoTest.Outcome[2]) # Good to be this way because it is local 
   {
       Write-Host " [PASSED]" -ForegroundColor Green;
       Pop-Location;
   }
}

<# TEST END #>
return $RETURNVALUE;