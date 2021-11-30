<#
.SYNOPSIS 
Creates link to xpro diredtory
#>

# User must be an adminstrator
#Requires -RunAsAdministrator

$success    = $true;
$xproPath   = $(Split-Path -Path $PSScriptRoot -Parent);
$libPath    = "C:\Library\xPro";

if (Test-Path -Path $libPath) {
    Write-Host "$libPath already exists!";
    $success = $false;
}

if ($success) {
    if (!(Test-Path $(Split-Path -Path $libPath -Parent))) {
        mkdir $(Split-Path -Path $libPath -Parent);
        $success = $?;
    }
}

if ($success) {
    Write-Host "Creating link from $xproPath to $libPath";
    New-Item -ItemType SymbolicLink -Path $libPath -Target $xproPath;
    $success = $?;
}

if ($success) {
    Write-Host "Success";
} else {
    Write-Host "Failed";
}

exit $success;