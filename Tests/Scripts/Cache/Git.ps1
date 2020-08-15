<#
.Synopsis
   In order for the Terminal replacements to be efficient, I cache the file path in a file
#>
Write-Host `n -NoNewline;
[Byte]$RETURNVALUE = 0;
<# TEST START #>

Write-Host " - Git cache file created" -NoNewline;

# @gitbranch
[string]$string="@gitbranch";
_Replace([ref]$string); # Makes the cache file
# [string]$CheckString = 'D.a.XmlPSProfile.XmlPSProfile.Tests';
[string]$CheckString = $($Global:AppPointer.Machine.GitRepoDir + "\Tests").Replace("\",".").Replace(":",".").Replace("..",".");
if(!(Test-Path $($Global:AppPointer.Machine.GitRepoDir + "\Cache\git\" + $CheckString)))
{
    Write-Host " [FAILED]" -ForegroundColor Red;
    $RETURNVALUE = 1;
}
else{Write-Host " [PASSED]" -ForegroundColor Green;}


<# TEST END #>
return $RETURNVALUE;