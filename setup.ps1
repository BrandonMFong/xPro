
Push-Location $PSScriptRoot;
    Import-Module .\Modules\Setup.psm1;
    Write-Warning "GlobalScripts uses Microsoft.PowerShell_profile.ps1 script.  Continuing will erase the script."
    $Answer = Read-Host -Prompt "Continue(y/n)?"
    Write-Host "`nInitializing setup`n";
    InitProfile;
    InitConfig;
Pop-Location;