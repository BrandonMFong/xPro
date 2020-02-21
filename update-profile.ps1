Param([bool]$ProfileOverride=$true)

Write-Warning "Running setup-env.ps1 in 3 seconds..."; # gives me a chance to stop
Start-Sleep(3);
Push-Location $PSScriptRoot
    .\setup-env.ps1 -ProfileOverride $ProfileOverride 
Pop-Location
