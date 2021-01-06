
Push-Location $PSScriptRoot;
    Import-Module .\Modules\Setup.psm1;
    Write-Warning "$($Global:AppJson.RepoName) uses Microsoft.PowerShell_profile.ps1 script.  Continuing will erase the script."
    $Answer = Read-Host -Prompt "Continue(y/n)?"
    if($Answer -ne "y"){Write-Warning "Exiting...";return;}
    Write-Host "`nInitializing setup`n";

    # Profile
    if(!(Test-Path $Profile)){ New-Item -Path $Profile -Type File -Force;}
    .\update-profile.ps1 -ForceUpdate $true;
    Write-Host "`nProfile established!`n" -BackgroundColor Black -ForegroundColor Yellow;

    # Config
    _InitConfig;

Pop-Location;