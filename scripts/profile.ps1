<#
.SYNOPSIS
    xPro Microsoft Powershell profile
#>

## VARIABLES START ##

$xproPath = $env:HOMEDRIVE + $env:HOMEPATH + "\.xpro";
$xproBin=$XPRO_PATH + "\xp.exe";
$success = $true;

## VARIABLES END ##

## FUNCTIONS START ## 

function loadObjects {
    $result = $true 
    $objectCount = -1;

    if ($result) {
        $objectCount=$(& $xproBin obj --count);
    }
}

## FUNCTIONS END ## 

## MAIN START ##

Push-Location $xproPath;

# If path exists then add path to path
if ($success) {
    $env:Path = $xproPath + ";" + $env:Path;

} else {
    Write-Warning "Path $xproPath does not exist!";
}

if ($success) {
    Import-Module $xproPath\xutil.psm1 -Scope Global;
    $success = $?;
}

Pop-Location;

if ($success) {
    Write-Host "Successfully loaded xPro";
} else {
    Write-Warning "Failed to load xPro";
}

## MAIN END ## 
