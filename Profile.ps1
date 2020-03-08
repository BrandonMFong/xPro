# Engineer: Brandon Fong
# TODO
# ...

<### CONFIG ###>
Push-Location $($PROFILE |Split-Path -Parent);
    [XML]$x = Get-Content Profile.xml;
Pop-Location
$ConfigFile = $x.Machine.GitRepoDir + "\Config\" + $x.Machine.ConfigFile;
[XML]$XMLReader = Get-Content $ConfigFile

Push-Location $x.Machine.GitRepoDir; 

    <### CHECK UPDATES ###>
        if(.\update-profile.ps1){throw "Profile was updated, please rerun Profile load.";}
        
    <### PROGRAMS ###> 
        foreach($val in $XMLReader.Machine.Programs.Program)
        {
            switch($val.Type)
            {
                "External"{Set-Alias $val.Alias "$($val.InnerXML)" -Verbose;}
                "Internal"{Set-Alias $val.Alias "$($x.Machine.GitRepoDir + $val.InnerXML)" -Verbose;}
                default {Write-Warning "$($val.Alias) : $($val.InnerXML)`n Not set!"}
            }
        }
    
    <### MODULES ###>
        foreach($val in $XMLReader.Machine.Modules.Module)
        {
            Import-Module $($x.Machine.GitRepoDir + $val);
        }
        
    <### OBJECTS ###>
        Import-Module $($x.Machine.GitRepoDir + '\Modules\MakeClassObject.psm1');
        foreach($val in $XMLReader.Machine.Objects.Object)
        {
            if($val.HasClass -eq "true"){New-Variable -Name "$($val.VarName)" -Value $(MakeClass -XmlElement $val) -Force -Verbose;}
            else {New-Variable -Name "$($val.VarName)" -Value $val -Force -Verbose;}
        }
    
    <### START ###>
        if($XMLReader.Machine.StartScript.ClearHost -eq "true"){Clear-Host;}
        Invoke-Expression $($x.Machine.GitRepoDir + $XMLReader.Machine.StartScript.InnerXML)

Pop-Location;