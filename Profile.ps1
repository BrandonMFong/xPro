# Engineer: Brandon Fong
# TODO
# ...

<### CONFIG ###>
Push-Location $($PROFILE |Split-Path -Parent);
    [XML]$AppPointer = Get-Content Profile.xml;
Pop-Location
$ConfigFile = $AppPointer.Machine.GitRepoDir + "\Config\" + $AppPointer.Machine.ConfigFile;
[XML]$XMLReader = Get-Content $ConfigFile

Push-Location $AppPointer.Machine.GitRepoDir; 
    Import-Module .\Modules\FunctionModules.psm1 -DisableNameChecking;

    <### CHECK UPDATES ###>
        if(.\update-profile.ps1){throw "Profile was updated, please rerun Profile load.";}
        
    <### PROGRAMS ###> 
        LoadPrograms -XMLReader $XMLReader
    
    <### MODULES ###>
        LoadModules -XMLReader $XMLReader
        
    <### OBJECTS ###>
        LoadObjects -XMLReader $XMLReader
    
    <### START ###>
        if($XMLReader.Machine.StartScript.ClearHost -eq "true"){Clear-Host;}
        if($XMLReader.Machine.StartScript.Enable -eq "true") {Invoke-Expression $($XMLReader.Machine.StartScript.InnerXML)}

    try 
    {
        Write-Host "`nVersion - $(git describe --tags) `n" -ForegroundColor Gray;
    }
    catch 
    {
        Write-Warning "You may not have posh-git installed in powershell"
    }

Pop-Location;