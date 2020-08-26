# Engineer: Brandon Fong
# Important Global Variables: XmlReader, AppPointer, LogHandler
Param(
    [System.Boolean]$StartDir=$true,
    [System.Boolean]$StartScript=$true,
    [System.Boolean]$DebugFlag=$false,
    [String]$BuildPath=$null,
    [System.Boolean]$Silent=$false # There is Verbose/Progress. Using Progress in github workflow looks silent
)

<### GET AppPointer ###>
if(![string]::IsNullOrEmpty($BuildPath)){Push-Location $($BuildPath|Split-Path -Parent);}
else{Push-Location $($PROFILE |Split-Path -Parent);}
    [System.Xml.XmlDocument]$Global:AppPointer = Get-Content Profile.xml; # Will always be Profile.xml
Pop-Location;
<### LOAD ###>
Push-Location $Global:AppPointer.Machine.GitRepoDir; 
    <# GET App Json, think of a better name for this #>
    [System.Object[]]$AppJson = Get-Content .\Config\app.json|ConvertFrom-Json;
    # pwsh
    # Todo test different environments
    if($IsWindows){[System.Xml.XmlDocument]$Global:XMLReader = Get-Content $($Global:AppPointer.Machine.GitRepoDir + $Global:AppJson.Directories.UserConfig + $Global:AppPointer.Machine.ConfigFile);}
    else{[System.Xml.XmlDocument]$Global:XMLReader = Get-Content $($Global:AppPointer.Machine.GitRepoDir + $Global:AppJson.Directories.UserConfig + $Global:AppPointer.Machine.ConfigFile);}

    if(!$Global:XMLReader.Machine.LoadProfile.ToBoolean($null)){break;} # Flag to load profile (in case someone wanting to use powershell)
    if(($Global:XMLReader.Machine.LoadProcedure -eq "Verbose") -and !$Silent){[System.Boolean]$Verbose = $true} # Helps debugging if on
    else{[System.Boolean]$Verbose = $false}

    Import-Module .\Modules\FunctionModules.psm1 -DisableNameChecking:$true -Scope Local -WarningAction SilentlyContinue;

    <### LOGS ###>
        $Global:LogHandler = Get-LogObject;

    <### CHECK UPDATES ###>
        if([string]::IsNullOrEmpty($BuildPath))
        {
            if((.\update-profile.ps1) -or (.\update-config.ps1 -CheckUpdate))
            {
                if("y" -eq $(Read-Host -Prompt "Do you want to restart powershell? (y/n)"))
                {
                    if($PSVersionTable.PSVersion.Major -lt 7){Start-Process powershell;Stop-Process -Id $PID;}
                    else{Start-Process pwsh;Stop-Process -Id $PID;}
                }
                else{exit;}
            }
        }

    <### GET CREDENTIALS ###>
        CheckCredentials;
    
    <# BACKGROUND SETTINGS #>
        # Doing this early so if Verbose:$false then progress color will be set
        Import-Module .\Modules\Terminal.psm1 -DisableNameChecking:$true -Scope Local -WarningAction SilentlyContinue;
        _SetBackgroundColor;
        
    <### PROGRAMS ###> 
        LoadPrograms -XMLReader:$Global:XMLReader -Verbose:$Verbose
    
    <### MODULES ###>
        LoadModules -XMLReader:$Global:XMLReader -Verbose:$Verbose
        
    <### OBJECTS ###>
        LoadObjects -XMLReader:$Global:XMLReader -Verbose:$Verbose

    # <### NETWORK DRIVES ###>
    #     LoadDrives -XMLReader:$Global:XMLReader -Verbose:$Verbose

    <### FUNCTIONS ###>
        LoadFunctions -XMLReader:$Global:XMLReader -Verbose:$Verbose
        
    <### START ###>
        if(($Global:XMLReader.Machine.Start.Enabled -eq "true") -and ($StartScript) -and ![string]::IsNullOrEmpty($Global:XMLReader.Machine.Start)) 
        {
            if($Global:XMLReader.Machine.Start.ClearHost -eq "true"){Clear-Host;} # clears host from the progess text

            # Some output methods that should be defined
            # Greetings, calendar

            # Greetings
            if(![string]::IsNullOrEmpty($Global:XMLReader.Machine.Start.Greetings))
            {
                if([String]::IsNullOrEmpty($Global:XMLReader.Machine.Start.Greetings.Type)){[String]$Type = "Big";}
                else{[String]$Type = $Global:XMLReader.Machine.Start.Greetings.Type;}
                [System.Boolean]$Save = [System.Boolean]$Global:XMLReader.Machine.Start.Greetings.Save;
                $arg = 
                @{
                    string=$Global:XMLReader.Machine.Start.Greetings.InnerXml; # String 
                    Type=$Type; # Type of font
                    SaveToFile=$Save;
                };
                [String]$GreetingsPath = (Get-ChildItem $($Global:AppJson.Scripts.Greetings)).FullName; # Gets the full file path to the greetings script
                & $GreetingsPath @arg;
            }

            # If the script is defined, run it
            if(![String]::IsNullOrEmpty($Global:XMLReader.Machine.Start.Script) -and $(Test-Path $Global:XMLReader.Machine.Start.Script))
            {
                Invoke-Expression $(Evaluate -value:$Global:XMLReader.Machine.Start.Script);# Executes the file that the user defines
            } 
        }
    
    try 
    {
        if(![String]::IsNullOrEmpty($Global:XMLReader.Machine.ShellSettings.GitDisplay) -and ($Global:XMLReader.Machine.ShellSettings.Enabled.ToBoolean($null)) -and [string]::IsNullOrEmpty($BuildPath))
        {
            [String]$gitstring = "Version: $(git describe --tags)";
            if($gitstring.Contains("-")){Write-Host "`n$($gitstring.Substring(0,$gitstring.IndexOf("-")))`n" -ForegroundColor Gray;}
            else {Write-Host "`n$($gitstring)`n" -ForegroundColor Gray;}
        }
    }
    catch 
    {
        $LogHandler.Write("You may not have git bash installed.")
    }

Pop-Location;

# Method for start directory 
if($StartDir -and (![String]::IsNullOrEmpty($Global:XMLReader.Machine.ShellSettings.StartDirectory)) -and [string]::IsNullOrEmpty($BuildPath))
{
    if(Test-Path $Global:XMLReader.Machine.ShellSettings.StartDirectory){Set-Location $Global:XMLReader.Machine.ShellSettings.StartDirectory;}
    else{$Global:LogHandler.Warning("Configured Start directory does not exist.  Please check.")}
}

# For debug mode
# It will run the debug script after profile is loaded
if($DebugFlag)
{
    $DebugScript = $($Global:AppPointer.Machine.GitRepoDir + $Global:AppJson.Scripts.Debug);
    if(!(Test-Path $DebugScript)){New-Item $DebugScript -Force;}
    & $DebugScript;
}

$Global:LogHandler.Write("Successfully loaded profile");
