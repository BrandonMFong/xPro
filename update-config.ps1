Param([string]$ConfigName=$null)
Push-Location $PSScriptRoot
    
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