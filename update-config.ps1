Param([string]$ConfigName=$null)
Push-Location $PSScriptRoot
    $ForPrompt = [System.Collections.ArrayList]::new(); 
    $ForConfig = [System.Collections.ArrayList]::new(); 
    $i = 1;
    Write-Host "Loading present config files on machine"
    Get-ChildItem .\Config\ |
        Foreach-Object{$ForPrompt.Add([string]$("$i - $($_.BaseName)"));$ForConfig.Add($_.BaseName);$i++}     
    
    Write-Host "Config files to choose from:"
    $ForPrompt;
    $ConfigIndex = Read-Host -Prompt "Number";
    $ForConfig[$ConfigIndex-1];

    # .\setup-env.ps1 -ConfigName $ForConfig[$ConfigIndex-1] -XmlOverride $true;
    Push-Location $($PROFILE |Split-Path -Parent);
        Remove-Item .\Profile.xml -Verbose;
        $XmlContent = 
            "<?xml version=`"1.0`" encoding=`"ISO-8859-1`"?>`n"+
            "   <Machine MachineName=`"$($env:COMPUTERNAME)`">`n"+
            "       <GitRepoDir>$($GitRepoDir)</GitRepoDir>`n"+
            "       <ConfigFile>$($ForConfig[$ConfigIndex-1]).xml</ConfigFile>`n"+
            "   </Machine>";
        New-Item Profile.xml -Value $XmlContent -Verbose;
    Pop-Location

Pop-Location