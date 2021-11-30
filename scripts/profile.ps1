<#
.SYNOPSIS
    xPro Microsoft Powershell profile
#>

$xproPath = $env:HOMEDRIVE + $env:HOMEPATH + "\.xpro";
$success = (Test-Path -Path $xproPath);

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
