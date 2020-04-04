
Push-Location $PSScriptRoot;
    $PSScriptRoot;
    Import-Module .\Modules\Setup.psm1;
    
    Write-Host "`n`n Initializing setup`n`n";

    # InitProfile;

    # InitPointer;

    InitConfig;

Pop-Location;