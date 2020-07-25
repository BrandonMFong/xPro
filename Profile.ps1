# Engineer: Brandon Fong
# TODO change the parameter startscript to start and find other instances
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
        if((.\update-profile.ps1) -or (.\update-config.ps1 -CheckUpdate))
        {
            if("y" -eq $(Read-Host -Prompt "Do you want to restart powershell?"))
            {
                if($PSVersionTable.PSVersion.Major -lt 7){Start-Process powershell;Stop-Process -Id $PID;}
                else{Start-Process pwsh;Stop-Process -Id $PID;}
            }
            else{exit;}
        }

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

    <### NETWORK DRIVES ###>
        LoadDrives -XMLReader:$XMLReader -Verbose:$Verbose

    <### FUNCTIONS ###>
        LoadFunctions -XMLReader:$XMLReader -Verbose:$Verbose
        
    <### START ###>
        if(($XMLReader.Machine.Start.Enabled -eq "true") -and ($StartScript) -and ![string]::IsNullOrEmpty($XMLReader.Machine.Start)) 
        {
            if($XMLReader.Machine.Start.ClearHost -eq "true"){Clear-Host;} # clears host from the progess text

            # Some output methods that should be defined
            # Greetings, calendar

            # Greetings
            if(![string]::IsNullOrEmpty($XMLReader.Machine.Start.Greetings))
            {
                if([string]::IsNullOrEmpty($XMLReader.Machine.Start.Greetings.Type)){[String]$Type = "Big";}
                else{[String]$Type = $XMLReader.Machine.Start.Greetings.Type;}
                [Boolean]$Save = [Boolean]$XMLReader.Machine.Start.Greetings.Save;
                $arg = 
                @{
                    string=$XMLReader.Machine.Start.Greetings.InnerXml; # String 
                    Type=$Type; # Type of font
                    SaveToFile=$Save;
                };
                [String]$GreetingsPath = (Get-ChildItem $(".\Functions\Greetings.ps1")).FullName; # Gets the full file path to the greetings script
                & $GreetingsPath @arg;
            }

            # If the script is defined, run it
            if(![string]::IsNullOrEmpty($XMLReader.Machine.Start.Script) -and $(Test-Path $XMLReader.Machine.Start.Script))
            {
                Invoke-Expression $(Evaluate -value:$XMLReader.Machine.Start.Script);# Executes the file that the user defines
            } 
        }
    
    try 
    {
        if(![String]::IsNullOrEmpty($XMLReader.Machine.ShellSettings.GitDisplay) -and ($XMLReader.Machine.ShellSettings.Enabled.ToBoolean($null)))
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

# Method for start directory 
if($StartDir -and (![string]::IsNullOrEmpty($XMLReader.Machine.ShellSettings.StartDirectory)))
{Set-Location $XMLReader.Machine.ShellSettings.StartDirectory;}

# For debug mode
# It will run the debug script after profile is loaded
if($DebugFlag)
{
    $DebugScript = $($AppPointer.Machine.GitRepoDir + "\Resources\Debug.ps1");
    if(!(Test-Path $DebugScript)){New-Item $DebugScript;}
    & $DebugScript;
}