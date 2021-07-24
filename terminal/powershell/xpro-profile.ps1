<#
.SYNOPSIS
    xPro Microsoft Powershell profile
#>

Write-Host "Hello world from xPro!"

Import-Module -Name $PSScriptRoot\modules\xError.psm1

[xError]$error = [xError]::kNoError
