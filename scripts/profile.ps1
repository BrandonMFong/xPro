<#
.SYNOPSIS
    xPro Microsoft Powershell profile
#>

using module .\modules\xError.psm1

[xError]$error = [xError]::kNoError;

if ($error -eq [xError]::kNoError) {
    Write-Host "NoError!"
}

