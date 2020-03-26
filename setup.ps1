
Push-Location $PSScriptRoot;
    Import-Module .\Modules\Setup.psm1;
    
    Write-Host "`n`n Initializing setup`n`n";
    $ConfigFileName = $(GetConfigName) + ".xml";

Pop-Location;