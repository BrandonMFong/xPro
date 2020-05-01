# Engineer: Brandon Fong
# TODO
# ...

<### CONFIG ###>
Push-Location $($PROFILE |Split-Path -Parent);
    [XML]$AppPointer = Get-Content Profile.xml;
Pop-Location
# [string]$ConfigFile = $AppPointer.Machine.GitRepoDir + "\Config\" + $AppPointer.Machine.ConfigFile;
[XML]$XMLReader = Get-Content $($AppPointer.Machine.GitRepoDir + "\Config\" + $AppPointer.Machine.ConfigFile);

if($XMLReader.Machine.LoadProcedure -eq "Verbose"){[bool]$Verbose = $true}
else{[bool]$Verbose = $false}

Push-Location $AppPointer.Machine.GitRepoDir; 
    Import-Module .\Modules\FunctionModules.psm1 -DisableNameChecking;

    <### CHECK UPDATES ###>
        if(.\update-profile.ps1){throw "Profile was updated, please rerun Profile load.";}
        
    <### PROGRAMS ###> 
        LoadPrograms -XMLReader:$XMLReader -Verbose:$Verbose
    
    <### MODULES ###>
        LoadModules -XMLReader:$XMLReader -Verbose:$Verbose
        
    <### OBJECTS ###>
        LoadObjects -XMLReader:$XMLReader -Verbose:$Verbose
    
    <### START ###>
        if($XMLReader.Machine.StartScript.ClearHost -eq "true"){Clear-Host;}
        if($XMLReader.Machine.StartScript.Enable -eq "true") {Invoke-Expression $($XMLReader.Machine.StartScript.InnerXML)}
    
    try 
    {
        [string]$gitstring = "Version: $(git describe --tags)"
        if($gitstring.Contains("-")){Write-Host "`n$($gitstring.Substring(0,$gitstring.IndexOf("-")))`n" -ForegroundColor Gray;}
        else {Write-Host "`n$($gitstring)`n" -ForegroundColor Gray;}
    }
    catch 
    {
        Write-Warning "You may not have posh-git installed in powershell"
    }

Pop-Location;