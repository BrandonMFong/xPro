<#
.SYNOPSIS
    xPro Microsoft Powershell profil
#>

Import-Module -Name $PSScriptRoot\modules\xError.psm1

[xError]$error = [xError]::kNoError;

if ($error -eq [xError]::kNoError) {
    Write-Host "NoError!"
}

