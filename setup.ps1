<#
.Synopsis
   Setup script for powershell
.Notes
#>

[Bool]$status = $true;

Push-Location $PSScriptRoot;

Import-Module .\Modules\Setup.psm1;

if($status)
{
   Write-Host "";
   Write-Host " .----------------.  .----------------.  .----------------.  .----------------. " -ForegroundColor Cyan;
   Write-Host "| .--------------. || .--------------. || .--------------. || .--------------. |" -ForegroundColor Cyan;
   Write-Host "| |  ____  ____  | || |   ______     | || |  _______     | || |     ____     | |" -ForegroundColor Cyan;
   Write-Host "| | |_  _||_  _| | || |  |_   __ \   | || | |_   __ \    | || |   .'    ``.   | |" -ForegroundColor Cyan;
   Write-Host "| |   \ \  / /   | || |    | |__) |  | || |   | |__) |   | || |  /  .--.  \  | |" -ForegroundColor Cyan;
   Write-Host "| |    > ``' <    | || |    |  ___/   | || |   |  __ /    | || |  | |    | |  | |" -ForegroundColor Cyan;
   Write-Host "| |  _/ /'``\ \_  | || |   _| |_      | || |  _| |  \ \_  | || |  \  ``--'  /  | |" -ForegroundColor Cyan;
   Write-Host "| | |____||____| | || |  |_____|     | || | |____| |___| | || |   ``.____.'   | |" -ForegroundColor Cyan;
   Write-Host "| |              | || |              | || |              | || |              | |" -ForegroundColor Cyan;
   Write-Host "| '--------------' || '--------------' || '--------------' || '--------------' |" -ForegroundColor Cyan;
   Write-Host " '----------------'  '----------------'  '----------------'  '----------------' " -ForegroundColor Cyan;
   Write-Host "Author: Brando" -ForegroundColor DarkGray;
   Write-Host "";

   $status = $true;
}

if($status)
{
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
}

Pop-Location;