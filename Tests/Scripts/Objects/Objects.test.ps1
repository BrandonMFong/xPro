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
if($User.Facebook -ne $Global:TestReader.GeneralObjectTest.Outcome[0])
# if($User.Facebook -ne "https://facebook.com")
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}
Write-Host "   - Testing `$User.Youtube" -NoNewline;
if($User.Youtube -ne $Global:TestReader.GeneralObjectTest.Outcome[1])
# if($User.Youtube -ne "https://Youtube.com")
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}
Write-Host "   - Testing `$User.WhatsApp" -NoNewline;
if($User.WhatsApp -ne $Global:TestReader.GeneralObjectTest.Outcome[2])
# if($User.WhatsApp -ne "https://web.whatsapp.com/")
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

# HashTable
Write-Host " - Testing HashTable Object";
Write-Host "   - Testing HashTable Object LEVEL = 0" -NoNewline;
if($College.Netflix -ne $Global:TestReader.GeneralObjectTest.Outcome[3])
# if($College.Netflix -ne "https://Netflix.com")
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}
Write-Host "   - Testing HashTable Object LEVEL = 1" -NoNewline;
if($College.Fafsa.URL -ne $Global:TestReader.GeneralObjectTest.Outcome[4])
# if($College.Fafsa.URL -ne "https://fafsa.gov/")
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}
Write-Host "   - Testing HashTable Object LEVEL = 2" -NoNewline;
if($College.SONOMA.Slack.Email -ne $Global:TestReader.GeneralObjectTest.Outcome[5])
# if($College.SONOMA.Slack.Email -ne "TestEmail@Fake.com")
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}
Write-Host "   - Testing HashTable Object LEVEL = 3" -NoNewline;
if($College.SONOMA.Classes.CES440.URL -ne $Global:TestReader.GeneralObjectTest.Outcome[6])
# if($College.SONOMA.Classes.CES440.URL -ne "http://web.sonoma.edu/users/k/kujoory/")
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}

# PowerShellClass
Write-Host " - Testing PowerShellClass Objects existence";
Write-Host "   - Does `$Calendar exist" -NoNewline;
# if(Get-Variable 'Calendar'){Write-Host " [PASSED]" -ForegroundColor Green;}
if(Get-Variable $Global:TestReader.GeneralObjectTest.Outcome[7]){Write-Host " [PASSED]" -ForegroundColor Green;}
else
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}
Write-Host "   - Does `$Math exist" -NoNewline;
if(Get-Variable $Global:TestReader.GeneralObjectTest.Outcome[8]){Write-Host " [PASSED]" -ForegroundColor Green;}
# if(Get-Variable 'Math'){Write-Host " [PASSED]" -ForegroundColor Green;}
else
{
   Write-Host " [ERROR]" -ForegroundColor Red;
   $RETURNVALUE = 1;
}


<# TEST END #>
return $RETURNVALUE;