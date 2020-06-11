param([Switch]$Force)

if(!$Force)
{
    Write-Warning "You are going to delete `$Profile and Profile.xml.  Would you like to continue(y/n)?";
    if('y' -ne $(Read-Host -Prompt "So?")){exit;}
}
Push-Location $($PROFILE | Split-Path -Parent);
    if(Test-Path .\Profile.xml)
    {
        Remove-Item $PROFILE -Force;
        Write-Host "Removed $($PROFILE)" -ForegroundColor Green;
    }
    if(Test-Path .\Profile.xml)
    {
        Remove-Item .\Profile.xml;
        Write-Host "Removed .\Profile.xml" -ForegroundColor Green;
    }
Pop-Location;