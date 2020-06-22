# Engineer: Brandon Fong
Param([bool]$StartDir=$true,[Bool]$StartScript=$true,[Bool]$DebugFlag=$false)

<### CONFIG ###>
Push-Location $($PROFILE |Split-Path -Parent);
    [XML]$AppPointer = Get-Content Profile.xml;
Pop-Location
[XML]$XMLReader = Get-Content $($AppPointer.Machine.GitRepoDir + "\Config\" + $AppPointer.Machine.ConfigFile);

if(!$XMLReader.Machine.LoadProfile.ToBoolean($null)){break;} # Flag to load profile (in case someone wanting to use powershell)
if($XMLReader.Machine.LoadProcedure -eq "Verbose"){[bool]$Verbose = $true} # Helps debugging if on
else{[bool]$Verbose = $false}

Push-Location $AppPointer.Machine.GitRepoDir; 
    Import-Module .\Modules\FunctionModules.psm1 -DisableNameChecking:$true -Scope Local -WarningAction SilentlyContinue;

    <### CHECK UPDATES ###>
        if(.\update-profile.ps1){throw "Profile was updated, please rerun Profile load.";}
        if(.\update-config.ps1 -CheckUpdate){throw "Config was updated, please rerun Profile load.";}

    <### GET CREDENTIALS ###>
        CheckCredentials;
    
    # Background setting for write-progress
        Import-Module .\Modules\Terminal.psm1 -DisableNameChecking:$true -Scope Local -WarningAction SilentlyContinue;
        _SetBackgroundColor;
        
    <### PROGRAMS ###> 
        LoadPrograms -XMLReader:$XMLReader -Verbose:$Verbose
    
    <### MODULES ###>
        LoadModules -XMLReader:$XMLReader -Verbose:$Verbose
        
    <### OBJECTS ###>
        LoadObjects -XMLReader:$XMLReader -Verbose:$Verbose
    
    <### START ###>
        if($XMLReader.Machine.StartScript.ClearHost -eq "true"){Clear-Host;}
        if(($XMLReader.Machine.StartScript.Enable -eq "true") -and ($StartScript)) {Invoke-Expression $(Evaluate -value:$XMLReader.Machine.StartScript)}
    
    try 
    {
        if(![String]::IsNullOrEmpty($XMLReader.Machine.ShellSettings.GitSettings) -and ($XMLReader.Machine.ShellSettings.Enabled.ToBoolean($null)))
        {
            [string]$gitstring = "Version: $(git describe --tags)"
            if($gitstring.Contains("-")){Write-Host "`n$($gitstring.Substring(0,$gitstring.IndexOf("-")))`n" -ForegroundColor Gray;}
            else {Write-Host "`n$($gitstring)`n" -ForegroundColor Gray;}
        }
    }
    catch 
    {
        Write-Warning "You may not have posh-git installed in powershell"
    }

Pop-Location;

if($StartDir -and (![string]::IsNullOrEmpty($XMLReader.Machine.ShellSettings.StartDirectory)))
{Set-Location $XMLReader.Machine.ShellSettings.StartDirectory;}

if($DebugFlag)
{
    $DebugScript = $($AppPointer.Machine.GitRepoDir + "\Resources\Debug.ps1");
    if(!(Test-Path $DebugScript)){New-Item $DebugScript;}
    & $DebugScript;
}