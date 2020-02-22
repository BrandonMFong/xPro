Param([bool]$ProfileOverride=$true)

    Write-Host "`nChecking updates...`n";
    Push-Location $($PROFILE |Split-Path -Parent);
        Get-ChildItem .\Microsoft.PowerShell_profile.ps1|
            ForEach-Object {[datetime]$PSProfile = $_.LastWriteTime}   
    Pop-Location;

    Push-Location $x.Machine.GitRepoDir;
        Get-ChildItem .\Profile.ps1|
            foreach-Object {[datetime]$GitProfile = $_.LastWriteTime}   
    Pop-Location;
    if($GitProfile -gt $PSProfile)
    {
        Write-Warning "There is an update to Powershell profile."
        $update = Read-Host -Prompt "Want to update? (y/n)";
        if($update -eq "y")
        {
            Write-Warning "Running setup-env.ps1 in 3 seconds..."; # gives me a chance to stop
            Start-Sleep(3);
            Push-Location $PSScriptRoot
                .\setup-env.ps1 -ProfileOverride $ProfileOverride 
            Pop-Location
        }
    }
    else
    {
        Write-Host "`nNo updates to profile`n";
    }
Start-Sleep 1;