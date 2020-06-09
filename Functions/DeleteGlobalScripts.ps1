param([Switch]$Force)

if(!$Force)
{
    Write-Warning "You are going to delete `$Profile and Profile.xml.  Would you like to continue(y/n)?";
    if('y' -ne $(Read-Host -Prompt "So?")){exit;}
}
Push-Location $($PROFILE | Split-Path -Parent);
    Remove-Item $PROFILE -Force;
    Remove-Item .\Profile.xml;
Pop-Location;