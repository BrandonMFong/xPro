<#
.SYNOPSIS 
Builds debug versions of source files
#>

$success            = $true;
$xproPath           = $(Split-Path -Path $PSScriptRoot -Parent);
$binPath            = $xproPath + "\\bin";
$xproCLISourcePath  = "src/xpro-cli/Debug (windows)"; # xpro-cli source file path
$xpBuild            = "debug-xp.exe";

Push-Location $xproPath;

if (!(Test-Path -Path $binPath)) {
    mkdir $binPath;
    $success = $?;
}

Push-Location $xproCLISourcePath;

if ($success) {
    Write-Host "Building xPro CLI";
    make.exe clean;
    make.exe all;
    $success = $?;
}

if ($success) {
    if (Test-Path -Path $binPath/$xpBuild) {
        Remove-Item -Path $binPath/$xpBuild -Recurse -Force;
        $success = $?;
    }
}

if ($success) {
    Copy-Item -Path $xpBuild -Destination $binPath
}

Pop-Location; # $xproCLISourcePath

Pop-Location; # $xproPath

if ($success) {
    Write-Host "Success";
} else {
    Write-Host "Failed";
}

exit $success;
