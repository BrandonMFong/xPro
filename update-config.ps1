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

        [String]$ParseString="MMddyyyy"
        [String[]]$UpgradeScripts = (Get-ChildItem $PSScriptRoot\Config\UpdateConfig\*.*).BaseName; # Only using the base name to determine update stamp
        $arg = @{Object=$UpgradeScripts;Method="SelectionSort";ParseString=$ParseString};
        $command = $(Get-ChildItem $($PSScriptRoot + "\Functions\Sort-Object.ps1")).FullName;
        [string[]]$InOrderScripts = $(& $command @arg);

        # There has to be a better way at checking if there is an update needed
        # if($Scripts.Count -gt [int]$XMLReader.Machine.UpdateStamp.Count) # TODO delete
        if([DateTime]::ParseExact($Scripts[$Scripts.Count-1].Replace(".ps1",$null),$ParseString,$null) -gt [DateTime]::ParseExact($XMLReader.Machine.UpdateStamp.Value,$ParseString,$null))
        {
            Write-Host  "`nThere is an update to GlobalScripts Config." -ForegroundColor Red
            [string]$update = Read-Host -Prompt "Want to update? (y/n)";
            if($update -eq "y")
            {
                Import-Module $($PSScriptRoot + "\Modules\ConfigHandler.psm1") -Scope Local -DisableNameChecking;
                Run-Update -InOrderScripts:$InOrderScripts; # Updates configuration file
                Pop-location; 
                
                Write-Warning "Config was updated";
                return 1; # Exiting code
            }
            else{Pop-Location; return 0;}
        }
        else{Pop-location;return 0;}
    }

    # Load files
    [String[]]$ForPrompt = [String[]]::new($null); 
    [String[]]$ForConfig = [String[]]::new($null); 
    $ForPrompt = $(Get-ChildItem .\Config\ | Where-Object{$_.Mode -eq "-a---"}).BaseName;
    for([int16]$i=0;$i -lt $ForPrompt.Length;$i++)
    {
        $ForPrompt[$i] = "$($i+1) - " + $ForPrompt[$i];
    }
    $ForConfig = $(Get-ChildItem .\Config\ | Where-Object{$_.Mode -eq "-a---"}).Name;

    Write-Host "Config files to choose from:"
    $ForPrompt;
    $ConfigIndex = Read-Host -Prompt "Number";
    Write-Host  "`nCurrent Config => $($ForConfig[$ConfigIndex-1])`n" -ForegroundColor Cyan;

    Push-Location $($PROFILE |Split-Path -Parent);
        [System.Xml.XmlDocument]$XmlEditor = Get-Content .\Profile.xml;
        [String]$Path = $(Get-ChildItem .\Profile.xml).FullName;
        # Get-ChildItem .\Profile.xml |ForEach-Object {$Path = $_.FullName;}
        $XmlEditor.Machine.ConfigFile = $ForConfig[$ConfigIndex-1];
        $XmlEditor.Save($Path);
    Pop-Location
Pop-Location