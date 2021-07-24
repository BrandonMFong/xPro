<#
.SYNOPSIS
    xPro Microsoft Powershell profile
#>

enum xError {
    kUnknownError = 0
    kNoError = 1
}

[xError]$error = [xError]::kNoError;

if ($error -eq [xError]::kNoError) {
    Write-Host "NoError!"
}

