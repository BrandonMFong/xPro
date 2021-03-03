<#
.Synopsis
   Setup script for powershell
.Notes
#>
Param(
   [System.Management.Automation.SwitchParameter]$UpdateProfile,
   [System.Management.Automation.SwitchParameter]$UpdateConfig
)
Import-Module .\Modules\Setup.psm1;

function UpdateProfile 
{
   Param([bool]$ForceUpdate=$false)
   [Byte]$status = 0;
   # [boolean]$Updated = $false;
   [String]$ProfPath;
   [datetime]$PSProfileDate;
   [datetime]$GitProfileDate;
   

   Push-Location $PSScriptRoot

   # Get full path to git repo's profile script
   $ProfPath = $PSScriptRoot + "\profile.ps1";

   # Get the time stamp for what the user has
   $PSProfileDate = $(Get-ChildItem $($PROFILE | Split-Path -Leaf)).LastWriteTime; # Timestamp for msprofile script

   # Get the time stamp for the repo's profile
   $GitProfileDate = $(Get-ChildItem $ProfPath).LastWriteTime; # Timestamp for repo profile script

   # Compare each Date
   if(($GitProfileDate -gt $PSProfileDate) -or ($ForceUpdate))
   {
      if(!$ForceUpdate)
      {
         Write-Host  "`nThere is an update to $($Global:AppJson.RepoName) profile." -ForegroundColor Red
         $update = Read-Host -Prompt "Want to update? (y/n)";
      }

      if(($update -eq "y") -or ($ForceUpdate))
      {
         Remove-Item $PROFILE -Verbose; 
         Copy-Item $ProfPath $($PROFILE | Split-Path -Parent) -Verbose;
         Rename-Item $ProfPath $PROFILE -Verbose;

         $status = 1;
      }
      else
      {
         Write-Host "`nNot updating.`n" -ForegroundColor Red -BackgroundColor Yellow; 
      }
   }
   else
   {
      Write-Host "`nNo updates to profile`n" -ForegroundColor Green; 
   }
   Pop-Location

   if($status)
   {
      Write-Warning "Profile was updated";
   }

   return $status;
}

[Bool]$status = $true;

Push-Location $PSScriptRoot;

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

   Write-Host ""

   $status = $true;
}

if($status)
{
   Write-Warning "$($Global:AppJson.RepoName) uses Microsoft.PowerShell_profile.ps1 script.  Continuing will erase the script."
   $Answer = Read-Host -Prompt "Continue(y/n)?"
   if($Answer -ne "y")
   {
      Write-Warning "Exiting...";
      $status = $false;
   }
}

if($status)
{
   Write-Host "`nInitializing setup`n";
   
   # Create Profile
   if(!(Test-Path $Profile))
   { 
      New-Item -Path $Profile -Type File -Force;
   }

   .\update-profile.ps1 -ForceUpdate $true;

   Write-Host "`nProfile established!`n" -BackgroundColor Black -ForegroundColor Yellow;
   
   # Config
   _InitConfig;
}

Pop-Location;