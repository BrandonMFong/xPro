<#
.Synopsis
   Testing objects
#>
Write-Host `n -NoNewline;
[Byte]$RETURNVALUE = 0;
<# TEST START #>

# XmlElement
Write-Host " - Testing XmlElement Object";
Write-Host "   - Testing `$User.Facebook" -NoNewline;
if($User.Facebook -ne "https://facebook.com")
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}
Write-Host "   - Testing `$User.Youtube" -NoNewline;
if($User.Youtube -ne "https://Youtube.com")
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}
Write-Host "   - Testing `$User.WhatsApp" -NoNewline;
if($User.WhatsApp -ne "https://web.whatsapp.com/")
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

# HashTable
Write-Host " - Testing HashTable Object";
Write-Host "   - Testing HashTable Object LEVEL = 0" -NoNewline;
if($College.Netflix -ne "https://Netflix.com")
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}
Write-Host "   - Testing HashTable Object LEVEL = 1" -NoNewline;
if($College.Fafsa.URL -ne "https://fafsa.gov/")
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}
Write-Host "   - Testing HashTable Object LEVEL = 2" -NoNewline;
if($College.SONOMA.Slack.Email -ne "TestEmail@Fake.com")
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}
Write-Host "   - Testing HashTable Object LEVEL = 3" -NoNewline;
if($College.SONOMA.Classes.CES440.URL -ne "http://web.sonoma.edu/users/k/kujoory/")
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

# PowerShellClass
Write-Host " - Testing PowerShellClass Objects existence";
Write-Host "   - Does `$Calendar exist" -NoNewline;
if(Get-Variable 'Calendar'){Write-Host " [PASSED]" -ForegroundColor Green;}
else
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
Write-Host "   - Does `$Calendar exist" -NoNewline;
if(Get-Variable 'Math'){Write-Host " [PASSED]" -ForegroundColor Green;}
else
{
   Write-Host " [FAILED]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}


<# TEST END #>
return $RETURNVALUE;