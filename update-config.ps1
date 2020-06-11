<#
.Synopsis
   Updates the config pointer
#>
Param([string]$ConfigName=$null,[Switch]$CheckUpdate)
Push-Location $PSScriptRoot
    
    # This segment runs independtly.  I could have made another script but the context of this script is similar to this segment's goal
    # Can probably be arranged better
    if($CheckUpdate)
    {
        [string[]]$Scripts = (Get-ChildItem $PSScriptRoot\Config\UpdateConfig\*.*).Name;
        if($Scripts.Count -ne [int]$XMLReader.Machine.UpdateStamp.Count)
        {
            Write-Host  "`nThere is an update to GlobalScripts Config." -ForegroundColor Red
            [string]$update = Read-Host -Prompt "Want to update? (y/n)";
            if($update -eq "y")
            {
                Import-Module $($PSScriptRoot + "\Modules\ConfigHandler.psm1") -Scope Local -DisableNameChecking;
                Run-Update; # Updates configuration file
                Pop-location; return 1; # Exiting code
            }
        }
        else{Pop-location;return 0;}
    }

    $ForPrompt = [System.Collections.ArrayList]::new(); 
    $ForConfig = [System.Collections.ArrayList]::new(); 
    $i = 1;
    Write-Host "Loading present config files on machine"
    Get-ChildItem .\Config\ |
        Foreach-Object{$ForPrompt.Add([string]$("$i - $($_.BaseName)"));$ForConfig.Add($_.Name);$i++}     
    clear-host;
    Write-Host "Config files to choose from:"
    $ForPrompt;
    $ConfigIndex = Read-Host -Prompt "Number";
    write-host  "Current Config => $($ForConfig[$ConfigIndex-1])";

    # .\setup-env.ps1 -ConfigName $ForConfig[$ConfigIndex-1] -XmlOverride $true;
    Push-Location $($PROFILE |Split-Path -Parent);
        [XML]$XmlEditor = Get-Content .\Profile.xml;
        $Path = $null;
        Get-ChildItem .\Profile.xml |ForEach-Object {$Path = $_.FullName;}
        $XmlEditor.Machine.ConfigFile = $ForConfig[$ConfigIndex-1];
        $XmlEditor.Save($Path);
    Pop-Location
Pop-Location