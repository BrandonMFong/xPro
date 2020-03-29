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
    Import-Module .\Modules\FunctionModules.psm1;
    Import-Module .\Modules\Prompt.psm1;

    <### CHECK UPDATES ###>
        if(.\update-profile.ps1){throw "Profile was updated, please rerun Profile load.";}
        
    <### PROGRAMS ###> 
        foreach($val in $XMLReader.Machine.Programs.Program)
        {
            switch($val.Type)
            {
                "External"{Set-Alias $val.Alias "$($val.InnerXML)" -Verbose;}
                "Internal"{Set-Alias $val.Alias "$($AppPointer.Machine.GitRepoDir + $val.InnerXML)" -Verbose;}
                default {Write-Error "$($val.Alias) => $($val.InnerXML)`n Not set!"}
            }
        }
    
    <### MODULES ###>
        foreach($val in $XMLReader.Machine.Modules.Module)
        {
            Import-Module $($AppPointer.Machine.GitRepoDir + $val);
        }
        
    <### OBJECTS ###>
        foreach($val in $XMLReader.Machine.Objects.Object)
        {
            switch ($val.Type)
            {
                "PowerShellClass"{New-Variable -Name "$($val.VarName)" -Value $(MakeClass -XmlElement $val) -Force -Verbose;break;}
                "XmlElement"{New-Variable -Name "$($val.VarName)" -Value $val -Force -Verbose;break;}
                "HashTable"{New-Variable -Name "$(GetVarName -value $val.VarName)" -Value $(MakeHash -value $val -lvl 0 -Node $null) -Force -Verbose; break;}
                default {New-Variable -Name "$($val.VarName)" -Value $val.Values -Force -Verbose;break;}
            }
        } 
    
    <### START ###>
        if($XMLReader.Machine.StartScript.ClearHost -eq "true"){Clear-Host;}
        Invoke-Expression $($AppPointer.Machine.GitRepoDir + $XMLReader.Machine.StartScript.InnerXML)

    try 
    {
        Write-Host "Version - $(git describe --tags) `n" -ForegroundColor Gray;
    }
    catch 
    {
        Write-Warning "You may not have posh-git installed in powershell"
    }

Pop-Location;