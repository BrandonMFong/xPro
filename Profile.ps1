# Engineer: Brandon Fong
# TODO
# ...

<### MODULES ###>
    using module .\.\Classes\Calendar.psm1;
    using module .\.\Classes\Math.psm1;
    using module .\.\Classes\SQL.psm1;
    using module .\.\Classes\Web.psm1;
    using module .\.\Classes\Windows.psm1;

<### CONFIG ###>
    Push-Location $($PROFILE |Split-Path -Parent);
        [XML]$x = Get-Content Profile.xml;
    Pop-Location
    $ConfigFile = $x.Machine.GitRepoDir + "\Config\" + $x.Machine.ConfigFile;
    [XML]$XMLReader = Get-Content $ConfigFile

<### CHECK UPDATES ###>
    Push-Location $x.Machine.GitRepoDir; 
        .\update-profile.ps1;
        .\update-classes.ps1;
    Pop-Location;

# TODO check for updates on the classes
    
<### ALIASES ###> 
    foreach($val in $XMLReader.Machine.Aliases.Alias)
    {
        Set-Alias $val.Name "$($val.InnerXML)" -Verbose;
    }

<### FUNCTIONS ###> 
    foreach($val in $XMLReader.Machine.Functions.Function)
    {
        $FunctionPath = $x.Machine.GitRepoDir + $val.InnerXML;
        Set-Alias $val.Name "$($FunctionPath)" -Verbose;
    }
    
<### OBJECTS ###>
    foreach($val in $XMLReader.Machine.Objects.Object)
    {
        New-Variable -Name "$($val.VarName)" -Value $val -Force -Verbose; 
    }
    
<### CLASSES ###>
    $Web = [Web]::new();
    $Math = [Calculations]::new();
    $Decode = [SQL]::new($Database.Database.DatabaseName, $Database.ServerInstance  , $Database.Database.Tables);
    $Windows = [Windows]::new();

<### START ###>
    Invoke-Expression $($x.Machine.GitRepoDir + $XMLReader.Machine.StartScript)